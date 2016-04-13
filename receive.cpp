#include "receive.hpp"
#include "fcs.hpp"
#include "ap_shift_reg.h"

typedef struct {
    ap_uint<48>      src;
    ap_uint<48>      dst;
    ap_uint<16>      len_type;
}t_eth_fields;

#define s_idle          0
#define s_header        1
#define s_data          2
#define s_pad           3
#define s_fcs           4

typedef struct{
	ap_uint<1> valid;
	ap_uint<8> data;
	ap_uint<1> user;
	ap_uint<1> last;
}t_pipeline;

//t_gmii pipeline5 = {0x00, 0, 0};
//t_gmii pipeline4 = {0x00, 0, 0};
//t_gmii pipeline3 = {0x00, 0, 0};
//t_gmii pipeline2 = {0x00, 0, 0};
//t_gmii pipeline1 = {0x00, 0, 0};
//t_gmii pipeline0 = {0x00, 0, 0};
//
//t_rx_statistic_counters rx_statistic_counters = {
//    0x00000000
//};

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

void extract_fields(t_eth_fields &fields, int frm_cnt, ap_uint<8> frm_data) {
#pragma HLS INLINE
    switch (frm_cnt) {
    case 12: fields.len_type = frm_data.to_int() << 8; break;
    case 13: fields.len_type |= frm_data.to_int(); break;
    }
}

//void pipeline_push(t_gmii item) {
//    pipeline5 = pipeline4;
//    pipeline4 = pipeline3;
//    pipeline3 = pipeline2;
//    pipeline2 = pipeline1;
//    pipeline1 = pipeline0;
//    pipeline0 = item;
//}

#define SFD_CHAR      0xd5

int gmii_input(hls::stream<t_s_gmii> &s_gmii, t_s_gmii &din, t_s_gmii &cur, ap_shift_reg<t_s_gmii, 5> &pipeline) {
#pragma HLS INLINE
	s_gmii.read_nb(din);
	cur = pipeline.shift(din);
	return cur.dv;
}

#define axis_output(d)                          \
    do {                                        \
        frm_cnt++;                              \
        crc32(d, &crc_state);                   \
        m_axis.write((t_axis){d, 0, 0});     \
    } while(0)

void receive(
    hls::stream<t_s_gmii> &s_gmii,
    hls::stream<t_axis> &m_axis, 
    t_rx_status* rx_status
    ) {
//#pragma HLS interface ap_ctrl_none port=return
//#pragma HLS data_pack variable=s_gmii

#pragma HLS INTERFACE axis port=m_axis
#pragma HLS data_pack variable=rx_status
#pragma HLS INTERFACE ap_ovld port=rx_status
#pragma HLS LOOP_MERGE
    int i;
    t_s_gmii din;
    t_s_gmii cur;
    ap_uint<16> len_type = 0xffff;
    t_s_gmii ignore;
    static ap_shift_reg<t_s_gmii, 5> pipeline;

    do {
    	gmii_input(s_gmii, din, cur, pipeline);
    } while(!cur.dv);

  PREAMBLE: do {
	if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;
    } while (cur.rxd != SFD_CHAR);

  if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;

//  SRC_DEST: for(i = 0; i < 12; i++) {
//	    axis_output(cur.rxd);
//        if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;
//    }
//  {
//#pragma HLS LATENCY max=1 min=1
//	len_type = cur.rxd;
//	axis_output(cur.rxd);
//	if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;
//	len_type = (len_type << 8) | cur.rxd;
//
////    if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;
//
//  }
//    axis_output(din.rxd);

    USER_DATA: while(din.dv) {
#pragma HLS LATENCY max=0 min=0
    	if (frm_cnt == 12) {
    		len_type = cur.rxd;
    	} else if (frm_cnt == 13) {
    		len_type = (len_type << 8) | cur.rxd;
    	}
    	axis_output(cur.rxd);
    	if (!gmii_input(s_gmii, din, cur, pipeline)) goto FRAME_END;
    }

    FCS: for(i = 0; i < 3; i++) {
#pragma HLS LATENCY max=0 min=0
    	if (!gmii_input(s_gmii, din, ignore, pipeline)) goto FRAME_END;
    }

  FRAME_END:
    gmii_input(s_gmii, din, ignore, pipeline);
    m_axis.write((t_axis){cur.rxd, 1, 1});
}

//      int next_state;
//      int start_pad_immediate;
// //   int last = 0;
// //   t_axis m_axis_out = {0x00, 0, 0, 0};

