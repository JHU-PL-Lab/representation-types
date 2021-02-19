
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

typedef void Func();

typedef struct {
  Func *_func;
} Closure;

#define UNREACHABLE __builtin_unreachable()
#define ABORT exit(EXIT_FAILURE)
#define COPY(...) __builtin_memcpy(__VA_ARGS__)
#define COMBINE(a, b) (a) >= (b) ? (a) * (a) + (a) + (b) : (a) + (b) * (b)
#define CALL(c, ...) ((c)->_func)((c), __VA_ARGS__)
#define HEAP_ALLOC(...) malloc(__VA_ARGS__)
#define HEAP_VALUE(type, ...) \
  ({ type *ptr = HEAP_ALLOC(sizeof(type)); *ptr = (type) __VA_ARGS__; (void*)ptr; })
#define UNTAGGED(U, T, value) ((U) { . T = value })
#define TAGGED(U, T, value) ((U) { .tag = U ## _ ## T, . T = value })

void __input(ssize_t *i) {
  if (scanf("%zd", i) != 1) ABORT;
}

typedef struct {} Empty;
typedef void *Univ;

typedef Univ Type0;

typedef ssize_t Type1;

typedef Empty Type2;

typedef Empty Type3;

typedef const Closure* Type4;

typedef struct /* $1 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type5;

typedef struct /* $10 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type6;

typedef struct /* $19 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type7;

typedef struct /* $28 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type8;

typedef struct /* $373 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type9;

typedef struct /* $378 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type10;

typedef struct /* $383 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type11;

typedef struct /* $388 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type12;

typedef struct /* $56 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
  Univ  _3; /* Union1 */
} Type13;

typedef struct /* $368 */ {
  Univ  _0; /* Union3 */
  Univ  _1; /* Union3 */
  Univ  _2; /* Union3 */
  Univ  _3; /* Union3 */
} Type14;

typedef struct /* $54 */ {
  Univ  _0; /* Union3 */
  Univ  _1; /* Union3 */
  Univ  _2; /* Union3 */
  Univ  _3; /* Union3 */
} Type15;

typedef struct /* $390 */ {
} Type16;

typedef struct /* $391 */ {
} Type17;

typedef struct /* $392 */ {
} Type18;

typedef struct /* $404 */ {
} Type19;

typedef Empty Union0;

typedef struct { Type1 Type1; }  Union1;
typedef struct {
  enum {
    Union2_Type5,
    Union2_Type6,
    Union2_Type7,
    Union2_Type8,
  } tag;
  union {
    Type5 Type5;
    Type6 Type6;
    Type7 Type7;
    Type8 Type8;
  };
}  *Union2;

typedef struct {
  enum {
    Union3_Type9,
    Union3_Type10,
    Union3_Type11,
    Union3_Type12,
    Union3_Type13,
  } tag;
  union {
    Type9 Type9;
    Type10 Type10;
    Type11 Type11;
    Type12 Type12;
    Type13 Type13;
  };
}  *Union3;

typedef struct {
  enum {
    Union4_Type14,
    Union4_Type15,
  } tag;
  union {
    Type14 Type14;
    Type15 Type15;
  };
}  *Union4;

typedef struct { Type4 Type4; }  Union5;
typedef struct {
  enum {
    Union6_Type16,
    Union6_Type17,
    Union6_Type18,
  } tag;
  union {
    Type16 Type16;
    Type17 Type17;
    Type18 Type18;
  };
}  Union6;

typedef struct {
  enum {
    Union7_Type2,
    Union7_Type3,
  } tag;
  union {
    Type2 Type2;
    Type3 Type3;
  };
}  Union7;

typedef struct { Type19 Type19; }  Union8;
typedef struct {
  Func *_func;
} vec4_dot$0_Closure;

typedef struct {
  Func *_func;
  Union3 v1$0;
} v2$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} v1$1_Closure;

typedef struct {
  Func *_func;
} v1$0_Closure;

typedef struct {
  Func *_func;
  Union4 m1$1;
  Union4 m2$2;
  Union4 m3$0;
  Union5 mat4x4_det$0;
  Union5 mat4x4_mul$0;
} n$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} mat4x4_mul_row$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} mat4x4_mul$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_input$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_det$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_col3$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_col2$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_col1$0_Closure;

typedef struct {
  Func *_func;
} mat4x4_col0$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_det$0;
  Union5 mat4x4_input$0;
  Union5 mat4x4_mul$0;
} main$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union3 v1$1;
  Union5 vec4_dot$0;
} m2$1_Closure;

typedef struct {
  Func *_func;
  Union4 m1$0;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} m2$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} m1$0_Closure;

typedef struct {
  Func *_func;
} m$4_Closure;

typedef struct {
  Func *_func;
} m$3_Closure;

typedef struct {
  Func *_func;
} m$2_Closure;

typedef struct {
  Func *_func;
} m$1_Closure;

typedef struct {
  Func *_func;
} m$0_Closure;

typedef struct {
  Func *_func;
  Union4 m1$1;
  Union4 m2$2;
  Union4 m3$0;
  Union5 mat4x4_det$0;
  Union5 mat4x4_mul$0;
} loop$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_det$0;
  Union5 mat4x4_input$0;
  Union5 mat4x4_mul$0;
} _$1_Closure;

typedef struct {
  Func *_func;
} _$0_Closure;

typedef struct {
  Func *_func;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union3 v1$1;
  Union5 vec4_dot$0;
} $55_Closure;

typedef struct {
  Func *_func;
  Union4 m1$0;
  Union5 mat4x4_col0$0;
  Union5 mat4x4_col1$0;
  Union5 mat4x4_col2$0;
  Union5 mat4x4_col3$0;
  Union5 vec4_dot$0;
} $53_Closure;

typedef struct {
  Func *_func;
  Union3 v1$0;
} $37_Closure;

Func _vec4_dot$0;
Func _v2$0;
Func _v1$1;
Func _v1$0;
Func _n$0;
Func _mat4x4_mul_row$0;
Func _mat4x4_mul$0;
Func _mat4x4_input$0;
Func _mat4x4_det$0;
Func _mat4x4_col3$0;
Func _mat4x4_col2$0;
Func _mat4x4_col1$0;
Func _mat4x4_col0$0;
Func _main$0;
Func _m2$1;
Func _m2$0;
Func _m1$0;
Func _m$4;
Func _m$3;
Func _m$2;
Func _m$1;
Func _m$0;
Func _loop$0;
Func ___main;
Func __$1;
Func __$0;
Func _$55;
Func _$53;
Func _$37;

static inline void fprint_Type0(FILE *, const Type0*);
static inline void fprint_Type1(FILE *, const Type1*);
static inline void fprint_Type2(FILE *, const Type2*);
static inline void fprint_Type3(FILE *, const Type3*);
static inline void fprint_Type4(FILE *, const Type4*);
static inline void fprint_Type5(FILE *, const Type5*);
static inline void fprint_Type6(FILE *, const Type6*);
static inline void fprint_Type7(FILE *, const Type7*);
static inline void fprint_Type8(FILE *, const Type8*);
static inline void fprint_Type9(FILE *, const Type9*);
static inline void fprint_Type10(FILE *, const Type10*);
static inline void fprint_Type11(FILE *, const Type11*);
static inline void fprint_Type12(FILE *, const Type12*);
static inline void fprint_Type13(FILE *, const Type13*);
static inline void fprint_Type14(FILE *, const Type14*);
static inline void fprint_Type15(FILE *, const Type15*);
static inline void fprint_Type16(FILE *, const Type16*);
static inline void fprint_Type17(FILE *, const Type17*);
static inline void fprint_Type18(FILE *, const Type18*);
static inline void fprint_Type19(FILE *, const Type19*);
static inline void fprint_Union0(FILE *, const Union0*);
static inline void fprint_Union1(FILE *, const Union1*);
static inline void fprint_Union2(FILE *, const Union2*);
static inline void fprint_Union3(FILE *, const Union3*);
static inline void fprint_Union4(FILE *, const Union4*);
static inline void fprint_Union5(FILE *, const Union5*);
static inline void fprint_Union6(FILE *, const Union6*);
static inline void fprint_Union7(FILE *, const Union7*);
static inline void fprint_Union8(FILE *, const Union8*);

