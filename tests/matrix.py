
def mat4x4_col(m, i):
    return tuple(v[i] for v in m)

def vec4_dot(v1, v2):
    return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3]

def mat4x4_mul(m1, m2):
    def mat4x4_mul_row(v1, m2):
        return tuple(vec4_dot(v1, mat4x4_col(m2, i)) for i in range(4))
    return tuple(
        mat4x4_mul_row(v, m2) for v in m1
    )
        
def mat4x4_det(m):
    return (
        m[0][3] * m[1][2] * m[2][1] * m[3][0]  -  m[0][2] * m[1][3] * m[2][1] * m[3][0]  -  m[0][3] * m[1][1] * m[2][2] * m[3][0] + 
        m[0][1] * m[1][3] * m[2][2] * m[3][0]  +  m[0][2] * m[1][1] * m[2][3] * m[3][0]  -  m[0][1] * m[1][2] * m[2][3] * m[3][0] - 
        m[0][3] * m[1][2] * m[2][0] * m[3][1]  +  m[0][2] * m[1][3] * m[2][0] * m[3][1]  +  m[0][3] * m[1][0] * m[2][2] * m[3][1] - 
        m[0][0] * m[1][3] * m[2][2] * m[3][1]  -  m[0][2] * m[1][0] * m[2][3] * m[3][1]  +  m[0][0] * m[1][2] * m[2][3] * m[3][1] + 
        m[0][3] * m[1][1] * m[2][0] * m[3][2]  -  m[0][1] * m[1][3] * m[2][0] * m[3][2]  -  m[0][3] * m[1][0] * m[2][1] * m[3][2] + 
        m[0][0] * m[1][3] * m[2][1] * m[3][2]  +  m[0][1] * m[1][0] * m[2][3] * m[3][2]  -  m[0][0] * m[1][1] * m[2][3] * m[3][2] - 
        m[0][2] * m[1][1] * m[2][0] * m[3][3]  +  m[0][1] * m[1][2] * m[2][0] * m[3][3]  +  m[0][2] * m[1][0] * m[2][1] * m[3][3] - 
        m[0][0] * m[1][2] * m[2][1] * m[3][3]  -  m[0][1] * m[1][0] * m[2][2] * m[3][3]  +  m[0][0] * m[1][1] * m[2][2] * m[3][3]
    )

def mat4x4_input():
    return tuple(
        tuple(map(int, input().split()))
        for _ in range(4)
    )

def main():
    num_reps = int(input())
    m1 = mat4x4_input()
    m2 = mat4x4_input()
    m3 = mat4x4_input()

    for _ in range(num_reps):
        det = mat4x4_det(mat4x4_mul(m1, mat4x4_mul(m2, m3)))
        
    print(det)

if __name__ == "__main__":
    main()
    