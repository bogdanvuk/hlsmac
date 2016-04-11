#include "mac.hpp"

typedef struct {
	ap_uint<48>      src;
	ap_uint<48>      dst;
	ap_uint<16>      len_type;
}t_eth_fields;

#define	s_idle 		0
#define	s_header 	1
#define s_data		2
#define	s_pad		3
#define	s_fcs		4

t_gmii pipeline5 = {0x00, 0, 0};
t_gmii pipeline4 = {0x00, 0, 0};
t_gmii pipeline3 = {0x00, 0, 0};
t_gmii pipeline2 = {0x00, 0, 0};
t_gmii pipeline1 = {0x00, 0, 0};
t_gmii pipeline0 = {0x00, 0, 0};

t_rx_statistic_counters rx_statistic_counters = {
		0x00000000
};

ap_uint<32> crc_state = 0xffffffff;
//enum e_mac_state state = s_idle;
int state = s_idle;
t_eth_fields fields;
int frm_cnt = 0;
int usr_cnt = 0;
int data_err = 0;
ap_uint<8> len_type_high = 0;
//t_axis last_axis_out;

ap_uint<8> last_axis_data;
int output_last;

#define is_type(x) ((x) >= 0x0600)
#define is_len(x) ((x) <= 0x05DC)

void crc32(ap_uint<8> din, ap_uint<32>* crc_state){
	#pragma HLS INLINE
	unsigned j;

	*crc_state ^= din;
	CRC32_LOOP: for (j = 8; j > 0; j--) {    // Do eight times.
	#pragma HLS UNROLL
       ap_uint<32> mask = -(*crc_state & 1);
       *crc_state = (*crc_state >> 1) ^ (0xEDB88320 & mask);
    }
}

void extract_fields(t_eth_fields &fields, int frm_cnt, ap_uint<8> frm_data) {
	#pragma HLS INLINE
	switch (frm_cnt) {
		case 12: fields.len_type = frm_data.to_int() << 8; break;
		case 13: fields.len_type |= frm_data.to_int(); break;
	}
}

void pipeline_push(t_gmii item) {
	pipeline5 = pipeline4;
	pipeline4 = pipeline3;
	pipeline3 = pipeline2;
	pipeline2 = pipeline1;
	pipeline1 = pipeline0;
	pipeline0 = item;
}


void receive(
		t_gmii gmii,
		hls::stream<t_axis> &m_axis,
		hls::stream<t_rx_status> &rx_status
		)
{
	//	#pragma HLS data_pack variable=gmii
	//#pragma HLS interface ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=gmii
	#pragma HLS data_pack variable=rx_status
	#pragma HLS INTERFACE axis port=m_axis
	#pragma HLS LATENCY max=0 min=0

	int next_state;
	int start_pad_immediate;
	//	int last = 0;
	//	t_axis m_axis_out = {0x00, 0, 0, 0};

	pipeline_push(gmii);
	t_gmii cur = pipeline5; //[PIPELINE_LEN-1];
	//	update_state(&state, frm_cnt);
	#ifndef __SYNTHESIS__
	printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
	#endif

	if (cur.dv) {
		if (cur.er) {
			data_err = 1;
		}

		next_state = state;
		switch (state) {
			case s_idle:
				if (cur.rxd == 0xd5) {
					next_state = s_header;
				}
				break;
			case s_header:
				start_pad_immediate = 0;
				extract_fields(fields, frm_cnt, cur.rxd);
				if (frm_cnt == 12) {
					len_type_high = cur.rxd;
				} else if (frm_cnt == 13) {
					ap_uint<8> len_type_low = cur.rxd;
					if ((!len_type_high) && (!len_type_low)) {
						start_pad_immediate = 1;
					}
					next_state = s_data;
				}

				if (!start_pad_immediate) {
					m_axis.write((t_axis) {cur.rxd, 0, 0});
				} else {
					next_state = s_pad;
					last_axis_data = cur.rxd;
				}
				break;
			case s_data:
				usr_cnt++;
				if (pipeline0.dv == 0) {
					next_state = s_fcs;
					last_axis_data = cur.rxd;
				} else if (usr_cnt >= fields.len_type){
					next_state = s_pad;
					last_axis_data = cur.rxd;
				} else {
					m_axis.write((t_axis) {cur.rxd, 0, 0});
				}
				break;
			case s_pad:
				if (pipeline0.dv == 0) {
					next_state = s_fcs;
				}
				break;
			case s_fcs:
				output_last = 1;
				break;
		}

		switch (state) {
			case s_header:
			case s_data:
			case s_pad:
			case s_fcs:
				crc32(cur.rxd, &crc_state);
				frm_cnt++;
				break;
		}

		state = next_state;

	} else {
		if (output_last == 1) {
			//0xDEBB20E3 = ~0x2144DF1C, so that crc_state needs not be inverted
			int fcs_err = (crc_state != 0xDEBB20E3);
			int len_err = 0;
			int under = (frm_cnt < 64);
			int over = (frm_cnt > 1500);

			if (is_len(fields.len_type)) {
				len_err = (fields.len_type != usr_cnt);

			}

			int good = !(fcs_err | len_err | data_err | under | over);
			rx_status.write((t_rx_status) {frm_cnt, good, 0, 0, under, len_err, fcs_err, data_err, 0, over});

			if (good) {
				rx_statistic_counters.good_frames++;
			}

			m_axis.write((t_axis) {last_axis_data, !good, 1});
		}
		output_last = 0;
		usr_cnt = 0;
		state = s_idle;
		crc_state = 0xffffffff;
		frm_cnt = 0;
		data_err = 0;
	}

}
void mac(
		t_gmii gmii,
		hls::stream<t_axis> &m_axis,
		hls::stream<t_rx_status> &rx_status
		)
{
	//#pragma HLS interface ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=gmii
	#pragma HLS data_pack variable=rx_status
	#pragma HLS INTERFACE ap_hs port=rx_status
	#pragma HLS INTERFACE axis port=m_axis

    #pragma HLS INTERFACE s_axilite port=rx_statistic_counters offset=0x0200

//	hls::stream<t_rx_status> rx_status_int;

	receive(gmii, m_axis, rx_status);

//	if (!rx_status_int.empty()) {
//		t_rx_status rx_stat = rx_status_int.read();
//		rx_status.write(rx_stat);
//
////		if (rx_stat.good) {
////			rx_statistic_counters.good_frames++;
////		}
//	}
//	*good_frames = rx_statistic_counters.good_frames;
}