void fprint_Type0(FILE *stream, const Type0* value) {
  fprintf(stream, "<univ>");
}
void fprint_Type1(FILE *stream, const Type1* value) {
  fprintf(stream, "%zd", *value);
}
void fprint_Type2(FILE *stream, const Type2* value) {
  fprintf(stream, "true");
}
void fprint_Type3(FILE *stream, const Type3* value) {
  fprintf(stream, "false");
}
void fprint_Type4(FILE *stream, const Type4* value) {
  fprintf(stream, "<fun>");
}
void fprint_Type5(FILE *stream, const Type5* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type8(FILE *stream, const Type8* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type9(FILE *stream, const Type9* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type10(FILE *stream, const Type10* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type11(FILE *stream, const Type11* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type12(FILE *stream, const Type12* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type13(FILE *stream, const Type13* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union1(stream, (Union1*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type14(FILE *stream, const Type14* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union3(stream, (Union3*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union3(stream, (Union3*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union3(stream, (Union3*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union3(stream, (Union3*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type15(FILE *stream, const Type15* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union3(stream, (Union3*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union3(stream, (Union3*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union3(stream, (Union3*)&value->_2);
  fprintf(stream, "; _3 = ");
  fprint_Union3(stream, (Union3*)&value->_3);
  fprintf(stream, "}");
}
void fprint_Type16(FILE *stream, const Type16* value) {
  fprintf(stream, "{}");
}
void fprint_Type17(FILE *stream, const Type17* value) {
  fprintf(stream, "{}");
}
void fprint_Type18(FILE *stream, const Type18* value) {
  fprintf(stream, "{}");
}
void fprint_Type19(FILE *stream, const Type19* value) {
  fprintf(stream, "{}");
}
void fprint_Union0(FILE *stream, const Union0* value) {
  UNREACHABLE;
}
void fprint_Union1(FILE *stream, const Union1* value) {
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union2(FILE *stream, const Union2* value) {
  switch ((*value)->tag) {
    case Union2_Type5:
      fprint_Type5(stream, &(*value)->Type5);
      break;
    case Union2_Type6:
      fprint_Type6(stream, &(*value)->Type6);
      break;
    case Union2_Type7:
      fprint_Type7(stream, &(*value)->Type7);
      break;
    case Union2_Type8:
      fprint_Type8(stream, &(*value)->Type8);
      break;
  }
}
void fprint_Union3(FILE *stream, const Union3* value) {
  switch ((*value)->tag) {
    case Union3_Type9:
      fprint_Type9(stream, &(*value)->Type9);
      break;
    case Union3_Type10:
      fprint_Type10(stream, &(*value)->Type10);
      break;
    case Union3_Type11:
      fprint_Type11(stream, &(*value)->Type11);
      break;
    case Union3_Type12:
      fprint_Type12(stream, &(*value)->Type12);
      break;
    case Union3_Type13:
      fprint_Type13(stream, &(*value)->Type13);
      break;
  }
}
void fprint_Union4(FILE *stream, const Union4* value) {
  switch ((*value)->tag) {
    case Union4_Type14:
      fprint_Type14(stream, &(*value)->Type14);
      break;
    case Union4_Type15:
      fprint_Type15(stream, &(*value)->Type15);
      break;
  }
}
void fprint_Union5(FILE *stream, const Union5* value) {
  fprint_Type4(stream, &value->Type4);
}
void fprint_Union6(FILE *stream, const Union6* value) {
  switch (value->tag) {
    case Union6_Type16:
      fprint_Type16(stream, &value->Type16);
      break;
    case Union6_Type17:
      fprint_Type17(stream, &value->Type17);
      break;
    case Union6_Type18:
      fprint_Type18(stream, &value->Type18);
      break;
  }
}
void fprint_Union7(FILE *stream, const Union7* value) {
  switch (value->tag) {
    case Union7_Type2:
      fprint_Type2(stream, &value->Type2);
      break;
    case Union7_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}
void fprint_Union8(FILE *stream, const Union8* value) {
  fprint_Type19(stream, &value->Type19);
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  /* let mat4x4_col0$0 = fun m$0 -> (...) */
  Union5 mat4x4_col0$0;
  static const mat4x4_col0$0_Closure _mat4x4_col0$0$ = { ._func = _mat4x4_col0$0 };
  mat4x4_col0$0.Type4 = (Closure*)&_mat4x4_col0$0$;
  
  /* let mat4x4_col1$0 = fun m$1 -> (...) */
  Union5 mat4x4_col1$0;
  static const mat4x4_col1$0_Closure _mat4x4_col1$0$ = { ._func = _mat4x4_col1$0 };
  mat4x4_col1$0.Type4 = (Closure*)&_mat4x4_col1$0$;
  
  /* let mat4x4_col2$0 = fun m$2 -> (...) */
  Union5 mat4x4_col2$0;
  static const mat4x4_col2$0_Closure _mat4x4_col2$0$ = { ._func = _mat4x4_col2$0 };
  mat4x4_col2$0.Type4 = (Closure*)&_mat4x4_col2$0$;
  
  /* let mat4x4_col3$0 = fun m$3 -> (...) */
  Union5 mat4x4_col3$0;
  static const mat4x4_col3$0_Closure _mat4x4_col3$0$ = { ._func = _mat4x4_col3$0 };
  mat4x4_col3$0.Type4 = (Closure*)&_mat4x4_col3$0$;
  
  /* let vec4_dot$0 = fun v1$0 -> (...) */
  Union5 vec4_dot$0;
  static const vec4_dot$0_Closure _vec4_dot$0$ = { ._func = _vec4_dot$0 };
  vec4_dot$0.Type4 = (Closure*)&_vec4_dot$0$;
  
  /* let mat4x4_mul$0 = fun m1$0 -> (...) */
  Union5 mat4x4_mul$0;
  mat4x4_mul$0.Type4 = HEAP_VALUE(mat4x4_mul$0_Closure, {
    ._func = _mat4x4_mul$0,
    .mat4x4_col0$0 = mat4x4_col0$0,
    .mat4x4_col1$0 = mat4x4_col1$0,
    .mat4x4_col2$0 = mat4x4_col2$0,
    .mat4x4_col3$0 = mat4x4_col3$0,
    .vec4_dot$0 = vec4_dot$0,
  });
  
  /* let mat4x4_det$0 = fun m$4 -> (...) */
  Union5 mat4x4_det$0;
  static const mat4x4_det$0_Closure _mat4x4_det$0$ = { ._func = _mat4x4_det$0 };
  mat4x4_det$0.Type4 = (Closure*)&_mat4x4_det$0$;
  
  /* let mat4x4_input$0 = fun _$0 -> (...) */
  Union5 mat4x4_input$0;
  static const mat4x4_input$0_Closure _mat4x4_input$0$ = { ._func = _mat4x4_input$0 };
  mat4x4_input$0.Type4 = (Closure*)&_mat4x4_input$0$;
  
  /* let main$0 = fun _$1 -> (...) */
  Union5 main$0;
  main$0.Type4 = HEAP_VALUE(main$0_Closure, {
    ._func = _main$0,
    .mat4x4_det$0 = mat4x4_det$0,
    .mat4x4_input$0 = mat4x4_input$0,
    .mat4x4_mul$0 = mat4x4_mul$0,
  });
  
  /* let $404 = {} */
  Union8 $404;
  
  /* let $0 = main$0 $404 */
  CALL(main$0.Type4, &(*$0), $404);
}


void _mat4x4_col0$0(const mat4x4_col0$0_Closure *_clo, Union2 *restrict $1, Union4 m$0) {
  /* let $2 = m$0._0 */
  Union3 $2;
  switch (m$0->tag) {
    case Union4_Type14:
      COPY(&$2, &m$0->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$2, &m$0->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $3 = $2._0 */
  Union1 $3;
  switch ($2->tag) {
    case Union3_Type9:
      COPY(&$3, &$2->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$3, &$2->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$3, &$2->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$3, &$2->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$3, &$2->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $4 = m$0._1 */
  Union3 $4;
  switch (m$0->tag) {
    case Union4_Type14:
      COPY(&$4, &m$0->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$4, &m$0->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $5 = $4._0 */
  Union1 $5;
  switch ($4->tag) {
    case Union3_Type9:
      COPY(&$5, &$4->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$5, &$4->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$5, &$4->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$5, &$4->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$5, &$4->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $6 = m$0._2 */
  Union3 $6;
  switch (m$0->tag) {
    case Union4_Type14:
      COPY(&$6, &m$0->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$6, &m$0->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $7 = $6._0 */
  Union1 $7;
  switch ($6->tag) {
    case Union3_Type9:
      COPY(&$7, &$6->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$7, &$6->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$7, &$6->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$7, &$6->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$7, &$6->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $8 = m$0._3 */
  Union3 $8;
  switch (m$0->tag) {
    case Union4_Type14:
      COPY(&$8, &m$0->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$8, &m$0->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $9 = $8._0 */
  Union1 $9;
  switch ($8->tag) {
    case Union3_Type9:
      COPY(&$9, &$8->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$9, &$8->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$9, &$8->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$9, &$8->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$9, &$8->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $1 = {_3 = $9; _2 = $7; _1 = $5; _0 = $3} */
  (*$1) = HEAP_ALLOC(sizeof(*(*$1)));
  (*$1)->tag = Union2_Type5;
  COPY(&(*$1)->Type5._3, &$9, sizeof(Union1));
  COPY(&(*$1)->Type5._2, &$7, sizeof(Union1));
  COPY(&(*$1)->Type5._1, &$5, sizeof(Union1));
  COPY(&(*$1)->Type5._0, &$3, sizeof(Union1));
}


void _mat4x4_col1$0(const mat4x4_col1$0_Closure *_clo, Union2 *restrict $10, Union4 m$1) {
  /* let $11 = m$1._0 */
  Union3 $11;
  switch (m$1->tag) {
    case Union4_Type14:
      COPY(&$11, &m$1->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$11, &m$1->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $12 = $11._1 */
  Union1 $12;
  switch ($11->tag) {
    case Union3_Type9:
      COPY(&$12, &$11->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$12, &$11->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$12, &$11->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$12, &$11->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$12, &$11->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $13 = m$1._1 */
  Union3 $13;
  switch (m$1->tag) {
    case Union4_Type14:
      COPY(&$13, &m$1->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$13, &m$1->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $14 = $13._1 */
  Union1 $14;
  switch ($13->tag) {
    case Union3_Type9:
      COPY(&$14, &$13->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$14, &$13->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$14, &$13->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$14, &$13->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$14, &$13->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $15 = m$1._2 */
  Union3 $15;
  switch (m$1->tag) {
    case Union4_Type14:
      COPY(&$15, &m$1->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$15, &m$1->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $16 = $15._1 */
  Union1 $16;
  switch ($15->tag) {
    case Union3_Type9:
      COPY(&$16, &$15->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$16, &$15->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$16, &$15->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$16, &$15->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$16, &$15->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $17 = m$1._3 */
  Union3 $17;
  switch (m$1->tag) {
    case Union4_Type14:
      COPY(&$17, &m$1->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$17, &m$1->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $18 = $17._1 */
  Union1 $18;
  switch ($17->tag) {
    case Union3_Type9:
      COPY(&$18, &$17->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$18, &$17->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$18, &$17->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$18, &$17->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$18, &$17->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $10 = {_3 = $18; _2 = $16; _1 = $14; _0 = $12} */
  (*$10) = HEAP_ALLOC(sizeof(*(*$10)));
  (*$10)->tag = Union2_Type6;
  COPY(&(*$10)->Type6._3, &$18, sizeof(Union1));
  COPY(&(*$10)->Type6._2, &$16, sizeof(Union1));
  COPY(&(*$10)->Type6._1, &$14, sizeof(Union1));
  COPY(&(*$10)->Type6._0, &$12, sizeof(Union1));
}


void _mat4x4_col2$0(const mat4x4_col2$0_Closure *_clo, Union2 *restrict $19, Union4 m$2) {
  /* let $20 = m$2._0 */
  Union3 $20;
  switch (m$2->tag) {
    case Union4_Type14:
      COPY(&$20, &m$2->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$20, &m$2->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $21 = $20._2 */
  Union1 $21;
  switch ($20->tag) {
    case Union3_Type9:
      COPY(&$21, &$20->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$21, &$20->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$21, &$20->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$21, &$20->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$21, &$20->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $22 = m$2._1 */
  Union3 $22;
  switch (m$2->tag) {
    case Union4_Type14:
      COPY(&$22, &m$2->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$22, &m$2->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $23 = $22._2 */
  Union1 $23;
  switch ($22->tag) {
    case Union3_Type9:
      COPY(&$23, &$22->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$23, &$22->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$23, &$22->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$23, &$22->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$23, &$22->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $24 = m$2._2 */
  Union3 $24;
  switch (m$2->tag) {
    case Union4_Type14:
      COPY(&$24, &m$2->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$24, &m$2->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $25 = $24._2 */
  Union1 $25;
  switch ($24->tag) {
    case Union3_Type9:
      COPY(&$25, &$24->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$25, &$24->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$25, &$24->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$25, &$24->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$25, &$24->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $26 = m$2._3 */
  Union3 $26;
  switch (m$2->tag) {
    case Union4_Type14:
      COPY(&$26, &m$2->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$26, &m$2->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $27 = $26._2 */
  Union1 $27;
  switch ($26->tag) {
    case Union3_Type9:
      COPY(&$27, &$26->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$27, &$26->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$27, &$26->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$27, &$26->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$27, &$26->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $19 = {_3 = $27; _2 = $25; _1 = $23; _0 = $21} */
  (*$19) = HEAP_ALLOC(sizeof(*(*$19)));
  (*$19)->tag = Union2_Type7;
  COPY(&(*$19)->Type7._3, &$27, sizeof(Union1));
  COPY(&(*$19)->Type7._2, &$25, sizeof(Union1));
  COPY(&(*$19)->Type7._1, &$23, sizeof(Union1));
  COPY(&(*$19)->Type7._0, &$21, sizeof(Union1));
}


void _mat4x4_col3$0(const mat4x4_col3$0_Closure *_clo, Union2 *restrict $28, Union4 m$3) {
  /* let $29 = m$3._0 */
  Union3 $29;
  switch (m$3->tag) {
    case Union4_Type14:
      COPY(&$29, &m$3->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$29, &m$3->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $30 = $29._3 */
  Union1 $30;
  switch ($29->tag) {
    case Union3_Type9:
      COPY(&$30, &$29->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$30, &$29->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$30, &$29->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$30, &$29->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$30, &$29->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $31 = m$3._1 */
  Union3 $31;
  switch (m$3->tag) {
    case Union4_Type14:
      COPY(&$31, &m$3->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$31, &m$3->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $32 = $31._3 */
  Union1 $32;
  switch ($31->tag) {
    case Union3_Type9:
      COPY(&$32, &$31->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$32, &$31->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$32, &$31->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$32, &$31->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$32, &$31->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $33 = m$3._2 */
  Union3 $33;
  switch (m$3->tag) {
    case Union4_Type14:
      COPY(&$33, &m$3->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$33, &m$3->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $34 = $33._3 */
  Union1 $34;
  switch ($33->tag) {
    case Union3_Type9:
      COPY(&$34, &$33->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$34, &$33->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$34, &$33->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$34, &$33->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$34, &$33->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $35 = m$3._3 */
  Union3 $35;
  switch (m$3->tag) {
    case Union4_Type14:
      COPY(&$35, &m$3->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$35, &m$3->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $36 = $35._3 */
  Union1 $36;
  switch ($35->tag) {
    case Union3_Type9:
      COPY(&$36, &$35->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$36, &$35->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$36, &$35->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$36, &$35->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$36, &$35->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $28 = {_3 = $36; _2 = $34; _1 = $32; _0 = $30} */
  (*$28) = HEAP_ALLOC(sizeof(*(*$28)));
  (*$28)->tag = Union2_Type8;
  COPY(&(*$28)->Type8._3, &$36, sizeof(Union1));
  COPY(&(*$28)->Type8._2, &$34, sizeof(Union1));
  COPY(&(*$28)->Type8._1, &$32, sizeof(Union1));
  COPY(&(*$28)->Type8._0, &$30, sizeof(Union1));
}


void _$37(const $37_Closure *_clo, Union1 *restrict $38, Union2 v2$0) {
  /* let $39 = v1$0._0 */
  Union1 $39;
  switch (_clo->v1$0->tag) {
    case Union3_Type9:
      COPY(&$39, &_clo->v1$0->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$39, &_clo->v1$0->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$39, &_clo->v1$0->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$39, &_clo->v1$0->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$39, &_clo->v1$0->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $40 = v2$0._0 */
  Union1 $40;
  switch (v2$0->tag) {
    case Union2_Type5:
      COPY(&$40, &v2$0->Type5._0, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&$40, &v2$0->Type6._0, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&$40, &v2$0->Type7._0, sizeof(Union1));
      break;
    case Union2_Type8:
      COPY(&$40, &v2$0->Type8._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $41 = $39 * $40 */
  Union1 $41;
  $41.Type1 = $39.Type1 * $40.Type1;
  
  /* let $42 = v1$0._1 */
  Union1 $42;
  switch (_clo->v1$0->tag) {
    case Union3_Type9:
      COPY(&$42, &_clo->v1$0->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$42, &_clo->v1$0->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$42, &_clo->v1$0->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$42, &_clo->v1$0->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$42, &_clo->v1$0->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $43 = v2$0._1 */
  Union1 $43;
  switch (v2$0->tag) {
    case Union2_Type5:
      COPY(&$43, &v2$0->Type5._1, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&$43, &v2$0->Type6._1, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&$43, &v2$0->Type7._1, sizeof(Union1));
      break;
    case Union2_Type8:
      COPY(&$43, &v2$0->Type8._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $44 = $42 * $43 */
  Union1 $44;
  $44.Type1 = $42.Type1 * $43.Type1;
  
  /* let $45 = $41 + $44 */
  Union1 $45;
  $45.Type1 = $41.Type1 + $44.Type1;
  
  /* let $46 = v1$0._2 */
  Union1 $46;
  switch (_clo->v1$0->tag) {
    case Union3_Type9:
      COPY(&$46, &_clo->v1$0->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$46, &_clo->v1$0->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$46, &_clo->v1$0->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$46, &_clo->v1$0->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$46, &_clo->v1$0->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $47 = v2$0._2 */
  Union1 $47;
  switch (v2$0->tag) {
    case Union2_Type5:
      COPY(&$47, &v2$0->Type5._2, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&$47, &v2$0->Type6._2, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&$47, &v2$0->Type7._2, sizeof(Union1));
      break;
    case Union2_Type8:
      COPY(&$47, &v2$0->Type8._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $48 = $46 * $47 */
  Union1 $48;
  $48.Type1 = $46.Type1 * $47.Type1;
  
  /* let $49 = $45 + $48 */
  Union1 $49;
  $49.Type1 = $45.Type1 + $48.Type1;
  
  /* let $50 = v1$0._3 */
  Union1 $50;
  switch (_clo->v1$0->tag) {
    case Union3_Type9:
      COPY(&$50, &_clo->v1$0->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$50, &_clo->v1$0->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$50, &_clo->v1$0->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$50, &_clo->v1$0->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$50, &_clo->v1$0->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $51 = v2$0._3 */
  Union1 $51;
  switch (v2$0->tag) {
    case Union2_Type5:
      COPY(&$51, &v2$0->Type5._3, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&$51, &v2$0->Type6._3, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&$51, &v2$0->Type7._3, sizeof(Union1));
      break;
    case Union2_Type8:
      COPY(&$51, &v2$0->Type8._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $52 = $50 * $51 */
  Union1 $52;
  $52.Type1 = $50.Type1 * $51.Type1;
  
  /* let $38 = $49 + $52 */
  (*$38).Type1 = $49.Type1 + $52.Type1;
}


void _vec4_dot$0(const vec4_dot$0_Closure *_clo, Union5 *restrict $37, Union3 v1$0) {
  /* let $37 = fun v2$0 -> (...) */
  (*$37).Type4 = HEAP_VALUE($37_Closure, {
    ._func = _$37,
    .v1$0 = v1$0,
  });
}


void _$55(const $55_Closure *_clo, Union3 *restrict $56, Union4 m2$1) {
  /* let $57 = vec4_dot$0 v1$1 */
  Union5 $57;
  CALL(_clo->vec4_dot$0.Type4, &$57, _clo->v1$1);
  
  /* let $58 = mat4x4_col0$0 m2$1 */
  Union2 $58;
  CALL(_clo->mat4x4_col0$0.Type4, &$58, m2$1);
  
  /* let $59 = $57 $58 */
  Union1 $59;
  CALL($57.Type4, &$59, $58);
  
  /* let $60 = vec4_dot$0 v1$1 */
  Union5 $60;
  CALL(_clo->vec4_dot$0.Type4, &$60, _clo->v1$1);
  
  /* let $61 = mat4x4_col1$0 m2$1 */
  Union2 $61;
  CALL(_clo->mat4x4_col1$0.Type4, &$61, m2$1);
  
  /* let $62 = $60 $61 */
  Union1 $62;
  CALL($60.Type4, &$62, $61);
  
  /* let $63 = vec4_dot$0 v1$1 */
  Union5 $63;
  CALL(_clo->vec4_dot$0.Type4, &$63, _clo->v1$1);
  
  /* let $64 = mat4x4_col2$0 m2$1 */
  Union2 $64;
  CALL(_clo->mat4x4_col2$0.Type4, &$64, m2$1);
  
  /* let $65 = $63 $64 */
  Union1 $65;
  CALL($63.Type4, &$65, $64);
  
  /* let $66 = vec4_dot$0 v1$1 */
  Union5 $66;
  CALL(_clo->vec4_dot$0.Type4, &$66, _clo->v1$1);
  
  /* let $67 = mat4x4_col3$0 m2$1 */
  Union2 $67;
  CALL(_clo->mat4x4_col3$0.Type4, &$67, m2$1);
  
  /* let $68 = $66 $67 */
  Union1 $68;
  CALL($66.Type4, &$68, $67);
  
  /* let $56 = {_3 = $68; _2 = $65; _1 = $62; _0 = $59} */
  (*$56) = HEAP_ALLOC(sizeof(*(*$56)));
  (*$56)->tag = Union3_Type13;
  COPY(&(*$56)->Type13._3, &$68, sizeof(Union1));
  COPY(&(*$56)->Type13._2, &$65, sizeof(Union1));
  COPY(&(*$56)->Type13._1, &$62, sizeof(Union1));
  COPY(&(*$56)->Type13._0, &$59, sizeof(Union1));
}


void _mat4x4_mul_row$0(const mat4x4_mul_row$0_Closure *_clo, Union5 *restrict $55, Union3 v1$1) {
  /* let $55 = fun m2$1 -> (...) */
  (*$55).Type4 = HEAP_VALUE($55_Closure, {
    ._func = _$55,
    .mat4x4_col0$0 = _clo->mat4x4_col0$0,
    .mat4x4_col1$0 = _clo->mat4x4_col1$0,
    .mat4x4_col2$0 = _clo->mat4x4_col2$0,
    .mat4x4_col3$0 = _clo->mat4x4_col3$0,
    .v1$1 = v1$1,
    .vec4_dot$0 = _clo->vec4_dot$0,
  });
}


void _$53(const $53_Closure *_clo, Union4 *restrict $54, Union4 m2$0) {
  /* let mat4x4_mul_row$0 = fun v1$1 -> (...) */
  Union5 mat4x4_mul_row$0;
  mat4x4_mul_row$0.Type4 = HEAP_VALUE(mat4x4_mul_row$0_Closure, {
    ._func = _mat4x4_mul_row$0,
    .mat4x4_col0$0 = _clo->mat4x4_col0$0,
    .mat4x4_col1$0 = _clo->mat4x4_col1$0,
    .mat4x4_col2$0 = _clo->mat4x4_col2$0,
    .mat4x4_col3$0 = _clo->mat4x4_col3$0,
    .vec4_dot$0 = _clo->vec4_dot$0,
  });
  
  /* let $69 = m1$0._0 */
  Union3 $69;
  switch (_clo->m1$0->tag) {
    case Union4_Type14:
      COPY(&$69, &_clo->m1$0->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$69, &_clo->m1$0->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $70 = mat4x4_mul_row$0 $69 */
  Union5 $70;
  CALL(mat4x4_mul_row$0.Type4, &$70, $69);
  
  /* let $71 = $70 m2$0 */
  Union3 $71;
  CALL($70.Type4, &$71, m2$0);
  
  /* let $72 = m1$0._1 */
  Union3 $72;
  switch (_clo->m1$0->tag) {
    case Union4_Type14:
      COPY(&$72, &_clo->m1$0->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$72, &_clo->m1$0->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $73 = mat4x4_mul_row$0 $72 */
  Union5 $73;
  CALL(mat4x4_mul_row$0.Type4, &$73, $72);
  
  /* let $74 = $73 m2$0 */
  Union3 $74;
  CALL($73.Type4, &$74, m2$0);
  
  /* let $75 = m1$0._2 */
  Union3 $75;
  switch (_clo->m1$0->tag) {
    case Union4_Type14:
      COPY(&$75, &_clo->m1$0->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$75, &_clo->m1$0->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $76 = mat4x4_mul_row$0 $75 */
  Union5 $76;
  CALL(mat4x4_mul_row$0.Type4, &$76, $75);
  
  /* let $77 = $76 m2$0 */
  Union3 $77;
  CALL($76.Type4, &$77, m2$0);
  
  /* let $78 = m1$0._3 */
  Union3 $78;
  switch (_clo->m1$0->tag) {
    case Union4_Type14:
      COPY(&$78, &_clo->m1$0->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$78, &_clo->m1$0->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $79 = mat4x4_mul_row$0 $78 */
  Union5 $79;
  CALL(mat4x4_mul_row$0.Type4, &$79, $78);
  
  /* let $80 = $79 m2$0 */
  Union3 $80;
  CALL($79.Type4, &$80, m2$0);
  
  /* let $54 = {_3 = $80; _2 = $77; _1 = $74; _0 = $71} */
  (*$54) = HEAP_ALLOC(sizeof(*(*$54)));
  (*$54)->tag = Union4_Type15;
  COPY(&(*$54)->Type15._3, &$80, sizeof(Union3));
  COPY(&(*$54)->Type15._2, &$77, sizeof(Union3));
  COPY(&(*$54)->Type15._1, &$74, sizeof(Union3));
  COPY(&(*$54)->Type15._0, &$71, sizeof(Union3));
}


void _mat4x4_mul$0(const mat4x4_mul$0_Closure *_clo, Union5 *restrict $53, Union4 m1$0) {
  /* let $53 = fun m2$0 -> (...) */
  (*$53).Type4 = HEAP_VALUE($53_Closure, {
    ._func = _$53,
    .m1$0 = m1$0,
    .mat4x4_col0$0 = _clo->mat4x4_col0$0,
    .mat4x4_col1$0 = _clo->mat4x4_col1$0,
    .mat4x4_col2$0 = _clo->mat4x4_col2$0,
    .mat4x4_col3$0 = _clo->mat4x4_col3$0,
    .vec4_dot$0 = _clo->vec4_dot$0,
  });
}


void _mat4x4_det$0(const mat4x4_det$0_Closure *_clo, Union1 *restrict $81, Union4 m$4) {
  /* let $82 = m$4._0 */
  Union3 $82;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$82, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$82, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $83 = $82._3 */
  Union1 $83;
  switch ($82->tag) {
    case Union3_Type9:
      COPY(&$83, &$82->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$83, &$82->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$83, &$82->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$83, &$82->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$83, &$82->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $84 = m$4._1 */
  Union3 $84;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$84, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$84, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $85 = $84._2 */
  Union1 $85;
  switch ($84->tag) {
    case Union3_Type9:
      COPY(&$85, &$84->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$85, &$84->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$85, &$84->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$85, &$84->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$85, &$84->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $86 = $83 * $85 */
  Union1 $86;
  $86.Type1 = $83.Type1 * $85.Type1;
  
  /* let $87 = m$4._2 */
  Union3 $87;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$87, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$87, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $88 = $87._1 */
  Union1 $88;
  switch ($87->tag) {
    case Union3_Type9:
      COPY(&$88, &$87->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$88, &$87->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$88, &$87->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$88, &$87->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$88, &$87->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $89 = $86 * $88 */
  Union1 $89;
  $89.Type1 = $86.Type1 * $88.Type1;
  
  /* let $90 = m$4._3 */
  Union3 $90;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$90, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$90, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $91 = $90._0 */
  Union1 $91;
  switch ($90->tag) {
    case Union3_Type9:
      COPY(&$91, &$90->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$91, &$90->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$91, &$90->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$91, &$90->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$91, &$90->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $92 = $89 * $91 */
  Union1 $92;
  $92.Type1 = $89.Type1 * $91.Type1;
  
  /* let $93 = m$4._0 */
  Union3 $93;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$93, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$93, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $94 = $93._2 */
  Union1 $94;
  switch ($93->tag) {
    case Union3_Type9:
      COPY(&$94, &$93->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$94, &$93->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$94, &$93->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$94, &$93->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$94, &$93->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $95 = m$4._1 */
  Union3 $95;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$95, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$95, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $96 = $95._3 */
  Union1 $96;
  switch ($95->tag) {
    case Union3_Type9:
      COPY(&$96, &$95->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$96, &$95->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$96, &$95->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$96, &$95->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$96, &$95->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $97 = $94 * $96 */
  Union1 $97;
  $97.Type1 = $94.Type1 * $96.Type1;
  
  /* let $98 = m$4._2 */
  Union3 $98;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$98, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$98, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $99 = $98._1 */
  Union1 $99;
  switch ($98->tag) {
    case Union3_Type9:
      COPY(&$99, &$98->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$99, &$98->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$99, &$98->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$99, &$98->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$99, &$98->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $100 = $97 * $99 */
  Union1 $100;
  $100.Type1 = $97.Type1 * $99.Type1;
  
  /* let $101 = m$4._3 */
  Union3 $101;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$101, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$101, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $102 = $101._0 */
  Union1 $102;
  switch ($101->tag) {
    case Union3_Type9:
      COPY(&$102, &$101->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$102, &$101->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$102, &$101->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$102, &$101->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$102, &$101->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $103 = $100 * $102 */
  Union1 $103;
  $103.Type1 = $100.Type1 * $102.Type1;
  
  /* let $104 = $92 - $103 */
  Union1 $104;
  $104.Type1 = $92.Type1 - $103.Type1;
  
  /* let $105 = m$4._0 */
  Union3 $105;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$105, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$105, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $106 = $105._3 */
  Union1 $106;
  switch ($105->tag) {
    case Union3_Type9:
      COPY(&$106, &$105->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$106, &$105->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$106, &$105->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$106, &$105->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$106, &$105->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $107 = m$4._1 */
  Union3 $107;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$107, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$107, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $108 = $107._1 */
  Union1 $108;
  switch ($107->tag) {
    case Union3_Type9:
      COPY(&$108, &$107->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$108, &$107->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$108, &$107->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$108, &$107->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$108, &$107->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $109 = $106 * $108 */
  Union1 $109;
  $109.Type1 = $106.Type1 * $108.Type1;
  
  /* let $110 = m$4._2 */
  Union3 $110;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$110, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$110, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $111 = $110._2 */
  Union1 $111;
  switch ($110->tag) {
    case Union3_Type9:
      COPY(&$111, &$110->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$111, &$110->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$111, &$110->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$111, &$110->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$111, &$110->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $112 = $109 * $111 */
  Union1 $112;
  $112.Type1 = $109.Type1 * $111.Type1;
  
  /* let $113 = m$4._3 */
  Union3 $113;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$113, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$113, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $114 = $113._0 */
  Union1 $114;
  switch ($113->tag) {
    case Union3_Type9:
      COPY(&$114, &$113->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$114, &$113->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$114, &$113->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$114, &$113->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$114, &$113->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $115 = $112 * $114 */
  Union1 $115;
  $115.Type1 = $112.Type1 * $114.Type1;
  
  /* let $116 = $104 - $115 */
  Union1 $116;
  $116.Type1 = $104.Type1 - $115.Type1;
  
  /* let $117 = m$4._0 */
  Union3 $117;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$117, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$117, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $118 = $117._1 */
  Union1 $118;
  switch ($117->tag) {
    case Union3_Type9:
      COPY(&$118, &$117->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$118, &$117->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$118, &$117->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$118, &$117->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$118, &$117->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $119 = m$4._1 */
  Union3 $119;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$119, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$119, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $120 = $119._3 */
  Union1 $120;
  switch ($119->tag) {
    case Union3_Type9:
      COPY(&$120, &$119->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$120, &$119->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$120, &$119->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$120, &$119->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$120, &$119->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $121 = $118 * $120 */
  Union1 $121;
  $121.Type1 = $118.Type1 * $120.Type1;
  
  /* let $122 = m$4._2 */
  Union3 $122;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$122, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$122, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $123 = $122._2 */
  Union1 $123;
  switch ($122->tag) {
    case Union3_Type9:
      COPY(&$123, &$122->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$123, &$122->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$123, &$122->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$123, &$122->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$123, &$122->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $124 = $121 * $123 */
  Union1 $124;
  $124.Type1 = $121.Type1 * $123.Type1;
  
  /* let $125 = m$4._3 */
  Union3 $125;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$125, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$125, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $126 = $125._0 */
  Union1 $126;
  switch ($125->tag) {
    case Union3_Type9:
      COPY(&$126, &$125->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$126, &$125->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$126, &$125->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$126, &$125->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$126, &$125->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $127 = $124 * $126 */
  Union1 $127;
  $127.Type1 = $124.Type1 * $126.Type1;
  
  /* let $128 = $116 + $127 */
  Union1 $128;
  $128.Type1 = $116.Type1 + $127.Type1;
  
  /* let $129 = m$4._0 */
  Union3 $129;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$129, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$129, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $130 = $129._2 */
  Union1 $130;
  switch ($129->tag) {
    case Union3_Type9:
      COPY(&$130, &$129->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$130, &$129->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$130, &$129->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$130, &$129->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$130, &$129->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $131 = m$4._1 */
  Union3 $131;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$131, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$131, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $132 = $131._1 */
  Union1 $132;
  switch ($131->tag) {
    case Union3_Type9:
      COPY(&$132, &$131->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$132, &$131->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$132, &$131->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$132, &$131->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$132, &$131->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $133 = $130 * $132 */
  Union1 $133;
  $133.Type1 = $130.Type1 * $132.Type1;
  
  /* let $134 = m$4._2 */
  Union3 $134;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$134, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$134, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $135 = $134._3 */
  Union1 $135;
  switch ($134->tag) {
    case Union3_Type9:
      COPY(&$135, &$134->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$135, &$134->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$135, &$134->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$135, &$134->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$135, &$134->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $136 = $133 * $135 */
  Union1 $136;
  $136.Type1 = $133.Type1 * $135.Type1;
  
  /* let $137 = m$4._3 */
  Union3 $137;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$137, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$137, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $138 = $137._0 */
  Union1 $138;
  switch ($137->tag) {
    case Union3_Type9:
      COPY(&$138, &$137->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$138, &$137->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$138, &$137->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$138, &$137->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$138, &$137->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $139 = $136 * $138 */
  Union1 $139;
  $139.Type1 = $136.Type1 * $138.Type1;
  
  /* let $140 = $128 + $139 */
  Union1 $140;
  $140.Type1 = $128.Type1 + $139.Type1;
  
  /* let $141 = m$4._0 */
  Union3 $141;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$141, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$141, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $142 = $141._1 */
  Union1 $142;
  switch ($141->tag) {
    case Union3_Type9:
      COPY(&$142, &$141->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$142, &$141->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$142, &$141->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$142, &$141->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$142, &$141->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $143 = m$4._1 */
  Union3 $143;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$143, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$143, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $144 = $143._2 */
  Union1 $144;
  switch ($143->tag) {
    case Union3_Type9:
      COPY(&$144, &$143->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$144, &$143->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$144, &$143->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$144, &$143->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$144, &$143->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $145 = $142 * $144 */
  Union1 $145;
  $145.Type1 = $142.Type1 * $144.Type1;
  
  /* let $146 = m$4._2 */
  Union3 $146;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$146, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$146, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $147 = $146._3 */
  Union1 $147;
  switch ($146->tag) {
    case Union3_Type9:
      COPY(&$147, &$146->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$147, &$146->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$147, &$146->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$147, &$146->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$147, &$146->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $148 = $145 * $147 */
  Union1 $148;
  $148.Type1 = $145.Type1 * $147.Type1;
  
  /* let $149 = m$4._3 */
  Union3 $149;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$149, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$149, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $150 = $149._0 */
  Union1 $150;
  switch ($149->tag) {
    case Union3_Type9:
      COPY(&$150, &$149->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$150, &$149->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$150, &$149->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$150, &$149->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$150, &$149->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $151 = $148 * $150 */
  Union1 $151;
  $151.Type1 = $148.Type1 * $150.Type1;
  
  /* let $152 = $140 - $151 */
  Union1 $152;
  $152.Type1 = $140.Type1 - $151.Type1;
  
  /* let $153 = m$4._0 */
  Union3 $153;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$153, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$153, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $154 = $153._3 */
  Union1 $154;
  switch ($153->tag) {
    case Union3_Type9:
      COPY(&$154, &$153->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$154, &$153->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$154, &$153->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$154, &$153->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$154, &$153->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $155 = m$4._1 */
  Union3 $155;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$155, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$155, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $156 = $155._2 */
  Union1 $156;
  switch ($155->tag) {
    case Union3_Type9:
      COPY(&$156, &$155->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$156, &$155->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$156, &$155->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$156, &$155->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$156, &$155->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $157 = $154 * $156 */
  Union1 $157;
  $157.Type1 = $154.Type1 * $156.Type1;
  
  /* let $158 = m$4._2 */
  Union3 $158;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$158, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$158, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $159 = $158._0 */
  Union1 $159;
  switch ($158->tag) {
    case Union3_Type9:
      COPY(&$159, &$158->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$159, &$158->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$159, &$158->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$159, &$158->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$159, &$158->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $160 = $157 * $159 */
  Union1 $160;
  $160.Type1 = $157.Type1 * $159.Type1;
  
  /* let $161 = m$4._3 */
  Union3 $161;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$161, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$161, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $162 = $161._1 */
  Union1 $162;
  switch ($161->tag) {
    case Union3_Type9:
      COPY(&$162, &$161->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$162, &$161->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$162, &$161->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$162, &$161->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$162, &$161->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $163 = $160 * $162 */
  Union1 $163;
  $163.Type1 = $160.Type1 * $162.Type1;
  
  /* let $164 = $152 - $163 */
  Union1 $164;
  $164.Type1 = $152.Type1 - $163.Type1;
  
  /* let $165 = m$4._0 */
  Union3 $165;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$165, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$165, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $166 = $165._2 */
  Union1 $166;
  switch ($165->tag) {
    case Union3_Type9:
      COPY(&$166, &$165->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$166, &$165->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$166, &$165->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$166, &$165->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$166, &$165->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $167 = m$4._1 */
  Union3 $167;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$167, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$167, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $168 = $167._3 */
  Union1 $168;
  switch ($167->tag) {
    case Union3_Type9:
      COPY(&$168, &$167->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$168, &$167->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$168, &$167->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$168, &$167->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$168, &$167->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $169 = $166 * $168 */
  Union1 $169;
  $169.Type1 = $166.Type1 * $168.Type1;
  
  /* let $170 = m$4._2 */
  Union3 $170;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$170, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$170, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $171 = $170._0 */
  Union1 $171;
  switch ($170->tag) {
    case Union3_Type9:
      COPY(&$171, &$170->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$171, &$170->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$171, &$170->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$171, &$170->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$171, &$170->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $172 = $169 * $171 */
  Union1 $172;
  $172.Type1 = $169.Type1 * $171.Type1;
  
  /* let $173 = m$4._3 */
  Union3 $173;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$173, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$173, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $174 = $173._1 */
  Union1 $174;
  switch ($173->tag) {
    case Union3_Type9:
      COPY(&$174, &$173->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$174, &$173->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$174, &$173->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$174, &$173->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$174, &$173->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $175 = $172 * $174 */
  Union1 $175;
  $175.Type1 = $172.Type1 * $174.Type1;
  
  /* let $176 = $164 + $175 */
  Union1 $176;
  $176.Type1 = $164.Type1 + $175.Type1;
  
  /* let $177 = m$4._0 */
  Union3 $177;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$177, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$177, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $178 = $177._3 */
  Union1 $178;
  switch ($177->tag) {
    case Union3_Type9:
      COPY(&$178, &$177->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$178, &$177->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$178, &$177->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$178, &$177->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$178, &$177->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $179 = m$4._1 */
  Union3 $179;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$179, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$179, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $180 = $179._0 */
  Union1 $180;
  switch ($179->tag) {
    case Union3_Type9:
      COPY(&$180, &$179->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$180, &$179->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$180, &$179->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$180, &$179->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$180, &$179->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $181 = $178 * $180 */
  Union1 $181;
  $181.Type1 = $178.Type1 * $180.Type1;
  
  /* let $182 = m$4._2 */
  Union3 $182;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$182, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$182, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $183 = $182._2 */
  Union1 $183;
  switch ($182->tag) {
    case Union3_Type9:
      COPY(&$183, &$182->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$183, &$182->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$183, &$182->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$183, &$182->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$183, &$182->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $184 = $181 * $183 */
  Union1 $184;
  $184.Type1 = $181.Type1 * $183.Type1;
  
  /* let $185 = m$4._3 */
  Union3 $185;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$185, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$185, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $186 = $185._1 */
  Union1 $186;
  switch ($185->tag) {
    case Union3_Type9:
      COPY(&$186, &$185->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$186, &$185->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$186, &$185->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$186, &$185->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$186, &$185->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $187 = $184 * $186 */
  Union1 $187;
  $187.Type1 = $184.Type1 * $186.Type1;
  
  /* let $188 = $176 + $187 */
  Union1 $188;
  $188.Type1 = $176.Type1 + $187.Type1;
  
  /* let $189 = m$4._0 */
  Union3 $189;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$189, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$189, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $190 = $189._0 */
  Union1 $190;
  switch ($189->tag) {
    case Union3_Type9:
      COPY(&$190, &$189->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$190, &$189->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$190, &$189->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$190, &$189->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$190, &$189->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $191 = m$4._1 */
  Union3 $191;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$191, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$191, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $192 = $191._3 */
  Union1 $192;
  switch ($191->tag) {
    case Union3_Type9:
      COPY(&$192, &$191->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$192, &$191->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$192, &$191->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$192, &$191->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$192, &$191->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $193 = $190 * $192 */
  Union1 $193;
  $193.Type1 = $190.Type1 * $192.Type1;
  
  /* let $194 = m$4._2 */
  Union3 $194;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$194, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$194, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $195 = $194._2 */
  Union1 $195;
  switch ($194->tag) {
    case Union3_Type9:
      COPY(&$195, &$194->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$195, &$194->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$195, &$194->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$195, &$194->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$195, &$194->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $196 = $193 * $195 */
  Union1 $196;
  $196.Type1 = $193.Type1 * $195.Type1;
  
  /* let $197 = m$4._3 */
  Union3 $197;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$197, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$197, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $198 = $197._1 */
  Union1 $198;
  switch ($197->tag) {
    case Union3_Type9:
      COPY(&$198, &$197->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$198, &$197->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$198, &$197->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$198, &$197->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$198, &$197->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $199 = $196 * $198 */
  Union1 $199;
  $199.Type1 = $196.Type1 * $198.Type1;
  
  /* let $200 = $188 - $199 */
  Union1 $200;
  $200.Type1 = $188.Type1 - $199.Type1;
  
  /* let $201 = m$4._0 */
  Union3 $201;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$201, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$201, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $202 = $201._2 */
  Union1 $202;
  switch ($201->tag) {
    case Union3_Type9:
      COPY(&$202, &$201->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$202, &$201->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$202, &$201->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$202, &$201->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$202, &$201->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $203 = m$4._1 */
  Union3 $203;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$203, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$203, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $204 = $203._0 */
  Union1 $204;
  switch ($203->tag) {
    case Union3_Type9:
      COPY(&$204, &$203->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$204, &$203->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$204, &$203->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$204, &$203->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$204, &$203->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $205 = $202 * $204 */
  Union1 $205;
  $205.Type1 = $202.Type1 * $204.Type1;
  
  /* let $206 = m$4._2 */
  Union3 $206;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$206, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$206, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $207 = $206._3 */
  Union1 $207;
  switch ($206->tag) {
    case Union3_Type9:
      COPY(&$207, &$206->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$207, &$206->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$207, &$206->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$207, &$206->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$207, &$206->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $208 = $205 * $207 */
  Union1 $208;
  $208.Type1 = $205.Type1 * $207.Type1;
  
  /* let $209 = m$4._3 */
  Union3 $209;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$209, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$209, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $210 = $209._1 */
  Union1 $210;
  switch ($209->tag) {
    case Union3_Type9:
      COPY(&$210, &$209->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$210, &$209->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$210, &$209->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$210, &$209->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$210, &$209->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $211 = $208 * $210 */
  Union1 $211;
  $211.Type1 = $208.Type1 * $210.Type1;
  
  /* let $212 = $200 - $211 */
  Union1 $212;
  $212.Type1 = $200.Type1 - $211.Type1;
  
  /* let $213 = m$4._0 */
  Union3 $213;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$213, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$213, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $214 = $213._0 */
  Union1 $214;
  switch ($213->tag) {
    case Union3_Type9:
      COPY(&$214, &$213->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$214, &$213->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$214, &$213->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$214, &$213->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$214, &$213->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $215 = m$4._1 */
  Union3 $215;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$215, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$215, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $216 = $215._2 */
  Union1 $216;
  switch ($215->tag) {
    case Union3_Type9:
      COPY(&$216, &$215->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$216, &$215->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$216, &$215->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$216, &$215->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$216, &$215->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $217 = $214 * $216 */
  Union1 $217;
  $217.Type1 = $214.Type1 * $216.Type1;
  
  /* let $218 = m$4._2 */
  Union3 $218;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$218, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$218, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $219 = $218._3 */
  Union1 $219;
  switch ($218->tag) {
    case Union3_Type9:
      COPY(&$219, &$218->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$219, &$218->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$219, &$218->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$219, &$218->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$219, &$218->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $220 = $217 * $219 */
  Union1 $220;
  $220.Type1 = $217.Type1 * $219.Type1;
  
  /* let $221 = m$4._3 */
  Union3 $221;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$221, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$221, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $222 = $221._1 */
  Union1 $222;
  switch ($221->tag) {
    case Union3_Type9:
      COPY(&$222, &$221->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$222, &$221->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$222, &$221->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$222, &$221->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$222, &$221->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $223 = $220 * $222 */
  Union1 $223;
  $223.Type1 = $220.Type1 * $222.Type1;
  
  /* let $224 = $212 + $223 */
  Union1 $224;
  $224.Type1 = $212.Type1 + $223.Type1;
  
  /* let $225 = m$4._0 */
  Union3 $225;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$225, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$225, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $226 = $225._3 */
  Union1 $226;
  switch ($225->tag) {
    case Union3_Type9:
      COPY(&$226, &$225->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$226, &$225->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$226, &$225->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$226, &$225->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$226, &$225->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $227 = m$4._1 */
  Union3 $227;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$227, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$227, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $228 = $227._1 */
  Union1 $228;
  switch ($227->tag) {
    case Union3_Type9:
      COPY(&$228, &$227->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$228, &$227->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$228, &$227->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$228, &$227->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$228, &$227->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $229 = $226 * $228 */
  Union1 $229;
  $229.Type1 = $226.Type1 * $228.Type1;
  
  /* let $230 = m$4._2 */
  Union3 $230;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$230, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$230, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $231 = $230._0 */
  Union1 $231;
  switch ($230->tag) {
    case Union3_Type9:
      COPY(&$231, &$230->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$231, &$230->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$231, &$230->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$231, &$230->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$231, &$230->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $232 = $229 * $231 */
  Union1 $232;
  $232.Type1 = $229.Type1 * $231.Type1;
  
  /* let $233 = m$4._3 */
  Union3 $233;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$233, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$233, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $234 = $233._2 */
  Union1 $234;
  switch ($233->tag) {
    case Union3_Type9:
      COPY(&$234, &$233->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$234, &$233->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$234, &$233->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$234, &$233->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$234, &$233->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $235 = $232 * $234 */
  Union1 $235;
  $235.Type1 = $232.Type1 * $234.Type1;
  
  /* let $236 = $224 + $235 */
  Union1 $236;
  $236.Type1 = $224.Type1 + $235.Type1;
  
  /* let $237 = m$4._0 */
  Union3 $237;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$237, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$237, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $238 = $237._1 */
  Union1 $238;
  switch ($237->tag) {
    case Union3_Type9:
      COPY(&$238, &$237->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$238, &$237->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$238, &$237->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$238, &$237->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$238, &$237->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $239 = m$4._1 */
  Union3 $239;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$239, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$239, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $240 = $239._3 */
  Union1 $240;
  switch ($239->tag) {
    case Union3_Type9:
      COPY(&$240, &$239->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$240, &$239->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$240, &$239->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$240, &$239->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$240, &$239->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $241 = $238 * $240 */
  Union1 $241;
  $241.Type1 = $238.Type1 * $240.Type1;
  
  /* let $242 = m$4._2 */
  Union3 $242;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$242, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$242, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $243 = $242._0 */
  Union1 $243;
  switch ($242->tag) {
    case Union3_Type9:
      COPY(&$243, &$242->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$243, &$242->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$243, &$242->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$243, &$242->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$243, &$242->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $244 = $241 * $243 */
  Union1 $244;
  $244.Type1 = $241.Type1 * $243.Type1;
  
  /* let $245 = m$4._3 */
  Union3 $245;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$245, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$245, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $246 = $245._2 */
  Union1 $246;
  switch ($245->tag) {
    case Union3_Type9:
      COPY(&$246, &$245->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$246, &$245->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$246, &$245->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$246, &$245->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$246, &$245->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $247 = $244 * $246 */
  Union1 $247;
  $247.Type1 = $244.Type1 * $246.Type1;
  
  /* let $248 = $236 - $247 */
  Union1 $248;
  $248.Type1 = $236.Type1 - $247.Type1;
  
  /* let $249 = m$4._0 */
  Union3 $249;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$249, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$249, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $250 = $249._3 */
  Union1 $250;
  switch ($249->tag) {
    case Union3_Type9:
      COPY(&$250, &$249->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$250, &$249->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$250, &$249->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$250, &$249->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$250, &$249->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $251 = m$4._1 */
  Union3 $251;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$251, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$251, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $252 = $251._0 */
  Union1 $252;
  switch ($251->tag) {
    case Union3_Type9:
      COPY(&$252, &$251->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$252, &$251->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$252, &$251->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$252, &$251->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$252, &$251->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $253 = $250 * $252 */
  Union1 $253;
  $253.Type1 = $250.Type1 * $252.Type1;
  
  /* let $254 = m$4._2 */
  Union3 $254;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$254, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$254, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $255 = $254._1 */
  Union1 $255;
  switch ($254->tag) {
    case Union3_Type9:
      COPY(&$255, &$254->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$255, &$254->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$255, &$254->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$255, &$254->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$255, &$254->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $256 = $253 * $255 */
  Union1 $256;
  $256.Type1 = $253.Type1 * $255.Type1;
  
  /* let $257 = m$4._3 */
  Union3 $257;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$257, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$257, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $258 = $257._2 */
  Union1 $258;
  switch ($257->tag) {
    case Union3_Type9:
      COPY(&$258, &$257->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$258, &$257->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$258, &$257->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$258, &$257->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$258, &$257->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $259 = $256 * $258 */
  Union1 $259;
  $259.Type1 = $256.Type1 * $258.Type1;
  
  /* let $260 = $248 - $259 */
  Union1 $260;
  $260.Type1 = $248.Type1 - $259.Type1;
  
  /* let $261 = m$4._0 */
  Union3 $261;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$261, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$261, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $262 = $261._0 */
  Union1 $262;
  switch ($261->tag) {
    case Union3_Type9:
      COPY(&$262, &$261->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$262, &$261->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$262, &$261->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$262, &$261->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$262, &$261->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $263 = m$4._1 */
  Union3 $263;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$263, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$263, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $264 = $263._3 */
  Union1 $264;
  switch ($263->tag) {
    case Union3_Type9:
      COPY(&$264, &$263->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$264, &$263->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$264, &$263->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$264, &$263->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$264, &$263->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $265 = $262 * $264 */
  Union1 $265;
  $265.Type1 = $262.Type1 * $264.Type1;
  
  /* let $266 = m$4._2 */
  Union3 $266;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$266, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$266, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $267 = $266._1 */
  Union1 $267;
  switch ($266->tag) {
    case Union3_Type9:
      COPY(&$267, &$266->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$267, &$266->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$267, &$266->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$267, &$266->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$267, &$266->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $268 = $265 * $267 */
  Union1 $268;
  $268.Type1 = $265.Type1 * $267.Type1;
  
  /* let $269 = m$4._3 */
  Union3 $269;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$269, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$269, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $270 = $269._2 */
  Union1 $270;
  switch ($269->tag) {
    case Union3_Type9:
      COPY(&$270, &$269->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$270, &$269->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$270, &$269->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$270, &$269->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$270, &$269->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $271 = $268 * $270 */
  Union1 $271;
  $271.Type1 = $268.Type1 * $270.Type1;
  
  /* let $272 = $260 + $271 */
  Union1 $272;
  $272.Type1 = $260.Type1 + $271.Type1;
  
  /* let $273 = m$4._0 */
  Union3 $273;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$273, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$273, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $274 = $273._1 */
  Union1 $274;
  switch ($273->tag) {
    case Union3_Type9:
      COPY(&$274, &$273->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$274, &$273->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$274, &$273->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$274, &$273->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$274, &$273->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $275 = m$4._1 */
  Union3 $275;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$275, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$275, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $276 = $275._0 */
  Union1 $276;
  switch ($275->tag) {
    case Union3_Type9:
      COPY(&$276, &$275->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$276, &$275->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$276, &$275->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$276, &$275->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$276, &$275->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $277 = $274 * $276 */
  Union1 $277;
  $277.Type1 = $274.Type1 * $276.Type1;
  
  /* let $278 = m$4._2 */
  Union3 $278;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$278, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$278, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $279 = $278._3 */
  Union1 $279;
  switch ($278->tag) {
    case Union3_Type9:
      COPY(&$279, &$278->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$279, &$278->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$279, &$278->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$279, &$278->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$279, &$278->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $280 = $277 * $279 */
  Union1 $280;
  $280.Type1 = $277.Type1 * $279.Type1;
  
  /* let $281 = m$4._3 */
  Union3 $281;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$281, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$281, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $282 = $281._2 */
  Union1 $282;
  switch ($281->tag) {
    case Union3_Type9:
      COPY(&$282, &$281->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$282, &$281->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$282, &$281->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$282, &$281->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$282, &$281->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $283 = $280 * $282 */
  Union1 $283;
  $283.Type1 = $280.Type1 * $282.Type1;
  
  /* let $284 = $272 + $283 */
  Union1 $284;
  $284.Type1 = $272.Type1 + $283.Type1;
  
  /* let $285 = m$4._0 */
  Union3 $285;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$285, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$285, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $286 = $285._0 */
  Union1 $286;
  switch ($285->tag) {
    case Union3_Type9:
      COPY(&$286, &$285->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$286, &$285->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$286, &$285->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$286, &$285->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$286, &$285->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $287 = m$4._1 */
  Union3 $287;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$287, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$287, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $288 = $287._1 */
  Union1 $288;
  switch ($287->tag) {
    case Union3_Type9:
      COPY(&$288, &$287->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$288, &$287->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$288, &$287->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$288, &$287->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$288, &$287->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $289 = $286 * $288 */
  Union1 $289;
  $289.Type1 = $286.Type1 * $288.Type1;
  
  /* let $290 = m$4._2 */
  Union3 $290;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$290, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$290, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $291 = $290._3 */
  Union1 $291;
  switch ($290->tag) {
    case Union3_Type9:
      COPY(&$291, &$290->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$291, &$290->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$291, &$290->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$291, &$290->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$291, &$290->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $292 = $289 * $291 */
  Union1 $292;
  $292.Type1 = $289.Type1 * $291.Type1;
  
  /* let $293 = m$4._3 */
  Union3 $293;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$293, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$293, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $294 = $293._2 */
  Union1 $294;
  switch ($293->tag) {
    case Union3_Type9:
      COPY(&$294, &$293->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$294, &$293->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$294, &$293->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$294, &$293->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$294, &$293->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $295 = $292 * $294 */
  Union1 $295;
  $295.Type1 = $292.Type1 * $294.Type1;
  
  /* let $296 = $284 - $295 */
  Union1 $296;
  $296.Type1 = $284.Type1 - $295.Type1;
  
  /* let $297 = m$4._0 */
  Union3 $297;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$297, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$297, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $298 = $297._2 */
  Union1 $298;
  switch ($297->tag) {
    case Union3_Type9:
      COPY(&$298, &$297->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$298, &$297->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$298, &$297->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$298, &$297->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$298, &$297->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $299 = m$4._1 */
  Union3 $299;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$299, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$299, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $300 = $299._1 */
  Union1 $300;
  switch ($299->tag) {
    case Union3_Type9:
      COPY(&$300, &$299->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$300, &$299->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$300, &$299->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$300, &$299->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$300, &$299->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $301 = $298 * $300 */
  Union1 $301;
  $301.Type1 = $298.Type1 * $300.Type1;
  
  /* let $302 = m$4._2 */
  Union3 $302;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$302, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$302, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $303 = $302._0 */
  Union1 $303;
  switch ($302->tag) {
    case Union3_Type9:
      COPY(&$303, &$302->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$303, &$302->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$303, &$302->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$303, &$302->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$303, &$302->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $304 = $301 * $303 */
  Union1 $304;
  $304.Type1 = $301.Type1 * $303.Type1;
  
  /* let $305 = m$4._3 */
  Union3 $305;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$305, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$305, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $306 = $305._3 */
  Union1 $306;
  switch ($305->tag) {
    case Union3_Type9:
      COPY(&$306, &$305->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$306, &$305->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$306, &$305->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$306, &$305->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$306, &$305->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $307 = $304 * $306 */
  Union1 $307;
  $307.Type1 = $304.Type1 * $306.Type1;
  
  /* let $308 = $296 - $307 */
  Union1 $308;
  $308.Type1 = $296.Type1 - $307.Type1;
  
  /* let $309 = m$4._0 */
  Union3 $309;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$309, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$309, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $310 = $309._1 */
  Union1 $310;
  switch ($309->tag) {
    case Union3_Type9:
      COPY(&$310, &$309->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$310, &$309->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$310, &$309->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$310, &$309->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$310, &$309->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $311 = m$4._1 */
  Union3 $311;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$311, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$311, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $312 = $311._2 */
  Union1 $312;
  switch ($311->tag) {
    case Union3_Type9:
      COPY(&$312, &$311->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$312, &$311->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$312, &$311->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$312, &$311->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$312, &$311->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $313 = $310 * $312 */
  Union1 $313;
  $313.Type1 = $310.Type1 * $312.Type1;
  
  /* let $314 = m$4._2 */
  Union3 $314;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$314, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$314, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $315 = $314._0 */
  Union1 $315;
  switch ($314->tag) {
    case Union3_Type9:
      COPY(&$315, &$314->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$315, &$314->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$315, &$314->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$315, &$314->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$315, &$314->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $316 = $313 * $315 */
  Union1 $316;
  $316.Type1 = $313.Type1 * $315.Type1;
  
  /* let $317 = m$4._3 */
  Union3 $317;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$317, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$317, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $318 = $317._3 */
  Union1 $318;
  switch ($317->tag) {
    case Union3_Type9:
      COPY(&$318, &$317->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$318, &$317->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$318, &$317->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$318, &$317->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$318, &$317->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $319 = $316 * $318 */
  Union1 $319;
  $319.Type1 = $316.Type1 * $318.Type1;
  
  /* let $320 = $308 + $319 */
  Union1 $320;
  $320.Type1 = $308.Type1 + $319.Type1;
  
  /* let $321 = m$4._0 */
  Union3 $321;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$321, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$321, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $322 = $321._2 */
  Union1 $322;
  switch ($321->tag) {
    case Union3_Type9:
      COPY(&$322, &$321->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$322, &$321->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$322, &$321->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$322, &$321->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$322, &$321->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $323 = m$4._1 */
  Union3 $323;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$323, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$323, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $324 = $323._0 */
  Union1 $324;
  switch ($323->tag) {
    case Union3_Type9:
      COPY(&$324, &$323->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$324, &$323->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$324, &$323->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$324, &$323->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$324, &$323->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $325 = $322 * $324 */
  Union1 $325;
  $325.Type1 = $322.Type1 * $324.Type1;
  
  /* let $326 = m$4._2 */
  Union3 $326;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$326, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$326, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $327 = $326._1 */
  Union1 $327;
  switch ($326->tag) {
    case Union3_Type9:
      COPY(&$327, &$326->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$327, &$326->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$327, &$326->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$327, &$326->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$327, &$326->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $328 = $325 * $327 */
  Union1 $328;
  $328.Type1 = $325.Type1 * $327.Type1;
  
  /* let $329 = m$4._3 */
  Union3 $329;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$329, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$329, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $330 = $329._3 */
  Union1 $330;
  switch ($329->tag) {
    case Union3_Type9:
      COPY(&$330, &$329->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$330, &$329->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$330, &$329->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$330, &$329->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$330, &$329->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $331 = $328 * $330 */
  Union1 $331;
  $331.Type1 = $328.Type1 * $330.Type1;
  
  /* let $332 = $320 + $331 */
  Union1 $332;
  $332.Type1 = $320.Type1 + $331.Type1;
  
  /* let $333 = m$4._0 */
  Union3 $333;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$333, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$333, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $334 = $333._0 */
  Union1 $334;
  switch ($333->tag) {
    case Union3_Type9:
      COPY(&$334, &$333->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$334, &$333->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$334, &$333->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$334, &$333->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$334, &$333->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $335 = m$4._1 */
  Union3 $335;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$335, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$335, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $336 = $335._2 */
  Union1 $336;
  switch ($335->tag) {
    case Union3_Type9:
      COPY(&$336, &$335->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$336, &$335->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$336, &$335->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$336, &$335->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$336, &$335->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $337 = $334 * $336 */
  Union1 $337;
  $337.Type1 = $334.Type1 * $336.Type1;
  
  /* let $338 = m$4._2 */
  Union3 $338;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$338, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$338, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $339 = $338._1 */
  Union1 $339;
  switch ($338->tag) {
    case Union3_Type9:
      COPY(&$339, &$338->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$339, &$338->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$339, &$338->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$339, &$338->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$339, &$338->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $340 = $337 * $339 */
  Union1 $340;
  $340.Type1 = $337.Type1 * $339.Type1;
  
  /* let $341 = m$4._3 */
  Union3 $341;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$341, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$341, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $342 = $341._3 */
  Union1 $342;
  switch ($341->tag) {
    case Union3_Type9:
      COPY(&$342, &$341->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$342, &$341->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$342, &$341->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$342, &$341->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$342, &$341->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $343 = $340 * $342 */
  Union1 $343;
  $343.Type1 = $340.Type1 * $342.Type1;
  
  /* let $344 = $332 - $343 */
  Union1 $344;
  $344.Type1 = $332.Type1 - $343.Type1;
  
  /* let $345 = m$4._0 */
  Union3 $345;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$345, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$345, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $346 = $345._1 */
  Union1 $346;
  switch ($345->tag) {
    case Union3_Type9:
      COPY(&$346, &$345->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$346, &$345->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$346, &$345->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$346, &$345->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$346, &$345->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $347 = m$4._1 */
  Union3 $347;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$347, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$347, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $348 = $347._0 */
  Union1 $348;
  switch ($347->tag) {
    case Union3_Type9:
      COPY(&$348, &$347->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$348, &$347->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$348, &$347->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$348, &$347->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$348, &$347->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $349 = $346 * $348 */
  Union1 $349;
  $349.Type1 = $346.Type1 * $348.Type1;
  
  /* let $350 = m$4._2 */
  Union3 $350;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$350, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$350, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $351 = $350._2 */
  Union1 $351;
  switch ($350->tag) {
    case Union3_Type9:
      COPY(&$351, &$350->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$351, &$350->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$351, &$350->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$351, &$350->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$351, &$350->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $352 = $349 * $351 */
  Union1 $352;
  $352.Type1 = $349.Type1 * $351.Type1;
  
  /* let $353 = m$4._3 */
  Union3 $353;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$353, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$353, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $354 = $353._3 */
  Union1 $354;
  switch ($353->tag) {
    case Union3_Type9:
      COPY(&$354, &$353->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$354, &$353->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$354, &$353->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$354, &$353->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$354, &$353->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $355 = $352 * $354 */
  Union1 $355;
  $355.Type1 = $352.Type1 * $354.Type1;
  
  /* let $356 = $344 - $355 */
  Union1 $356;
  $356.Type1 = $344.Type1 - $355.Type1;
  
  /* let $357 = m$4._0 */
  Union3 $357;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$357, &m$4->Type14._0, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$357, &m$4->Type15._0, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $358 = $357._0 */
  Union1 $358;
  switch ($357->tag) {
    case Union3_Type9:
      COPY(&$358, &$357->Type9._0, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$358, &$357->Type10._0, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$358, &$357->Type11._0, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$358, &$357->Type12._0, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$358, &$357->Type13._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $359 = m$4._1 */
  Union3 $359;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$359, &m$4->Type14._1, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$359, &m$4->Type15._1, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $360 = $359._1 */
  Union1 $360;
  switch ($359->tag) {
    case Union3_Type9:
      COPY(&$360, &$359->Type9._1, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$360, &$359->Type10._1, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$360, &$359->Type11._1, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$360, &$359->Type12._1, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$360, &$359->Type13._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $361 = $358 * $360 */
  Union1 $361;
  $361.Type1 = $358.Type1 * $360.Type1;
  
  /* let $362 = m$4._2 */
  Union3 $362;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$362, &m$4->Type14._2, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$362, &m$4->Type15._2, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $363 = $362._2 */
  Union1 $363;
  switch ($362->tag) {
    case Union3_Type9:
      COPY(&$363, &$362->Type9._2, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$363, &$362->Type10._2, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$363, &$362->Type11._2, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$363, &$362->Type12._2, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$363, &$362->Type13._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $364 = $361 * $363 */
  Union1 $364;
  $364.Type1 = $361.Type1 * $363.Type1;
  
  /* let $365 = m$4._3 */
  Union3 $365;
  switch (m$4->tag) {
    case Union4_Type14:
      COPY(&$365, &m$4->Type14._3, sizeof(Union3));
      break;
    case Union4_Type15:
      COPY(&$365, &m$4->Type15._3, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $366 = $365._3 */
  Union1 $366;
  switch ($365->tag) {
    case Union3_Type9:
      COPY(&$366, &$365->Type9._3, sizeof(Union1));
      break;
    case Union3_Type10:
      COPY(&$366, &$365->Type10._3, sizeof(Union1));
      break;
    case Union3_Type11:
      COPY(&$366, &$365->Type11._3, sizeof(Union1));
      break;
    case Union3_Type12:
      COPY(&$366, &$365->Type12._3, sizeof(Union1));
      break;
    case Union3_Type13:
      COPY(&$366, &$365->Type13._3, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $367 = $364 * $366 */
  Union1 $367;
  $367.Type1 = $364.Type1 * $366.Type1;
  
  /* let $81 = $356 + $367 */
  (*$81).Type1 = $356.Type1 + $367.Type1;
}


void _mat4x4_input$0(const mat4x4_input$0_Closure *_clo, Union4 *restrict $368, Union6 _$0) {
  /* let $369 = input */
  Union1 $369;
  __input(&$369.Type1);
  
  /* let $370 = input */
  Union1 $370;
  __input(&$370.Type1);
  
  /* let $371 = input */
  Union1 $371;
  __input(&$371.Type1);
  
  /* let $372 = input */
  Union1 $372;
  __input(&$372.Type1);
  
  /* let $373 = {_3 = $372; _2 = $371; _1 = $370; _0 = $369} */
  Union3 $373;
  $373 = HEAP_ALLOC(sizeof(*$373));
  $373->tag = Union3_Type9;
  COPY(&$373->Type9._3, &$372, sizeof(Union1));
  COPY(&$373->Type9._2, &$371, sizeof(Union1));
  COPY(&$373->Type9._1, &$370, sizeof(Union1));
  COPY(&$373->Type9._0, &$369, sizeof(Union1));
  
  /* let $374 = input */
  Union1 $374;
  __input(&$374.Type1);
  
  /* let $375 = input */
  Union1 $375;
  __input(&$375.Type1);
  
  /* let $376 = input */
  Union1 $376;
  __input(&$376.Type1);
  
  /* let $377 = input */
  Union1 $377;
  __input(&$377.Type1);
  
  /* let $378 = {_3 = $377; _2 = $376; _1 = $375; _0 = $374} */
  Union3 $378;
  $378 = HEAP_ALLOC(sizeof(*$378));
  $378->tag = Union3_Type10;
  COPY(&$378->Type10._3, &$377, sizeof(Union1));
  COPY(&$378->Type10._2, &$376, sizeof(Union1));
  COPY(&$378->Type10._1, &$375, sizeof(Union1));
  COPY(&$378->Type10._0, &$374, sizeof(Union1));
  
  /* let $379 = input */
  Union1 $379;
  __input(&$379.Type1);
  
  /* let $380 = input */
  Union1 $380;
  __input(&$380.Type1);
  
  /* let $381 = input */
  Union1 $381;
  __input(&$381.Type1);
  
  /* let $382 = input */
  Union1 $382;
  __input(&$382.Type1);
  
  /* let $383 = {_3 = $382; _2 = $381; _1 = $380; _0 = $379} */
  Union3 $383;
  $383 = HEAP_ALLOC(sizeof(*$383));
  $383->tag = Union3_Type11;
  COPY(&$383->Type11._3, &$382, sizeof(Union1));
  COPY(&$383->Type11._2, &$381, sizeof(Union1));
  COPY(&$383->Type11._1, &$380, sizeof(Union1));
  COPY(&$383->Type11._0, &$379, sizeof(Union1));
  
  /* let $384 = input */
  Union1 $384;
  __input(&$384.Type1);
  
  /* let $385 = input */
  Union1 $385;
  __input(&$385.Type1);
  
  /* let $386 = input */
  Union1 $386;
  __input(&$386.Type1);
  
  /* let $387 = input */
  Union1 $387;
  __input(&$387.Type1);
  
  /* let $388 = {_3 = $387; _2 = $386; _1 = $385; _0 = $384} */
  Union3 $388;
  $388 = HEAP_ALLOC(sizeof(*$388));
  $388->tag = Union3_Type12;
  COPY(&$388->Type12._3, &$387, sizeof(Union1));
  COPY(&$388->Type12._2, &$386, sizeof(Union1));
  COPY(&$388->Type12._1, &$385, sizeof(Union1));
  COPY(&$388->Type12._0, &$384, sizeof(Union1));
  
  /* let $368 = {_3 = $388; _2 = $383; _1 = $378; _0 = $373} */
  (*$368) = HEAP_ALLOC(sizeof(*(*$368)));
  (*$368)->tag = Union4_Type14;
  COPY(&(*$368)->Type14._3, &$388, sizeof(Union3));
  COPY(&(*$368)->Type14._2, &$383, sizeof(Union3));
  COPY(&(*$368)->Type14._1, &$378, sizeof(Union3));
  COPY(&(*$368)->Type14._0, &$373, sizeof(Union3));
}


void _loop$0(const loop$0_Closure *_clo, Union1 *restrict $393, Union1 n$0) {
  /* let $394 = mat4x4_mul$0 m1$1 */
  Union5 $394;
  CALL(_clo->mat4x4_mul$0.Type4, &$394, _clo->m1$1);
  
  /* let $395 = mat4x4_mul$0 m2$2 */
  Union5 $395;
  CALL(_clo->mat4x4_mul$0.Type4, &$395, _clo->m2$2);
  
  /* let $396 = $395 m3$0 */
  Union4 $396;
  CALL($395.Type4, &$396, _clo->m3$0);
  
  /* let $397 = $394 $396 */
  Union4 $397;
  CALL($394.Type4, &$397, $396);
  
  /* let det$0 = mat4x4_det$0 $397 */
  Union1 det$0;
  CALL(_clo->mat4x4_det$0.Type4, &det$0, $397);
  
  /* let $398 = 1 */
  Union1 $398;
  $398.Type1 = 1;
  
  /* let $399 = n$0 == $398 */
  Union7 $399;
  if (n$0.Type1 == $398.Type1) {
    $399.tag = Union7_Type2;
  }
  else {
    $399.tag = Union7_Type3;
  }
  
  /* let $393 = match $399 with ... */
  switch ($399.tag) {
    case Union7_Type3:
    {
      /* let $402 = 1 */
      Union1 $402;
      $402.Type1 = 1;
      
      /* let $403 = n$0 - $402 */
      Union1 $403;
      $403.Type1 = n$0.Type1 - $402.Type1;
      
      /* let $401 = loop$0 $403 */
      CALL(UNTAGGED(Union5, Type4, (const Closure*)_clo).Type4, &(*$393), $403);
      break;
    }
    case Union7_Type2:
    {
      /* let $400 = det$0 */
      (*(&(*$393))) = det$0;
      break;
    }
    default:
      ABORT;
  }
}


void _main$0(const main$0_Closure *_clo, Union1 *restrict $389, Union8 _$1) {
  /* let num_reps$0 = input */
  Union1 num_reps$0;
  __input(&num_reps$0.Type1);
  
  /* let $390 = {} */
  Union6 $390;
  $390.tag = Union6_Type16;
  
  /* let m1$1 = mat4x4_input$0 $390 */
  Union4 m1$1;
  CALL(_clo->mat4x4_input$0.Type4, &m1$1, $390);
  
  /* let $391 = {} */
  Union6 $391;
  $391.tag = Union6_Type17;
  
  /* let m2$2 = mat4x4_input$0 $391 */
  Union4 m2$2;
  CALL(_clo->mat4x4_input$0.Type4, &m2$2, $391);
  
  /* let $392 = {} */
  Union6 $392;
  $392.tag = Union6_Type18;
  
  /* let m3$0 = mat4x4_input$0 $392 */
  Union4 m3$0;
  CALL(_clo->mat4x4_input$0.Type4, &m3$0, $392);
  
  /* let loop$0 = fun n$0 -> (...) */
  Union5 loop$0;
  loop$0.Type4 = HEAP_VALUE(loop$0_Closure, {
    ._func = _loop$0,
    .m1$1 = m1$1,
    .m2$2 = m2$2,
    .m3$0 = m3$0,
    .mat4x4_det$0 = _clo->mat4x4_det$0,
    .mat4x4_mul$0 = _clo->mat4x4_mul$0,
  });
  
  /* let $389 = loop$0 num_reps$0 */
  CALL(loop$0.Type4, &(*$389), num_reps$0);
}


int main(void) {
  time_t t;
  srand((unsigned) time(&t));
  Union1 result;
  ___main(NULL, &result);
  fprint_Union1(stdout, &result);
}
