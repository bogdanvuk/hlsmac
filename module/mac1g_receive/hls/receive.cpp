#include "receive.hpp"
#include "crc32.hpp"
#include "ap_shift_reg.h"

#include <stdio.h>

ap_uint<32> crc_state = 0xffffffff;
ap_uint<16> frm_cnt = 0;
ap_uint<16> usr_cnt = 0;
int data_err = 0;
ap_uint<16> len_type = 0xffff;
t_s_gmii cur;
static ap_shift_reg<t_s_gmii, 5> pipeline;

#define is_type(x) ((x) >= 0x0600)
#define is_len(x) ((x) <= 0x05DC)

#define SFD_CHAR      0xd5

void receive(
             hls::stream<t_s_gmii> &s_gmii,
             hls::stream<t_axis> &m_axis,
             t_rx_status* rx_status
             )
{

#pragma HLS interface ap_ctrl_none port=return
#pragma HLS data_pack variable=s_gmii
#pragma HLS INTERFACE axis port=m_axis
#pragma HLS data_pack variable=rx_status
#pragma HLS INTERFACE ap_ovld port=rx_status
    int i;
    t_s_gmii din;
    t_s_gmii ignore;
    t_s_gmii last;
    int output_en;

 MAIN: while (1) {
#pragma HLS PIPELINE rewind

        frm_cnt = 0;
        output_en = 1;
        crc_state = 0xffffffff;
        len_type = 0xffff;
        usr_cnt = 0;
        if (!s_gmii.read_nb(din)) return;
        cur = pipeline.shift(din);

    IDLE_AND_PREAMBLE: while (!(cur.dv && (cur.rxd == SFD_CHAR))) {
#pragma HLS LATENCY max=0 min=0
            if (!s_gmii.read_nb(din)) return;
            cur = pipeline.shift(din);
        }

        if (!s_gmii.read_nb(din)) return;
        cur = pipeline.shift(din);

    USER_DATA: do {
#pragma HLS LATENCY max=0 min=0
    	if (frm_cnt < 14) {
    		m_axis.write((t_axis){cur.rxd, 0, 0});
			if (frm_cnt == 12) {
				len_type = (len_type & 0xff00) | cur.rxd;
			} else if (frm_cnt == 13) {
				len_type = (len_type << 8) | cur.rxd;
			}
    	} else {
            if (output_en) {
                if (din.dv && (len_type != 0) && (usr_cnt < len_type - 1)) {
                    usr_cnt++;
                    m_axis.write((t_axis){cur.rxd, 0, 0});
                } else {
                    usr_cnt++;
                    last = cur;
                    output_en = 0;
                }
            }
    	}
            frm_cnt++;
            crc32(cur.rxd, &crc_state);

            if (!s_gmii.read_nb(din)) return;
            cur = pipeline.shift(din);

            printf("Data 0x%x, FCS 0x%x\n", cur.rxd.to_int(), ~crc_state.to_int()); \
            //if (!gmii_input(s_gmii, din, cur, pipeline, &empty)) goto FRAME_END;
        } while(cur.dv);

        int fcs_err = (crc_state != 0xDEBB20E3);
        int len_err = 0;
        int under = (frm_cnt < 64);
        int over = (frm_cnt > 1500);

        if (is_len(len_type)) {
            len_err = (len_type != usr_cnt);

        }

        int good = !(fcs_err | len_err | data_err | under | over);
        *rx_status = (t_rx_status) {frm_cnt, good, 0, 0, under, len_err, fcs_err, data_err, 0, over};
        m_axis.write((t_axis){last.rxd, !good, 1});
        if (!s_gmii.read_nb(din)) return;
        cur = pipeline.shift(din);
    }
}
