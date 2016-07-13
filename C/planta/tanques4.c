#include "tanques4.h"
#include <math.h>

void tanques4_begin(tanques4_handle_t * T4){
    float temp = sqrt(2*g);
    // Coef para Dh1
    c1[0] = -T4->a[0] / T4->A[0] * temp;
    c1[1] = T4->a[2] / T4->A[0] * temp;
    c1[2] = T4->gamma[0]* T4->K[0] / T4->A[0];

    // Coef para Dh2
    c2[0] = -T4->a[1] / T4->A[1] * temp;
    c2[1] = T4->a[3] / T4->A[1] * temp;
    c2[2] = T4->gamma[1] * T4->K[1] / T4->A[1];

    // Coef para Dh3
    c3[0] = -T4->a[2] / T4->A[2] * temp;
    c3[1] = (1-T4->gamma[1])* T4->K[1] / T4->A[2];

    // Coef para Dh4
    c4[0] = -T4->a[3] / T4->A[3] * temp;
    c4[1] = (1-T4->gamma[0])* T4->K[0] / T4->A[3];
}

void tanques_update(tanques4_handle_t * T4, float * u){
    // Calculo de derivadas
    T4->Dh[0] = T4->c1[0] * sqrt(T4->h[0])
             + T4->c1[1] * sqrt(T4->h[2])
             + T4->c1[2] * u[0];
    T4->Dh[1] = T4->c2[0] * sqrt(T4->h[1])
            + T4->c2[1] * sqrt(T4->h[3])
            + T4->c1[2] * u[1];
    T4->Dh[0] = T4->c3[0] * sqrt(T4->h[2]) + T4->c3[1] * u[1];
    T4->Dh[0] = T4->c4[0] * sqrt(T4->h[0]) + T4->c4[1] * u[0];

    // actualizando alturas
    T4->h[0] += T4->dt * T4->Dh[0];
    T4->h[1] += T4->dt * T4->Dh[1];
    T4->h[2] += T4->dt * T4->Dh[2];
    T4->h[3] += T4->dt * T4->Dh[3];
}
