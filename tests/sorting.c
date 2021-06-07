
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

typedef struct /* $11 */ {
  Empty Cons; /* Union3 */
  Univ  hd; /* Union4 */
  Univ  tl; /* Union1 */
} Type5;

typedef struct /* $17 */ {
  Empty Cons; /* Union6 */
  Univ  hd; /* Union4 */
  Univ  tl; /* Union1 */
} Type6;

typedef struct /* $21 */ {
  Empty Cons; /* Union7 */
  Univ  hd; /* Union4 */
  Univ  tl; /* Union1 */
} Type7;

typedef struct /* $38 */ {
  Empty Cons; /* Union9 */
  Univ  hd; /* Union4 */
  Univ  tl; /* Union1 */
} Type8;

typedef struct /* $45 */ {
  Empty Cons; /* Union10 */
  Univ  hd; /* Union4 */
  Univ  tl; /* Union1 */
} Type9;

typedef struct /* $48 */ {
  Empty Nil; /* Union11 */
} Type10;

typedef struct /* $9 */ {
} Type11;

typedef struct /* $13 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type12;

typedef struct /* $3 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type13;

typedef struct /* $8 */ {
  Univ  _0; /* Union1 */
  Univ  _1; /* Union1 */
} Type14;

typedef struct /* $15 */ {
} Type15;

typedef struct /* $22 */ {
} Type16;

typedef struct /* $37 */ {
} Type17;

typedef struct /* $44 */ {
} Type18;

typedef struct /* $47 */ {
} Type19;

typedef Empty Union0;

typedef struct {
  enum {
    Union1_Type5,
    Union1_Type6,
    Union1_Type7,
    Union1_Type8,
    Union1_Type9,
    Union1_Type10,
  } tag;
  union {
    Type5 Type5;
    Type6 Type6;
    Type7 Type7;
    Type8 Type8;
    Type9 Type9;
    Type10 Type10;
  };
}  *Union1;

typedef struct { Type4 Type4; }  Union2;
typedef struct { Type11 Type11; }  Union3;
typedef struct { Type1 Type1; }  Union4;
typedef struct {
  enum {
    Union5_Type12,
    Union5_Type13,
    Union5_Type14,
  } tag;
  union {
    Type12 Type12;
    Type13 Type13;
    Type14 Type14;
  };
}  *Union5;

typedef struct { Type15 Type15; }  Union6;
typedef struct { Type16 Type16; }  Union7;
typedef struct {
  enum {
    Union8_Type2,
    Union8_Type3,
  } tag;
  union {
    Type2 Type2;
    Type3 Type3;
  };
}  Union8;

typedef struct { Type17 Type17; }  Union9;
typedef struct { Type18 Type18; }  Union10;
typedef struct { Type19 Type19; }  Union11;
typedef struct {
  Func *_func;
  Union2 concat$0;
  Union2 partition$0;
} sort$0_Closure;

typedef struct {
  Func *_func;
} read_input$0_Closure;

typedef struct {
  Func *_func;
} partition$0_Closure;

typedef struct {
  Func *_func;
} p$0_Closure;

typedef struct {
  Func *_func;
  Union2 concat$0;
  Union1 l1$0;
} l2$0_Closure;

typedef struct {
  Func *_func;
} l1$0_Closure;

typedef struct {
  Func *_func;
} l$2_Closure;

typedef struct {
  Func *_func;
  Union2 concat$0;
  Union2 partition$0;
} l$1_Closure;

typedef struct {
  Func *_func;
  Union2 p$0;
  Union2 partition$0;
} l$0_Closure;

typedef struct {
  Func *_func;
  Union4 hd$1;
} elem$0_Closure;

typedef struct {
  Func *_func;
} concat$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union4 hd$1;
} $31_Closure;

typedef struct {
  Func *_func;
  Union2 concat$0;
  Union1 l1$0;
} $18_Closure;

typedef struct {
  Func *_func;
  Union2 p$0;
  Union2 partition$0;
} $1_Closure;

