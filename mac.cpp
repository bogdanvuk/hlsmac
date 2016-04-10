#include "mac.hpp"

typedef struct {
	ap_uint<48>      src;
	ap_uint<48>      dst;
	ap_uint<16>      len_type;
}t_eth_fields;

//enum e_mac_state {
//	s_idle 		= 0,
//	s_header 	= 1,
//	s_data		= 2,
//	s_pad		= 3,
//	s_fcs		= 4
//};

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

ap_uint<32> crc_state = 0xffffffff;
//enum e_mac_state state = s_idle;
int state = s_idle;
t_eth_fields fields;
int frm_cnt = 0;
//t_axis last_axis_out;

ap_uint<8> last_axis_data;
int output_last;

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

//void update_state(t_mac_state *state, int frm_cnt) {
//	switch (*state) {
//	case s_header:
//		if (frm_cnt >= 14)
//		{
//			*state = s_data;
//		}
//		break;
//	case s_data:
//		if (pipeline0.dv == 0)
//		{
//			*state = s_fcs;
//		}
//		break;
//	case s_fcs:
//		if (pipeline4.dv == 0)
//		{
//			*state = s_header;
//		}
//		break;
//	default:
//		*state = s_header;
//	}
//}

//void send_axis(hls::stream<t_axis> &m_axis, ap_uint<8> data, ap_uint<1> user, ap_uint<1> last) {
//	t_axis item;
//
//	m_axis.write( {cur.rxd, 0, 0} );
//}

void mac( t_gmii gmii, hls::stream<t_axis> &m_axis)
{
//	#pragma HLS data_pack variable=gmii
	#pragma HLS INTERFACE ap_none port=gmii
	#pragma HLS INTERFACE axis port=m_axis

//	int last = 0;
//	t_axis m_axis_out = {0x00, 0, 0, 0};

	pipeline_push(gmii);
	t_gmii cur = pipeline5; //[PIPELINE_LEN-1];
//	update_state(&state, frm_cnt);
	extract_fields(fields, frm_cnt, cur.rxd);
#ifndef __SYNTHESIS__
	printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
#endif

	if (cur.dv) {
		switch (state) {
			case s_idle:
				if (cur.rxd == 0xd5) {
					state = s_header;
				}
				break;
			case s_header:
				crc32(cur.rxd, &crc_state);
				m_axis.write((t_axis) {cur.rxd, 0, 0});
				if (frm_cnt >= 14) {
					state = s_data;
				}
				frm_cnt++;
				break;
			case s_data:
				crc32(cur.rxd, &crc_state);
				if (pipeline0.dv == 0) {
					state = s_fcs;
					last_axis_data = cur.rxd;
				} else {
					m_axis.write((t_axis) {cur.rxd, 0, 0});
				}
				frm_cnt++;
				break;
			case s_pad:
				crc32(cur.rxd, &crc_state);
				if (pipeline0.dv == 0) {
					state = s_fcs;
				}
				break;
			case s_fcs:
				crc32(cur.rxd, &crc_state);
				output_last = 1;
				break;
		}
	} else {
		if (output_last == 1) {
			if ((~crc_state) != 0x2144DF1C) {
				m_axis.write((t_axis) {last_axis_data, 1, 1});
			} else {
				m_axis.write((t_axis) {last_axis_data, 0, 1});
			}
		}
		output_last = 0;
		state = s_idle;
		crc_state = 0xffffffff;
		frm_cnt = 0;
	}


//	*m_axis = m_axis_out;

}

//void mac( t_gmii gmii, hls::stream<t_axis> &m_axis )
//{
//	#pragma HLS data_pack variable=gmii
//	#pragma HLS INTERFACE ap_none port=gmii
//	#pragma HLS INTERFACE axis port=m_axis
//
//	int last = 0;
//
//	pipeline_push(gmii);
//	t_gmii cur = pipeline5; //[PIPELINE_LEN-1];
////	update_state(&state, frm_cnt);
//	extract_fields(fields, frm_cnt, cur.rxd);
//#ifndef __SYNTHESIS__
//	printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
//#endif
//
//	switch (state) {
//	    case s_idle:
//	    	if (pipeline4.dv == 1) {
////	    		crc_state = 0xffffffff;
//	    		state = s_header;
//	    		frm_cnt = 0;
//	    	}
//	    	break;
//		case s_header:
//			crc32(cur.rxd, &crc_state);
//			m_axis.write( (t_axis) {cur.rxd, 0, 0} );
//			if (frm_cnt >= 14) {
//				state = s_data;
//			}
//			frm_cnt++;
//			break;
//		case s_data:
//			crc32(cur.rxd, &crc_state);
//			if (pipeline0.dv == 0) {
//				state = s_fcs;
//				last_axis_out = (t_axis){cur.rxd, 0, 1};
//			} else {
//				m_axis.write((t_axis){cur.rxd, 0, 0});
//			}
//			frm_cnt++;
//			break;
//		case s_pad:
//			crc32(cur.rxd, &crc_state);
//			if (pipeline0.dv == 0) {
//				state = s_fcs;
//			}
//			break;
//		case s_fcs:
//			if (pipeline5.dv == 0) {
////				if ((~crc_state) != 0x2144DF1C) {
////					last_axis_out.user = 1;
////				}
////				m_axis.write(last_axis_out);
////				crc_state = 0xffffffff;
//				state = s_header;
//				frm_cnt = 0;
//			} else {
//				crc32(cur.rxd, &crc_state);
//			}
//			break;
//	}
//
//}

//void mac( hls::stream<t_gmii> &gmii, hls::stream<t_axis> &m_axis )
//{
//	#pragma HLS data_pack variable=gmii
//	#pragma HLS INTERFACE axis port=gmii
//	#pragma HLS INTERFACE axis port=m_axis
//
//	int last = 0;
//	enum e_mac_state state;
//	t_eth_fields fields;
//	int frm_cnt;
//	ap_uint<32> crc_state = 0xffffffff;
//
//	PRELOAD_PIPELINE: while (!pipeline4.dv) {
//		pipeline_push(gmii.read());
//	}
//
//	frm_cnt = 0;
//	state = s_header;
//	DEFRAME: do
//	{
//		t_gmii cur = pipeline4; //[PIPELINE_LEN-1];
//		update_state(&state, frm_cnt);
//		extract_fields(fields, frm_cnt, cur.rxd);
//		crc32(cur.rxd, &crc_state);
//#ifndef __SYNTHESIS__
//		printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
//#endif
//		t_axis dout;
//		dout.data = cur.rxd;
//		dout.last = 0;
//		dout.user = 0;
//
//		switch (state) {
//			case s_header:
//			case s_data:
//				m_axis.write( dout );
//				break;
//			case s_fcs:
//				break;
//		}
//
//		pipeline_push(gmii.read());
//		frm_cnt++;
//		last = !pipeline4.dv.to_int();
//	} while(!last);
//
//	t_axis dout;
//	if ((~crc_state) == 0x2144DF1C) {
//		dout.user = 0;
//	} else {
//		dout.user = 1;
//	}
//
//	dout.data = 0;
//	dout.last = 1;
//	m_axis.write(dout);
//}


