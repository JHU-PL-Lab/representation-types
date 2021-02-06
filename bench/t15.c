#include <stdio.h>

typedef struct {
    int w, x, y, z;
} Quat;


Quat neg(Quat q) {
    Quat r = { -q.w, -q.x, -q.y, -q.z };
    return r;
}

Quat conj(Quat q) {
    Quat r = { q.w, -q.x, -q.y, -q.z }; 
    return r;
}

Quat addS(int s, Quat q) {
    q.w += s;
    return q;
}

Quat addQ(Quat q1, Quat q2) {
    Quat r = { q1.w+q2.w, q1.x+q2.x, q1.y+q2.y, q1.z+q2.z };
    return r;
}

Quat mulS(int s, Quat q) {
    q.w *= s;
    q.x *= s;
    q.y *= s;
    q.z *= s;
    return q;
}

Quat mulQ(Quat q1, Quat q2) {
    Quat r = {
        q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z,
        q1.w*q2.x + q1.x*q2.w + q1.y*q2.z - q1.z*q2.y,
        q1.w*q2.y - q1.x*q2.z + q1.y*q2.w + q1.z*q2.x,
        q1.w*q2.z + q1.x*q2.y - q1.y*q2.x + q1.z*q2.w,
    };
    return r;
}


int main(void) {
    Quat q1 = { 2, 3, 4, 5 };
    Quat q2 = { 3, 4, 5, 6 };

    Quat q3 = mulQ(q1, q2);

    printf("%d, %d, %d, %d\n", q3.w, q3.x, q3.y, q3.z);
}