Func _sort$0;
Func _read_input$0;
Func _partition$0;
Func _p$0;
Func _l2$0;
Func _l1$0;
Func _l$2;
Func _l$1;
Func _l$0;
Func _elem$0;
Func _concat$0;
Func ___main;
Func _$31;
Func _$18;
Func _$1;

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
static inline void fprint_Union9(FILE *, const Union9*);
static inline void fprint_Union10(FILE *, const Union10*);
static inline void fprint_Union11(FILE *, const Union11*);

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
  fprintf(stream, "{Cons = ");
  fprint_Union3(stream, (Union3*)&value->Cons);
  fprintf(stream, "; hd = ");
  fprint_Union4(stream, (Union4*)&value->hd);
  fprintf(stream, "; tl = ");
  fprint_Union1(stream, (Union1*)&value->tl);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{Cons = ");
  fprint_Union6(stream, (Union6*)&value->Cons);
  fprintf(stream, "; hd = ");
  fprint_Union4(stream, (Union4*)&value->hd);
  fprintf(stream, "; tl = ");
  fprint_Union1(stream, (Union1*)&value->tl);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{Cons = ");
  fprint_Union7(stream, (Union7*)&value->Cons);
  fprintf(stream, "; hd = ");
  fprint_Union4(stream, (Union4*)&value->hd);
  fprintf(stream, "; tl = ");
  fprint_Union1(stream, (Union1*)&value->tl);
  fprintf(stream, "}");
}
void fprint_Type8(FILE *stream, const Type8* value) {
  fprintf(stream, "{Cons = ");
  fprint_Union9(stream, (Union9*)&value->Cons);
  fprintf(stream, "; hd = ");
  fprint_Union4(stream, (Union4*)&value->hd);
  fprintf(stream, "; tl = ");
  fprint_Union1(stream, (Union1*)&value->tl);
  fprintf(stream, "}");
}
void fprint_Type9(FILE *stream, const Type9* value) {
  fprintf(stream, "{Cons = ");
  fprint_Union10(stream, (Union10*)&value->Cons);
  fprintf(stream, "; hd = ");
  fprint_Union4(stream, (Union4*)&value->hd);
  fprintf(stream, "; tl = ");
  fprint_Union1(stream, (Union1*)&value->tl);
  fprintf(stream, "}");
}
void fprint_Type10(FILE *stream, const Type10* value) {
  fprintf(stream, "{Nil = ");
  fprint_Union11(stream, (Union11*)&value->Nil);
  fprintf(stream, "}");
}
void fprint_Type11(FILE *stream, const Type11* value) {
  fprintf(stream, "{}");
}
void fprint_Type12(FILE *stream, const Type12* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
}
void fprint_Type13(FILE *stream, const Type13* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
}
void fprint_Type14(FILE *stream, const Type14* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union1(stream, (Union1*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "}");
}
void fprint_Type15(FILE *stream, const Type15* value) {
  fprintf(stream, "{}");
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
  switch ((*value)->tag) {
    case Union1_Type5:
      fprint_Type5(stream, &(*value)->Type5);
      break;
    case Union1_Type6:
      fprint_Type6(stream, &(*value)->Type6);
      break;
    case Union1_Type7:
      fprint_Type7(stream, &(*value)->Type7);
      break;
    case Union1_Type8:
      fprint_Type8(stream, &(*value)->Type8);
      break;
    case Union1_Type9:
      fprint_Type9(stream, &(*value)->Type9);
      break;
    case Union1_Type10:
      fprint_Type10(stream, &(*value)->Type10);
      break;
  }
}
void fprint_Union2(FILE *stream, const Union2* value) {
  fprint_Type4(stream, &value->Type4);
}
void fprint_Union3(FILE *stream, const Union3* value) {
  fprint_Type11(stream, &value->Type11);
}
void fprint_Union4(FILE *stream, const Union4* value) {
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union5(FILE *stream, const Union5* value) {
  switch ((*value)->tag) {
    case Union5_Type12:
      fprint_Type12(stream, &(*value)->Type12);
      break;
    case Union5_Type13:
      fprint_Type13(stream, &(*value)->Type13);
      break;
    case Union5_Type14:
      fprint_Type14(stream, &(*value)->Type14);
      break;
  }
}
void fprint_Union6(FILE *stream, const Union6* value) {
  fprint_Type15(stream, &value->Type15);
}
void fprint_Union7(FILE *stream, const Union7* value) {
  fprint_Type16(stream, &value->Type16);
}
void fprint_Union8(FILE *stream, const Union8* value) {
  switch (value->tag) {
    case Union8_Type2:
      fprint_Type2(stream, &value->Type2);
      break;
    case Union8_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}
void fprint_Union9(FILE *stream, const Union9* value) {
  fprint_Type17(stream, &value->Type17);
}
void fprint_Union10(FILE *stream, const Union10* value) {
  fprint_Type18(stream, &value->Type18);
}
void fprint_Union11(FILE *stream, const Union11* value) {
  fprint_Type19(stream, &value->Type19);
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  tail_call:;
  /* let partition$0 = fun p$0 -> (...) */
  Union2 partition$0;
  static const partition$0_Closure _partition$0$ = { ._func = _partition$0 };
  partition$0.Type4 = (Closure*)&_partition$0$;
  
  /* let concat$0 = fun l1$0 -> (...) */
  Union2 concat$0;
  static const concat$0_Closure _concat$0$ = { ._func = _concat$0 };
  concat$0.Type4 = (Closure*)&_concat$0$;
  
  /* let sort$0 = fun l$1 -> (...) */
  Union2 sort$0;
  sort$0.Type4 = HEAP_VALUE(sort$0_Closure, {
    ._func = _sort$0,
    .concat$0 = concat$0,
    .partition$0 = partition$0,
  });
  
  /* let read_input$0 = fun l$2 -> (...) */
  Union2 read_input$0;
  static const read_input$0_Closure _read_input$0$ = { ._func = _read_input$0 };
  read_input$0.Type4 = (Closure*)&_read_input$0$;
  
  /* let $47 = {} */
  Union11 $47;
  
  /* let $48 = {Nil = $47} */
  Union1 $48;
  $48 = HEAP_ALLOC(sizeof(*$48));
  $48->tag = Union1_Type10;
  
  /* let $49 = read_input$0 $48 */
  Union1 $49;
  CALL(read_input$0.Type4, &$49, $48);
  
  /* let $0 = sort$0 $49 */
  CALL(sort$0.Type4, &(*$0), $49);
}


void _$1(const $1_Closure *_clo, Union5 *restrict $2, Union1 l$0) {
  tail_call:;
  /* let $2 = match l$0 with ... */
  switch (l$0->tag) {
    case Union1_Type9:
    case Union1_Type8:
    case Union1_Type7:
    case Union1_Type6:
    case Union1_Type5:
    {
      /* let $5 = partition$0 p$0 */
      Union2 $5;
      CALL(_clo->partition$0.Type4, &$5, _clo->p$0);
      
      /* let $6 = l$0.tl */
      Union1 $6;
      switch (l$0->tag) {
        case Union1_Type5:
          COPY(&$6, &l$0->Type5.tl, sizeof(Union1));
          break;
        case Union1_Type6:
          COPY(&$6, &l$0->Type6.tl, sizeof(Union1));
          break;
        case Union1_Type7:
          COPY(&$6, &l$0->Type7.tl, sizeof(Union1));
          break;
        case Union1_Type8:
          COPY(&$6, &l$0->Type8.tl, sizeof(Union1));
          break;
        case Union1_Type9:
          COPY(&$6, &l$0->Type9.tl, sizeof(Union1));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let parts$0 = $5 $6 */
      Union5 parts$0;
      CALL($5.Type4, &parts$0, $6);
      
      /* let hd$0 = l$0.hd */
      Union4 hd$0;
      switch (l$0->tag) {
        case Union1_Type5:
          COPY(&hd$0, &l$0->Type5.hd, sizeof(Union4));
          break;
        case Union1_Type6:
          COPY(&hd$0, &l$0->Type6.hd, sizeof(Union4));
          break;
        case Union1_Type7:
          COPY(&hd$0, &l$0->Type7.hd, sizeof(Union4));
          break;
        case Union1_Type8:
          COPY(&hd$0, &l$0->Type8.hd, sizeof(Union4));
          break;
        case Union1_Type9:
          COPY(&hd$0, &l$0->Type9.hd, sizeof(Union4));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $7 = p$0 hd$0 */
      Union8 $7;
      CALL(_clo->p$0.Type4, &$7, hd$0);
      
      /* let $4 = match $7 with ... */
      switch ($7.tag) {
        case Union8_Type3:
        {
          /* let $14 = parts$0._0 */
          Union1 $14;
          switch (parts$0->tag) {
            case Union5_Type12:
              COPY(&$14, &parts$0->Type12._0, sizeof(Union1));
              break;
            case Union5_Type13:
              COPY(&$14, &parts$0->Type13._0, sizeof(Union1));
              break;
            case Union5_Type14:
              COPY(&$14, &parts$0->Type14._0, sizeof(Union1));
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $15 = {} */
          Union6 $15;
          
          /* let $16 = parts$0._1 */
          Union1 $16;
          switch (parts$0->tag) {
            case Union5_Type12:
              COPY(&$16, &parts$0->Type12._1, sizeof(Union1));
              break;
            case Union5_Type13:
              COPY(&$16, &parts$0->Type13._1, sizeof(Union1));
              break;
            case Union5_Type14:
              COPY(&$16, &parts$0->Type14._1, sizeof(Union1));
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $17 = {Cons = $15; hd = hd$0; tl = $16} */
          Union1 $17;
          $17 = HEAP_ALLOC(sizeof(*$17));
          $17->tag = Union1_Type6;
          COPY(&$17->Type6.hd, &hd$0, sizeof(Union4));
          COPY(&$17->Type6.tl, &$16, sizeof(Union1));
          
          /* let $13 = {_1 = $17; _0 = $14} */
          (*$2) = HEAP_ALLOC(sizeof(*(*$2)));
          (*$2)->tag = Union5_Type12;
          COPY(&(*$2)->Type12._1, &$17, sizeof(Union1));
          COPY(&(*$2)->Type12._0, &$14, sizeof(Union1));
          break;
        }
        case Union8_Type2:
        {
          /* let $9 = {} */
          Union3 $9;
          
          /* let $10 = parts$0._0 */
          Union1 $10;
          switch (parts$0->tag) {
            case Union5_Type12:
              COPY(&$10, &parts$0->Type12._0, sizeof(Union1));
              break;
            case Union5_Type13:
              COPY(&$10, &parts$0->Type13._0, sizeof(Union1));
              break;
            case Union5_Type14:
              COPY(&$10, &parts$0->Type14._0, sizeof(Union1));
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $11 = {Cons = $9; hd = hd$0; tl = $10} */
          Union1 $11;
          $11 = HEAP_ALLOC(sizeof(*$11));
          $11->tag = Union1_Type5;
          COPY(&$11->Type5.hd, &hd$0, sizeof(Union4));
          COPY(&$11->Type5.tl, &$10, sizeof(Union1));
          
          /* let $12 = parts$0._1 */
          Union1 $12;
          switch (parts$0->tag) {
            case Union5_Type12:
              COPY(&$12, &parts$0->Type12._1, sizeof(Union1));
              break;
            case Union5_Type13:
              COPY(&$12, &parts$0->Type13._1, sizeof(Union1));
              break;
            case Union5_Type14:
              COPY(&$12, &parts$0->Type14._1, sizeof(Union1));
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $8 = {_1 = $12; _0 = $11} */
          (*$2) = HEAP_ALLOC(sizeof(*(*$2)));
          (*$2)->tag = Union5_Type14;
          COPY(&(*$2)->Type14._1, &$12, sizeof(Union1));
          COPY(&(*$2)->Type14._0, &$11, sizeof(Union1));
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    case Union1_Type10:
    {
      /* let $3 = {_1 = l$0; _0 = l$0} */
      (*$2) = HEAP_ALLOC(sizeof(*(*$2)));
      (*$2)->tag = Union5_Type13;
      COPY(&(*$2)->Type13._1, &l$0, sizeof(Union1));
      COPY(&(*$2)->Type13._0, &l$0, sizeof(Union1));
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _partition$0(const partition$0_Closure *_clo, Union2 *restrict $1, Union2 p$0) {
  tail_call:;
  /* let $1 = fun l$0 -> (...) */
  (*$1).Type4 = HEAP_VALUE($1_Closure, {
    ._func = _$1,
    .p$0 = p$0,
    .partition$0 = UNTAGGED(Union2, Type4, (const Closure*)_clo),
  });
}


void _$18(const $18_Closure *_clo, Union1 *restrict $19, Union1 l2$0) {
  tail_call:;
  /* let $19 = match l1$0 with ... */
  switch (_clo->l1$0->tag) {
    case Union1_Type9:
    case Union1_Type8:
    case Union1_Type7:
    case Union1_Type6:
    case Union1_Type5:
    {
      /* let $22 = {} */
      Union7 $22;
      
      /* let $23 = l1$0.hd */
      Union4 $23;
      switch (_clo->l1$0->tag) {
        case Union1_Type5:
          COPY(&$23, &_clo->l1$0->Type5.hd, sizeof(Union4));
          break;
        case Union1_Type6:
          COPY(&$23, &_clo->l1$0->Type6.hd, sizeof(Union4));
          break;
        case Union1_Type7:
          COPY(&$23, &_clo->l1$0->Type7.hd, sizeof(Union4));
          break;
        case Union1_Type8:
          COPY(&$23, &_clo->l1$0->Type8.hd, sizeof(Union4));
          break;
        case Union1_Type9:
          COPY(&$23, &_clo->l1$0->Type9.hd, sizeof(Union4));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $24 = l1$0.tl */
      Union1 $24;
      switch (_clo->l1$0->tag) {
        case Union1_Type5:
          COPY(&$24, &_clo->l1$0->Type5.tl, sizeof(Union1));
          break;
        case Union1_Type6:
          COPY(&$24, &_clo->l1$0->Type6.tl, sizeof(Union1));
          break;
        case Union1_Type7:
          COPY(&$24, &_clo->l1$0->Type7.tl, sizeof(Union1));
          break;
        case Union1_Type8:
          COPY(&$24, &_clo->l1$0->Type8.tl, sizeof(Union1));
          break;
        case Union1_Type9:
          COPY(&$24, &_clo->l1$0->Type9.tl, sizeof(Union1));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $25 = concat$0 $24 */
      Union2 $25;
      CALL(_clo->concat$0.Type4, &$25, $24);
      
      /* let $26 = $25 l2$0 */
      Union1 $26;
      CALL($25.Type4, &$26, l2$0);
      
      /* let $21 = {Cons = $22; hd = $23; tl = $26} */
      (*$19) = HEAP_ALLOC(sizeof(*(*$19)));
      (*$19)->tag = Union1_Type7;
      COPY(&(*$19)->Type7.hd, &$23, sizeof(Union4));
      COPY(&(*$19)->Type7.tl, &$26, sizeof(Union1));
      break;
    }
    case Union1_Type10:
    {
      /* let $20 = l2$0 */
      (*(&(*$19))) = l2$0;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _concat$0(const concat$0_Closure *_clo, Union2 *restrict $18, Union1 l1$0) {
  tail_call:;
  /* let $18 = fun l2$0 -> (...) */
  (*$18).Type4 = HEAP_VALUE($18_Closure, {
    ._func = _$18,
    .concat$0 = UNTAGGED(Union2, Type4, (const Closure*)_clo),
    .l1$0 = l1$0,
  });
}


void _$31(const $31_Closure *_clo, Union8 *restrict $30, Union4 elem$0) {
  tail_call:;
  /* let $30 = elem$0 < hd$1 */
  if (elem$0.Type1 < _clo->hd$1.Type1) {
    (*$30).tag = Union8_Type2;
  }
  else {
    (*$30).tag = Union8_Type3;
  }
}


void _sort$0(const sort$0_Closure *_clo, Union1 *restrict $27, Union1 l$1) {
  tail_call:;
  /* let $27 = match l$1 with ... */
  switch (l$1->tag) {
    case Union1_Type9:
    case Union1_Type8:
    case Union1_Type7:
    case Union1_Type6:
    case Union1_Type5:
    {
      /* let hd$1 = l$1.hd */
      Union4 hd$1;
      switch (l$1->tag) {
        case Union1_Type5:
          COPY(&hd$1, &l$1->Type5.hd, sizeof(Union4));
          break;
        case Union1_Type6:
          COPY(&hd$1, &l$1->Type6.hd, sizeof(Union4));
          break;
        case Union1_Type7:
          COPY(&hd$1, &l$1->Type7.hd, sizeof(Union4));
          break;
        case Union1_Type8:
          COPY(&hd$1, &l$1->Type8.hd, sizeof(Union4));
          break;
        case Union1_Type9:
          COPY(&hd$1, &l$1->Type9.hd, sizeof(Union4));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $31 = fun elem$0 -> (...) */
      Union2 $31;
      $31.Type4 = HEAP_VALUE($31_Closure, {
        ._func = _$31,
        .hd$1 = hd$1,
      });
      
      /* let $32 = partition$0 $31 */
      Union2 $32;
      CALL(_clo->partition$0.Type4, &$32, $31);
      
      /* let $33 = l$1.tl */
      Union1 $33;
      switch (l$1->tag) {
        case Union1_Type5:
          COPY(&$33, &l$1->Type5.tl, sizeof(Union1));
          break;
        case Union1_Type6:
          COPY(&$33, &l$1->Type6.tl, sizeof(Union1));
          break;
        case Union1_Type7:
          COPY(&$33, &l$1->Type7.tl, sizeof(Union1));
          break;
        case Union1_Type8:
          COPY(&$33, &l$1->Type8.tl, sizeof(Union1));
          break;
        case Union1_Type9:
          COPY(&$33, &l$1->Type9.tl, sizeof(Union1));
          break;
        case Union1_Type10:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let parts$1 = $32 $33 */
      Union5 parts$1;
      CALL($32.Type4, &parts$1, $33);
      
      /* let $34 = parts$1._0 */
      Union1 $34;
      switch (parts$1->tag) {
        case Union5_Type12:
          COPY(&$34, &parts$1->Type12._0, sizeof(Union1));
          break;
        case Union5_Type13:
          COPY(&$34, &parts$1->Type13._0, sizeof(Union1));
          break;
        case Union5_Type14:
          COPY(&$34, &parts$1->Type14._0, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let left$0 = sort$0 $34 */
      Union1 left$0;
      _sort$0(_clo, &left$0, $34);
      
      /* let $35 = parts$1._1 */
      Union1 $35;
      switch (parts$1->tag) {
        case Union5_Type12:
          COPY(&$35, &parts$1->Type12._1, sizeof(Union1));
          break;
        case Union5_Type13:
          COPY(&$35, &parts$1->Type13._1, sizeof(Union1));
          break;
        case Union5_Type14:
          COPY(&$35, &parts$1->Type14._1, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let right$0 = sort$0 $35 */
      Union1 right$0;
      _sort$0(_clo, &right$0, $35);
      
      /* let $36 = concat$0 left$0 */
      Union2 $36;
      CALL(_clo->concat$0.Type4, &$36, left$0);
      
      /* let $37 = {} */
      Union9 $37;
      
      /* let $38 = {Cons = $37; hd = hd$1; tl = right$0} */
      Union1 $38;
      $38 = HEAP_ALLOC(sizeof(*$38));
      $38->tag = Union1_Type8;
      COPY(&$38->Type8.hd, &hd$1, sizeof(Union4));
      COPY(&$38->Type8.tl, &right$0, sizeof(Union1));
      
      /* let $29 = $36 $38 */
      CALL($36.Type4, &(*$27), $38);
      break;
    }
    case Union1_Type10:
    {
      /* let $28 = l$1 */
      (*(&(*$27))) = l$1;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _read_input$0(const read_input$0_Closure *_clo, Union1 *restrict $39, Union1 l$2) {
  tail_call:;
  /* let n$0 = input */
  Union4 n$0;
  __input(&n$0.Type1);
  
  /* let $40 = 0 */
  Union4 $40;
  $40.Type1 = 0;
  
  /* let $41 = n$0 == $40 */
  Union8 $41;
  if (n$0.Type1 == $40.Type1) {
    $41.tag = Union8_Type2;
  }
  else {
    $41.tag = Union8_Type3;
  }
  
  /* let $42 = not $41 */
  Union8 $42;
  if ($41.tag == Union8_Type2) {
    $42.tag = Union8_Type3;
  }
  else {
    $42.tag = Union8_Type2;
  }
  
  /* let $39 = match $42 with ... */
  switch ($42.tag) {
    case Union8_Type3:
    {
      /* let $46 = l$2 */
      (*(&(*$39))) = l$2;
      break;
    }
    case Union8_Type2:
    {
      /* let $44 = {} */
      Union10 $44;
      
      /* let $45 = {Cons = $44; hd = n$0; tl = l$2} */
      Union1 $45;
      $45 = HEAP_ALLOC(sizeof(*$45));
      $45->tag = Union1_Type9;
      COPY(&$45->Type9.hd, &n$0, sizeof(Union4));
      COPY(&$45->Type9.tl, &l$2, sizeof(Union1));
      
      /* let $43 = read_input$0 $45 */
      l$2 = $45;
      goto tail_call;
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
