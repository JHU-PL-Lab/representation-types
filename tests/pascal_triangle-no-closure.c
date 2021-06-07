
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

typedef struct /* $15 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type5;

typedef struct /* $19 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type6;

typedef struct /* $21 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type7;

typedef Empty Union0;

typedef struct { Type1 Type1; }  Union1;
typedef struct {
  enum {
    Union2_Type5,
    Union2_Type6,
    Union2_Type7,
  } tag;
  union {
    Type5 Type5;
    Type6 Type6;
    Type7 Type7;
  };
}  *Union2;

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

typedef struct { Type4 Type4; }  Union4;
typedef struct {
  Func *_func;
} row_col$0_Closure;

typedef struct {
  Func *_func;
} getNumber$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

Func _row_col$0;
Func _getNumber$0;
Func ___main;

static inline void fprint_Type0(FILE *, const Type0*);
static inline void fprint_Type1(FILE *, const Type1*);
static inline void fprint_Type2(FILE *, const Type2*);
static inline void fprint_Type3(FILE *, const Type3*);
static inline void fprint_Type4(FILE *, const Type4*);
static inline void fprint_Type5(FILE *, const Type5*);
static inline void fprint_Type6(FILE *, const Type6*);
static inline void fprint_Type7(FILE *, const Type7*);
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
void fprint_Type5(FILE *stream, const Type5* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
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
  }
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
void fprint_Union4(FILE *stream, const Union4* value) {
  fprint_Type4(stream, &value->Type4);
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  tail_call:;
  /* let getNumber$0 = fun row_col$0 -> (...) */
  Union4 getNumber$0;
  static const getNumber$0_Closure _getNumber$0$ = { ._func = _getNumber$0 };
  getNumber$0.Type4 = (Closure*)&_getNumber$0$;
  
  /* let row$1 = input */
  Union1 row$1;
  __input(&row$1.Type1);
  
  /* let col$1 = input */
  Union1 col$1;
  __input(&col$1.Type1);
  
  /* let $21 = {_1 = col$1; _0 = row$1} */
  Union2 $21;
  $21 = HEAP_ALLOC(sizeof(*$21));
  $21->tag = Union2_Type7;
  COPY(&$21->Type7._1, &col$1, sizeof(Union1));
  COPY(&$21->Type7._0, &row$1, sizeof(Union1));
  
  /* let $0 = getNumber$0 $21 */
  CALL(getNumber$0.Type4, &(*$0), $21);
}


void _getNumber$0(const getNumber$0_Closure *_clo, Union1 *restrict $1, Union2 row_col$0) {
  tail_call:;
  /* let row$0 = row_col$0._0 */
  Union1 row$0;
  switch (row_col$0->tag) {
    case Union2_Type5:
      COPY(&row$0, &row_col$0->Type5._0, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&row$0, &row_col$0->Type6._0, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&row$0, &row_col$0->Type7._0, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let col$0 = row_col$0._1 */
  Union1 col$0;
  switch (row_col$0->tag) {
    case Union2_Type5:
      COPY(&col$0, &row_col$0->Type5._1, sizeof(Union1));
      break;
    case Union2_Type6:
      COPY(&col$0, &row_col$0->Type6._1, sizeof(Union1));
      break;
    case Union2_Type7:
      COPY(&col$0, &row_col$0->Type7._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $2 = 0 */
  Union1 $2;
  $2.Type1 = 0;
  
  /* let $3 = col$0 == $2 */
  Union3 $3;
  if (col$0.Type1 == $2.Type1) {
    $3.tag = Union3_Type2;
  }
  else {
    $3.tag = Union3_Type3;
  }
  
  /* let $4 = 0 */
  Union1 $4;
  $4.Type1 = 0;
  
  /* let $5 = row$0 == $4 */
  Union3 $5;
  if (row$0.Type1 == $4.Type1) {
    $5.tag = Union3_Type2;
  }
  else {
    $5.tag = Union3_Type3;
  }
  
  /* let $6 = $3 or $5 */
  Union3 $6;
  if (($3.tag == Union3_Type2) || ($5.tag == Union3_Type2)) {
    $6.tag = Union3_Type2;
  }
  else {
    $6.tag = Union3_Type3;
  }
  
  /* let $7 = col$0 == row$0 */
  Union3 $7;
  if (col$0.Type1 == row$0.Type1) {
    $7.tag = Union3_Type2;
  }
  else {
    $7.tag = Union3_Type3;
  }
  
  /* let $8 = $6 or $7 */
  Union3 $8;
  if (($6.tag == Union3_Type2) || ($7.tag == Union3_Type2)) {
    $8.tag = Union3_Type2;
  }
  else {
    $8.tag = Union3_Type3;
  }
  
  /* let $1 = match $8 with ... */
  switch ($8.tag) {
    case Union3_Type3:
    {
      /* let $11 = 1 */
      Union1 $11;
      $11.Type1 = 1;
      
      /* let $12 = row$0 - $11 */
      Union1 $12;
      $12.Type1 = row$0.Type1 - $11.Type1;
      
      /* let $13 = 1 */
      Union1 $13;
      $13.Type1 = 1;
      
      /* let $14 = col$0 - $13 */
      Union1 $14;
      $14.Type1 = col$0.Type1 - $13.Type1;
      
      /* let $15 = {_1 = $14; _0 = $12} */
      Union2 $15;
      $15 = HEAP_ALLOC(sizeof(*$15));
      $15->tag = Union2_Type5;
      COPY(&$15->Type5._1, &$14, sizeof(Union1));
      COPY(&$15->Type5._0, &$12, sizeof(Union1));
      
      /* let $16 = getNumber$0 $15 */
      Union1 $16;
      _getNumber$0(_clo, &$16, $15);
      
      /* let $17 = 1 */
      Union1 $17;
      $17.Type1 = 1;
      
      /* let $18 = row$0 - $17 */
      Union1 $18;
      $18.Type1 = row$0.Type1 - $17.Type1;
      
      /* let $19 = {_1 = col$0; _0 = $18} */
      Union2 $19;
      $19 = HEAP_ALLOC(sizeof(*$19));
      $19->tag = Union2_Type6;
      COPY(&$19->Type6._1, &col$0, sizeof(Union1));
      COPY(&$19->Type6._0, &$18, sizeof(Union1));
      
      /* let $20 = getNumber$0 $19 */
      Union1 $20;
      _getNumber$0(_clo, &$20, $19);
      
      /* let $10 = $16 + $20 */
      (*$1).Type1 = $16.Type1 + $20.Type1;
      break;
    }
    case Union3_Type2:
    {
      /* let $9 = 1 */
      (*$1).Type1 = 1;
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
