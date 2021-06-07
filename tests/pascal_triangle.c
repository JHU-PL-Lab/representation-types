
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

typedef struct { Type1 Type1; }  Union1;
typedef struct { Type4 Type4; }  Union2;
typedef struct {
  enum {
    Union3_Type2,
    Union3_Type3,
  } tag;
  union {
    Type2 Type2;
    Type3 Type3;
  };
}  Union3;

typedef struct {
  Func *_func;
} row$0_Closure;

typedef struct {
  Func *_func;
} getNumber$0_Closure;

typedef struct {
  Func *_func;
  Union2 getNumber$0;
  Union1 row$0;
} col$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union2 getNumber$0;
  Union1 row$0;
} $1_Closure;

Func _row$0;
Func _getNumber$0;
Func _col$0;
Func ___main;
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
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union2(FILE *stream, const Union2* value) {
  fprint_Type4(stream, &value->Type4);
}
void fprint_Union3(FILE *stream, const Union3* value) {
  switch (value->tag) {
    case Union3_Type2:
      fprint_Type2(stream, &value->Type2);
      break;
    case Union3_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  tail_call:;
  /* let getNumber$0 = fun row$0 -> (...) */
  Union2 getNumber$0;
  static const getNumber$0_Closure _getNumber$0$ = { ._func = _getNumber$0 };
  getNumber$0.Type4 = (Closure*)&_getNumber$0$;
  
  /* let row$1 = input */
  Union1 row$1;
  __input(&row$1.Type1);
  
  /* let col$1 = input */
  Union1 col$1;
  __input(&col$1.Type1);
  
  /* let $22 = getNumber$0 row$1 */
  Union2 $22;
  CALL(getNumber$0.Type4, &$22, row$1);
  
  /* let $0 = $22 col$1 */
  CALL($22.Type4, &(*$0), col$1);
}


void _$1(const $1_Closure *_clo, Union1 *restrict $2, Union1 col$0) {
  tail_call:;
  /* let $3 = 0 */
  Union1 $3;
  $3.Type1 = 0;
  
  /* let $4 = col$0 == $3 */
  Union3 $4;
  if (col$0.Type1 == $3.Type1) {
    $4.tag = Union3_Type2;
  }
  else {
    $4.tag = Union3_Type3;
  }
  
  /* let $5 = 0 */
  Union1 $5;
  $5.Type1 = 0;
  
  /* let $6 = row$0 == $5 */
  Union3 $6;
  if (_clo->row$0.Type1 == $5.Type1) {
    $6.tag = Union3_Type2;
  }
  else {
    $6.tag = Union3_Type3;
  }
  
  /* let $7 = $4 or $6 */
  Union3 $7;
  if (($4.tag == Union3_Type2) || ($6.tag == Union3_Type2)) {
    $7.tag = Union3_Type2;
  }
  else {
    $7.tag = Union3_Type3;
  }
  
  /* let $8 = col$0 == row$0 */
  Union3 $8;
  if (col$0.Type1 == _clo->row$0.Type1) {
    $8.tag = Union3_Type2;
  }
  else {
    $8.tag = Union3_Type3;
  }
  
  /* let $9 = $7 or $8 */
  Union3 $9;
  if (($7.tag == Union3_Type2) || ($8.tag == Union3_Type2)) {
    $9.tag = Union3_Type2;
  }
  else {
    $9.tag = Union3_Type3;
  }
  
  /* let $2 = match $9 with ... */
  switch ($9.tag) {
    case Union3_Type3:
    {
      /* let $12 = 1 */
      Union1 $12;
      $12.Type1 = 1;
      
      /* let $13 = row$0 - $12 */
      Union1 $13;
      $13.Type1 = _clo->row$0.Type1 - $12.Type1;
      
      /* let $14 = getNumber$0 $13 */
      Union2 $14;
      CALL(_clo->getNumber$0.Type4, &$14, $13);
      
      /* let $15 = 1 */
      Union1 $15;
      $15.Type1 = 1;
      
      /* let $16 = col$0 - $15 */
      Union1 $16;
      $16.Type1 = col$0.Type1 - $15.Type1;
      
      /* let $17 = $14 $16 */
      Union1 $17;
      CALL($14.Type4, &$17, $16);
      
      /* let $18 = 1 */
      Union1 $18;
      $18.Type1 = 1;
      
      /* let $19 = row$0 - $18 */
      Union1 $19;
      $19.Type1 = _clo->row$0.Type1 - $18.Type1;
      
      /* let $20 = getNumber$0 $19 */
      Union2 $20;
      CALL(_clo->getNumber$0.Type4, &$20, $19);
      
      /* let $21 = $20 col$0 */
      Union1 $21;
      CALL($20.Type4, &$21, col$0);
      
      /* let $11 = $17 + $21 */
      (*$2).Type1 = $17.Type1 + $21.Type1;
      break;
    }
    case Union3_Type2:
    {
      /* let $10 = 1 */
      (*$2).Type1 = 1;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _getNumber$0(const getNumber$0_Closure *_clo, Union2 *restrict $1, Union1 row$0) {
  tail_call:;
  /* let $1 = fun col$0 -> (...) */
  (*$1).Type4 = HEAP_VALUE($1_Closure, {
    ._func = _$1,
    .getNumber$0 = UNTAGGED(Union2, Type4, (const Closure*)_clo),
    .row$0 = row$0,
  });
}


int main(void) {
  time_t t;
  srand((unsigned) time(&t));
  Union1 result;
  ___main(NULL, &result);
  fprint_Union1(stdout, &result);
}