//      pipeline_push(gmii);
//      t_gmii cur = pipeline5; //[PIPELINE_LEN-1];
// //   update_state(&state, frm_cnt);
// #ifndef __SYNTHESIS__
//      printf("cnt %d, state %d, din 0x%x, crc: 0x%x\n", frm_cnt, state, cur.rxd.to_int(), (~crc_state));
// #endif

//      if (cur.dv) {
//        if (cur.er) {
//             data_err = 1;
//        }

//        next_state = state;
//        switch (state) {
//        case s_idle:
//             if (cur.rxd == 0xd5) {
//                  next_state = s_header;
//             }
//             break;
//        case s_header:
//             start_pad_immediate = 0;
//             extract_fields(fields, frm_cnt, cur.rxd);
//             if (frm_cnt == 12) {
//                  len_type_high = cur.rxd;
//             } else if (frm_cnt == 13) {
//                  ap_uint<8> len_type_low = cur.rxd;
//                  if ((!len_type_high) && (!len_type_low)) {
//                       start_pad_immediate = 1;
//                  }
//                  next_state = s_data;
//             }

//             if (!start_pad_immediate) {
//                  m_axis.write((t_axis) {cur.rxd, 0, 0});
//             } else {
//                  next_state = s_pad;
//                  last_axis_data = cur.rxd;
//             }
//             break;
//        case s_data:
//             usr_cnt++;
//             if (pipeline0.dv == 0) {
//                  next_state = s_fcs;
//                  last_axis_data = cur.rxd;
//             } else if (usr_cnt >= fields.len_type){
//                  next_state = s_pad;
//                  last_axis_data = cur.rxd;
//             } else {
//                  m_axis.write((t_axis) {cur.rxd, 0, 0});
//             }
//             break;
//        case s_pad:
//             if (pipeline0.dv == 0) {
//                  next_state = s_fcs;
//             }
//             break;
//        case s_fcs:
//             output_last = 1;
//             break;
//        }

//        switch (state) {
//        case s_header:
//        case s_data:
//        case s_pad:
//        case s_fcs:
//             crc32(cur.rxd, &crc_state);
//             frm_cnt++;
//             break;
//        }

//        state = next_state;

//      } else {
//        if (output_last == 1) {
//             //0xDEBB20E3 = ~0x2144DF1C, so that crc_state needs not be inverted
//             int fcs_err = (crc_state != 0xDEBB20E3);
//             int len_err = 0;
//             int under = (frm_cnt < 64);
//             int over = (frm_cnt > 1500);

//             if (is_len(fields.len_type)) {
//                  len_err = (fields.len_type != usr_cnt);

//             }

//             int good = !(fcs_err | len_err | data_err | under | over);
//             rx_status.write((t_rx_status) {frm_cnt, good, 0, 0, under, len_err, fcs_err, data_err, 0, over});

//             //                       if (good) {
//             //                               rx_statistic_counters.good_frames++;
//             //                       }

//             m_axis.write((t_axis) {last_axis_data, !good, 1});
//        }
//        output_last = 0;
//        usr_cnt = 0;
//        state = s_idle;
//        crc_state = 0xffffffff;
//        frm_cnt = 0;
//        data_err = 0;
//      }

// }
// void mac(
//      t_gmii gmii,
//      hls::stream<t_axis> &m_axis,
//      hls::stream<t_rx_status> &rx_status,
//      int* test
//      )
// {
//      //#pragma HLS interface ap_ctrl_none port=return
// #pragma HLS INTERFACE ap_none port=gmii
// #pragma HLS data_pack variable=rx_status
// #pragma HLS INTERFACE ap_hs port=rx_status
// #pragma HLS INTERFACE axis port=m_axis
// #pragma HLS INTERFACE ap_ovld port=test

//      //      #pragma HLS INTERFACE ap_ovld port=rx_statistic_counters
//      //    #pragma HLS INTERFACE s_axilite port=rx_statistic_counters offset=0x0200

//      hls::stream<t_rx_status> rx_status_int;

//      receive(gmii, m_axis, rx_status_int);

//      if (!rx_status_int.empty()) {
//        t_rx_status rx_stat = rx_status_int.read();
//        *test = rx_stat.good;
//        //            t_rx_status rx_stat = rx_status_int.read();
//        //            rx_status.write(rx_stat);
//        //
//        ////          if (rx_stat.good) {
//        ////                  rx_statistic_counters.good_frames++;
//        ////          }
//      }
//      //      *good_frames = rx_statistic_counters.good_frames;
// }
