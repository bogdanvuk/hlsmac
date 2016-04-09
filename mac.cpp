#include "mac.hpp"

typedef struct {
	ap_uint<48>      src;
	ap_uint<48>      dst;
	ap_uint<16>      len_type;
}t_eth_fields;

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

enum e_mac_state{s_header, s_data, s_pad, s_fcs};
t_gmii pipeline4 = {0x00, 0, 0};
t_gmii pipeline3 = {0x00, 0, 0};
t_gmii pipeline2 = {0x00, 0, 0};
t_gmii pipeline1 = {0x00, 0, 0};
t_gmii pipeline0 = {0x00, 0, 0};

void pipeline_push(t_gmii item) {
	pipeline4 = pipeline3;
	pipeline3 = pipeline2;
	pipeline2 = pipeline1;
	pipeline1 = pipeline0;
	pipeline0 = item;
}

void update_state(enum e_mac_state *state, int frm_cnt) {
	switch (*state) {
	case s_header:
		if (frm_cnt >= 14)
		{
			*state = s_data;
		}
		break;
	case s_data:
		if (pipeline0.dv == 0)
		{
			*state = s_fcs;
		}
		break;
	case s_fcs:
		if (pipeline4.dv == 0)
		{
			*state = s_header;
		}
		break;
	default:
		*state = s_header;
	}
}

void mac( hls::stream<t_gmii> &gmii, hls::stream<t_axis> &m_axis )
{
	int last = 0;
	enum e_mac_state state;
	t_eth_fields fields;
	int frm_cnt;
	ap_uint<32> crc_state = 0xffffffff;

	PRELOAD_PIPELINE: while (!pipeline4.dv) {
		pipeline_push(gmii.read());
	}

	frm_cnt = 0;
	state = s_header;
	DEFRAME: do
	{
		t_gmii cur = pipeline4; //[PIPELINE_LEN-1];
		update_state(&state, frm_cnt);
		extract_fields(fields, frm_cnt, cur.rxd);
		crc32(cur.rxd, &crc_state);
#ifndef __SYNTHESIS__
		printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
#endif
		t_axis dout;
		dout.data = cur.rxd;
		dout.last = 0;
		dout.user = 0;

		switch (state) {
			case s_header:
			case s_data:
				m_axis.write( dout );
				break;
			case s_fcs:
				break;
		}

		pipeline_push(gmii.read());
		frm_cnt++;
		last = !pipeline4.dv.to_int();
	} while(!last);

	t_axis dout;
	if ((~crc_state) == 0x2144DF1C) {
		dout.user = 0;
	} else {
		dout.user = 1;
	}

	dout.data = 0;
	dout.last = 1;
	m_axis.write(dout);
}


