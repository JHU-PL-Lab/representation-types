
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#if defined(GC)
#include <gc/gc.h>
#endif

typedef void Func();

typedef struct {
  Func *_func;
} Closure;

#define UNREACHABLE __builtin_unreachable()
#define ABORT exit(EXIT_FAILURE)
#define COPY(...) __builtin_memcpy(__VA_ARGS__)
#define COMBINE(a, b) (a) >= (b) ? (a) * (a) + (a) + (b) : (a) + (b) * (b)
#define CALL(c, ...) ((c)->_func)((c), __VA_ARGS__)

#if defined(GC)
#define HEAP_ALLOC(...) GC_MALLOC(__VA_ARGS__)
#else
#define HEAP_ALLOC(...) malloc(__VA_ARGS__)
#endif


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

typedef Empty Union0;

typedef struct {
  enum {
    Union1_Type1,
    Union1_Type3,
  } tag;
  union {
    Type1 Type1;
    Type3 Type3;
  };
}  Union1;

typedef struct { Type4 Type4; }  Union2;
typedef struct { Type1 Type1; }  Union3;
typedef struct {
  enum {
    Union4_Type2,
    Union4_Type3,
  } tag;
  union {
    Type2 Type2;
    Type3 Type3;
  };
}  Union4;

typedef struct {
  Func *_func;
} is_triplet$0_Closure;

typedef struct {
  Func *_func;
  Union3 a$0;
  Union3 b$0;
} c$0_Closure;

typedef struct {
  Func *_func;
  Union3 a$1;
  Union3 desired_sum$0;
  Union2 is_triplet$0;
} b_loop$0_Closure;

typedef struct {
  Func *_func;
  Union3 a$1;
  Union3 desired_sum$0;
  Union2 is_triplet$0;
} b$1_Closure;

typedef struct {
  Func *_func;
  Union3 a$0;
} b$0_Closure;

typedef struct {
  Func *_func;
  Union3 desired_sum$0;
  Union2 is_triplet$0;
} a_loop$0_Closure;

typedef struct {
  Func *_func;
  Union3 desired_sum$0;
  Union2 is_triplet$0;
} a$1_Closure;

typedef struct {
  Func *_func;
} a$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union3 a$0;
  Union3 b$0;
} $2_Closure;

typedef struct {
  Func *_func;
  Union3 a$0;
} $1_Closure;

Func _is_triplet$0;
Func _c$0;
Func _b_loop$0;
Func _b$1;
Func _b$0;
Func _a_loop$0;
Func _a$1;
Func _a$0;
Func ___main;
Func _$2;
Func _$1;

