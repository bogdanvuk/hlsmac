#include <stdio.h>

#include "receive.hpp"

int frm1[] = {
    0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xd5,
    0x00, 0x10, 0xa4, 0x7b, 0xea, 0x80, 0x00, 0x12,
    0x34, 0x56, 0x78, 0x90, 0x08, 0x00, 0x45, 0x00,
    0x00, 0x2e, 0xb3, 0xfe, 0x00, 0x00, 0x80, 0x11,
    0x05, 0x40, 0xc0, 0xa8, 0x00, 0x2c, 0xc0, 0xa8,
    0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1a,
    0x2d, 0xe8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
    0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,
    0x0e, 0x0f, 0x10, 0x11, 0xb3, 0x31, 0x88, 0x1b};

int frm2[] = {
    0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xd5,
    0x00, 0x10, 0xa4, 0x7b, 0xea, 0x80, 0x00, 0x12,
    0x34, 0x56, 0x78, 0x90, 0x00, 0x2e, 0x45, 0x00,
    0x00, 0x2e, 0xb3, 0xfe, 0x00, 0x00, 0x80, 0x11,
    0x05, 0x40, 0xc0, 0xa8, 0x00, 0x2c, 0xc0, 0xa8,
    0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1a,
    0x2d, 0xe8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
    0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,
    0x0e, 0x0f, 0x10, 0x11, 0x8d, 0x69, 0x70, 0x3e};

int frm3[] = {
    0x55, 0xd5,
    0x00, 0x10, 0xa4, 0x7b, 0xea, 0x80, 0x00, 0x12,
    0x34, 0x56, 0x78, 0x90, 0x00, 0x02, 0x45, 0x00,
    0x00, 0x2e, 0xb3, 0xfe, 0x00, 0x00, 0x80, 0x11,
    0x05, 0x40, 0xc0, 0xa8, 0x00, 0x2c, 0xc0, 0xa8,
    0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1a,
    0x2d, 0xe8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
    0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,
    0x0e, 0x0f, 0x10, 0x11, 0xd8, 0x47, 0x84, 0xff};

typedef struct {
    int* data;
    int len;
}t_frame;

#define frm_inst(f) ((t_frame) {(f), sizeof(f) / sizeof(int)})

t_frame frames[] = {
    frm_inst(frm1),
    frm_inst(frm2),
    frm_inst(frm3)
};

#define FRAMES_CNT sizeof(frames) / sizeof(t_frame)

int main()
{
    int i;
    int j;
    hls::stream<t_axis> s_axis;
    hls::stream<t_s_gmii> gmii;
    int correct_frames = 0;
    t_rx_status rx_status = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    for (j = 0; j < FRAMES_CNT; j++) {
        //Put data into A
        for(i=0; i < frames[j].len; i++){
            gmii.write((t_s_gmii){frames[j].data[i], 1, 0});
        }
        gmii.write((t_s_gmii) {0, 0, 0});
    }

    receive(gmii, s_axis, &rx_status);

        printf("*****************************************************************\n");
        printf("RECEIVED FRAMES\n");
        printf("*****************************************************************\n");
        t_axis m_axis;
        while (!s_axis.empty()) {
            t_axis din=s_axis.read();
            printf("Data 0x%x, LAST %d, USER %d\n", din.data.to_int(), din.last.to_int(), din.user.to_int());
            if (din.last) {

//             if((!m_axis.user) && (!rx_status.fcs_err) && (!rx_status.len_err)){
//                 correct_frames++;
//             }
//             printf("*****************************************************************\n");
//             printf("Frame status: count=%d, good=%d, under=%d, len_err=%d, fcs_err=%d, data_err=%d, over=%d\n",
//                       rx_status.count.to_int(),
//                                       rx_status.good.to_int(),
//                                       rx_status.under.to_int(),
//                                       rx_status.len_err.to_int(),
//                                       rx_status.fcs_err.to_int(),
//                                       rx_status.data_err.to_int(),
//                                       rx_status.over.to_int()
//                 );
                printf("*****************************************************************\n");
            }
        }

//     printf("*****************************************************************\n");
//     if (correct_frames < FRAMES_CNT) {
//         printf("FRAME ERROR %d/%d\n", FRAMES_CNT-correct_frames, FRAMES_CNT);
//         return 1;
//     }

// //  if (rx_statistic_counters.good_frames != correct_frames) {
// //        printf("STATISTICS ERROR: correct_frames=%d, good_frames=%d\n", correct_frames, rx_statistic_counters.good_frames.to_int());
// //  }

//     printf("Frame correct %d/%d\n", FRAMES_CNT,FRAMES_CNT);
//     printf("*****************************************************************\n");

    return 0;

//  //Run a software version of the hardware function to validate results
//  for(i=0; i < 50; i++){
//    C[i] = A[i].data.to_int() + 5;
//  }
//
//  //Compare results
//  for(i=0; i < 50; i++){
//    if(B[i].data.to_int() != C[i]){
//      printf("ERROR HW and SW results mismatch\n");
//      return 1;
//    }
//  }


    }

  

