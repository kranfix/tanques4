#ifndef kranfix_tanques4_C_tanques4_tanques4_h
#define kranfix_tanques4_C_tanques4_tanques4_h

typedef struct {
    float h[4];
    float Dh[4];
    float dt;
    float a[4];
    float A[4];
    float K[2];
    float gamma[2];
    float c1[3];
    float c2[3];
    float c3[2];
    float c4[2];
} tanques4_handle_t;

void tanques4_begin(tanques4_handle_t *);
void tanques_update(tanques4_handle_t *, float *);

#endif //kranfix_tanques4_C_tanques4_tanques4_h
