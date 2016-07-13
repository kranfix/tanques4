#ifndef SISTEMA4T_H
#define SISTEMA4T_H

#include <planta/tanques4.h>
#include <control.h>


static float h[4];
static float Dh[4];
static float dt;
static float a[4];
float A[4];
float K[2];
float gamma[2];
float c1[3];
float c2[3];
float c3[2];
float c4[2];

tanques4_handle_t sys = {
    {0,0,0,0}, //float h[4];
    {0,0,0,0}, // float Dh[4];
    0.01, // float dt;
    {0.178,0.178,0.178,0.178}, // float a[4];
    {15.52,15.52,15.52,15.52}, // float A[4];
    {3.3,3.3}, // float K[2];
    {0.65,0.6}, // float gamma[2];
    {0,0,0}, // float c1[3];
    {0,0,0}, // float c2[3];
    {0,0}, // float c3[2];
    {0,0}, // float c4[2];
};


#endif // SISTEMA4T_H