static inline void fprint_Type0(FILE *, const Type0*);
static inline void fprint_Type1(FILE *, const Type1*);
static inline void fprint_Type2(FILE *, const Type2*);
static inline void fprint_Type3(FILE *, const Type3*);
static inline void fprint_Type4(FILE *, const Type4*);
static inline void fprint_Union0(FILE *, const Union0*);
static inline void fprint_Union1(FILE *, const Union1*);
static inline void fprint_Union2(FILE *, const Union2*);
static inline void fprint_Union3(FILE *, const Union3*);
static inline void fprint_Union4(FILE *, const Union4*);

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
void fprint_Union0(FILE *stream, const Union0* value) {
  UNREACHABLE;
}
void fprint_Union1(FILE *stream, const Union1* value) {
  switch (value->tag) {
    case Union1_Type1:
      fprint_Type1(stream, &value->Type1);
      break;
    case Union1_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}
void fprint_Union2(FILE *stream, const Union2* value) {
  fprint_Type4(stream, &value->Type4);
}
void fprint_Union3(FILE *stream, const Union3* value) {
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union4(FILE *stream, const Union4* value) {
  switch (value->tag) {
    case Union4_Type2:
      fprint_Type2(stream, &value->Type2);
      break;
    case Union4_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  tail_call:;
  /* let is_triplet$0 = fun a$0 -> (...) */
  Union2 is_triplet$0;
  static const is_triplet$0_Closure _is_triplet$0$ = { ._func = _is_triplet$0 };
  is_triplet$0.Type4 = (Closure*)&_is_triplet$0$;
  
  /* let desired_sum$0 = input */
  Union3 desired_sum$0;
  __input(&desired_sum$0.Type1);
  
  /* let a_loop$0 = fun a$1 -> (...) */
  Union2 a_loop$0;
  a_loop$0.Type4 = HEAP_VALUE(a_loop$0_Closure, {
    ._func = _a_loop$0,
    .desired_sum$0 = desired_sum$0,
    .is_triplet$0 = is_triplet$0,
  });
  
  /* let $29 = 1 */
  Union3 $29;
  $29.Type1 = 1;
  
  /* let $0 = a_loop$0 $29 */
  CALL(a_loop$0.Type4, &(*$0), $29);
}


void _$2(const $2_Closure *_clo, Union4 *restrict $3, Union3 c$0) {
  tail_call:;
  /* let $4 = a$0 * a$0 */
  Union3 $4;
  $4.Type1 = _clo->a$0.Type1 * _clo->a$0.Type1;
  
  /* let $5 = b$0 * b$0 */
  Union3 $5;
  $5.Type1 = _clo->b$0.Type1 * _clo->b$0.Type1;
  
  /* let $6 = $4 + $5 */
  Union3 $6;
  $6.Type1 = $4.Type1 + $5.Type1;
  
  /* let $7 = c$0 * c$0 */
  Union3 $7;
  $7.Type1 = c$0.Type1 * c$0.Type1;
  
  /* let $3 = $6 == $7 */
  if ($6.Type1 == $7.Type1) {
    (*$3).tag = Union4_Type2;
  }
  else {
    (*$3).tag = Union4_Type3;
  }
}


void _$1(const $1_Closure *_clo, Union2 *restrict $2, Union3 b$0) {
  tail_call:;
  /* let $2 = fun c$0 -> (...) */
  (*$2).Type4 = HEAP_VALUE($2_Closure, {
    ._func = _$2,
    .a$0 = _clo->a$0,
    .b$0 = b$0,
  });
}


void _is_triplet$0(const is_triplet$0_Closure *_clo, Union2 *restrict $1, Union3 a$0) {
  tail_call:;
  /* let $1 = fun b$0 -> (...) */
  (*$1).Type4 = HEAP_VALUE($1_Closure, {
    ._func = _$1,
    .a$0 = a$0,
  });
}


void _b_loop$0(const b_loop$0_Closure *_clo, Union1 *restrict $9, Union3 b$1) {
  tail_call:;
  /* let $10 = a$1 + b$1 */
  Union3 $10;
  $10.Type1 = _clo->a$1.Type1 + b$1.Type1;
  
  /* let c$1 = desired_sum$0 - $10 */
  Union3 c$1;
  c$1.Type1 = _clo->desired_sum$0.Type1 - $10.Type1;
  
  /* let $11 = 0 */
  Union3 $11;
  $11.Type1 = 0;
  
  /* let $12 = c$1 == $11 */
  Union4 $12;
  if (c$1.Type1 == $11.Type1) {
    $12.tag = Union4_Type2;
  }
  else {
    $12.tag = Union4_Type3;
  }
  
  /* let $9 = match $12 with ... */
  switch ($12.tag) {
    case Union4_Type3:
    {
      /* let $15 = is_triplet$0 a$1 */
      Union2 $15;
      CALL(_clo->is_triplet$0.Type4, &$15, _clo->a$1);
      
      /* let $16 = $15 b$1 */
      Union2 $16;
      CALL($15.Type4, &$16, b$1);
      
      /* let $17 = $16 c$1 */
      Union4 $17;
      CALL($16.Type4, &$17, c$1);
      
      /* let $14 = match $17 with ... */
      switch ($17.tag) {
        case Union4_Type3:
        {
          /* let $21 = 1 */
          Union3 $21;
          $21.Type1 = 1;
          
          /* let $22 = b$1 + $21 */
          Union3 $22;
          $22.Type1 = b$1.Type1 + $21.Type1;
          
          /* let $20 = b_loop$0 $22 */
          b$1 = $22;
          goto tail_call;
          break;
        }
        case Union4_Type2:
        {
          /* let $19 = a$1 * b$1 */
          Union3 $19;
          $19.Type1 = _clo->a$1.Type1 * b$1.Type1;
          
          /* let $18 = $19 * c$1 */
          (*$9).tag = Union1_Type1;
          (*$9).Type1 = $19.Type1 * c$1.Type1;
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    case Union4_Type2:
    {
      /* let $13 = false */
      (*$9).tag = Union1_Type3;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _a_loop$0(const a_loop$0_Closure *_clo, Union1 *restrict $8, Union3 a$1) {
  tail_call:;
  /* let b_loop$0 = fun b$1 -> (...) */
  Union2 b_loop$0;
  b_loop$0.Type4 = HEAP_VALUE(b_loop$0_Closure, {
    ._func = _b_loop$0,
    .a$1 = a$1,
    .desired_sum$0 = _clo->desired_sum$0,
    .is_triplet$0 = _clo->is_triplet$0,
  });
  
  /* let $23 = 1 */
  Union3 $23;
  $23.Type1 = 1;
  
  /* let $24 = a$1 + $23 */
  Union3 $24;
  $24.Type1 = a$1.Type1 + $23.Type1;
  
  /* let r$0 = b_loop$0 $24 */
  Union1 r$0;
  CALL(b_loop$0.Type4, &r$0, $24);
  
  /* let $8 = match r$0 with ... */
  switch (r$0.tag) {
    case Union1_Type3:
    {
      /* let $27 = 1 */
      Union3 $27;
      $27.Type1 = 1;
      
      /* let $28 = a$1 + $27 */
      Union3 $28;
      $28.Type1 = a$1.Type1 + $27.Type1;
      
      /* let $26 = a_loop$0 $28 */
      a$1 = $28;
      goto tail_call;
      break;
    }
    case Union1_Type1:
    {
      /* let $25 = r$0 */
      (*(&(*$8))) = r$0;
      break;
    }
    default:
      UNREACHABLE;
  }
}


int main(void) {
  time_t t;
  srand((unsigned) time(&t));
  Union1 result;
  ___main(NULL, &result);
  fprint_Union1(stdout, &result);
}
