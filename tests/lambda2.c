
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

typedef struct /* $34 */ {
  Univ  Body; /* Union1 */
  Univ  Id; /* Union4 */
} Type5;

typedef struct /* $60 */ {
  Univ  Lhs; /* Union1 */
  Univ  Rhs; /* Union1 */
} Type6;

typedef struct /* $9 */ {
  Univ  Var; /* Union4 */
} Type7;

typedef struct /* $1 */ {
  Univ  print; /* Union3 */
  Univ  subst; /* Union3 */
} Type8;

typedef struct /* $12 */ {
  Univ  apply; /* Union3 */
  Univ  eval; /* Union3 */
  Univ  print; /* Union3 */
  Univ  subst; /* Union3 */
} Type9;

typedef struct /* $40 */ {
  Univ  eval; /* Union3 */
  Univ  print; /* Union3 */
  Univ  subst; /* Union3 */
} Type10;

typedef struct /* $214 */ {
} Type11;

typedef struct /* $36 */ {
} Type12;

typedef struct /* $62 */ {
} Type13;

typedef struct /* $65 */ {
} Type14;

typedef Empty Union0;

typedef struct {
  enum {
    Union1_Type5,
    Union1_Type6,
    Union1_Type7,
  } tag;
  union {
    Type5 Type5;
    Type6 Type6;
    Type7 Type7;
  };
}  *Union1;

typedef struct {
  enum {
    Union2_Type8,
    Union2_Type9,
    Union2_Type10,
  } tag;
  union {
    Type8 Type8;
    Type9 Type9;
    Type10 Type10;
  };
}  *Union2;

typedef struct { Type4 Type4; }  Union3;
typedef struct { Type1 Type1; }  Union4;
typedef struct {
  enum {
    Union5_Type2,
    Union5_Type3,
  } tag;
  union {
    Type2 Type2;
    Type3 Type3;
  };
}  Union5;

typedef struct {
  enum {
    Union6_Type11,
    Union6_Type12,
    Union6_Type13,
    Union6_Type14,
  } tag;
  union {
    Type11 Type11;
    Type12 Type12;
    Type13 Type13;
    Type14 Type14;
  };
}  Union6;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
} var$3_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
  Union2 self$2;
} var$2_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
  Union2 self$0;
} var$1_Closure;

typedef struct {
  Func *_func;
} var$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
  Union4 var$3;
} value$2_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
  Union2 self$2;
  Union4 var$2;
} value$1_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
  Union2 self$0;
  Union4 var$1;
} value$0_Closure;

typedef struct {
  Func *_func;
  Union2 lhs$0;
  Union2 rhs$0;
} self$8_Closure;

typedef struct {
  Func *_func;
  Union2 lhs$0;
  Union2 rhs$0;
} self$7_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
} self$6_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} self$5_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} self$4_Closure;

typedef struct {
  Func *_func;
} self$3_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
} self$2_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
} self$1_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
} self$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
} rhs$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union2 succ$0;
  Union3 var$0;
} n$0_Closure;

typedef struct {
  Func *_func;
} lhs$0_Closure;

typedef struct {
  Func *_func;
} lam$0_Closure;

typedef struct {
  Func *_func;
} id$1_Closure;

typedef struct {
  Func *_func;
} id$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union2 succ$0;
  Union3 var$0;
} church$0_Closure;

typedef struct {
  Func *_func;
  Union4 id$1;
  Union3 lam$0;
} body$0_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} arg$0_Closure;

typedef struct {
  Func *_func;
} apl$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
} $8_Closure;

typedef struct {
  Func *_func;
  Union2 lhs$0;
  Union2 rhs$0;
} $67_Closure;

typedef struct {
  Func *_func;
  Union2 lhs$0;
  Union2 rhs$0;
} $59_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
} $53_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
  Union4 var$3;
} $42_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
  Union2 rhs$0;
} $41_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union2 lhs$0;
} $39_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} $38_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} $33_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
  Union2 self$0;
  Union4 var$1;
} $3_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
} $27_Closure;

typedef struct {
  Func *_func;
} $26_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
} $24_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
  Union2 self$0;
} $2_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
  Union2 self$2;
  Union4 var$2;
} $14_Closure;

typedef struct {
  Func *_func;
  Union2 body$0;
  Union4 id$1;
  Union3 lam$0;
  Union2 self$2;
} $13_Closure;

typedef struct {
  Func *_func;
  Union4 id$1;
  Union3 lam$0;
} $11_Closure;

typedef struct {
  Func *_func;
  Union4 id$0;
} $10_Closure;

Func _var$3;
Func _var$2;
Func _var$1;
Func _var$0;
Func _value$2;
Func _value$1;
Func _value$0;
Func _self$8;
Func _self$7;
Func _self$6;
Func _self$5;
Func _self$4;
Func _self$3;
Func _self$2;
Func _self$1;
Func _self$0;
Func _rhs$0;
Func _n$0;
Func _lhs$0;
Func _lam$0;
Func _id$1;
Func _id$0;
Func _church$0;
Func _body$0;
Func _arg$0;
Func _apl$0;
Func ___main;
Func _$8;
Func _$67;
Func _$59;
Func _$53;
Func _$42;
Func _$41;
Func _$39;
Func _$38;
Func _$33;
Func _$3;
Func _$27;
Func _$26;
Func _$24;
Func _$2;
Func _$14;
Func _$13;
Func _$11;
Func _$10;

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
static inline void fprint_Union0(FILE *, const Union0*);
static inline void fprint_Union1(FILE *, const Union1*);
static inline void fprint_Union2(FILE *, const Union2*);
static inline void fprint_Union3(FILE *, const Union3*);
static inline void fprint_Union4(FILE *, const Union4*);
static inline void fprint_Union5(FILE *, const Union5*);
static inline void fprint_Union6(FILE *, const Union6*);

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
  fprintf(stream, "{Body = ");
  fprint_Union1(stream, (Union1*)&value->Body);
  fprintf(stream, "; Id = ");
  fprint_Union4(stream, (Union4*)&value->Id);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{Lhs = ");
  fprint_Union1(stream, (Union1*)&value->Lhs);
  fprintf(stream, "; Rhs = ");
  fprint_Union1(stream, (Union1*)&value->Rhs);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{Var = ");
  fprint_Union4(stream, (Union4*)&value->Var);
  fprintf(stream, "}");
}
void fprint_Type8(FILE *stream, const Type8* value) {
  fprintf(stream, "{print = ");
  fprint_Union3(stream, (Union3*)&value->print);
  fprintf(stream, "; subst = ");
  fprint_Union3(stream, (Union3*)&value->subst);
  fprintf(stream, "}");
}
void fprint_Type9(FILE *stream, const Type9* value) {
  fprintf(stream, "{apply = ");
  fprint_Union3(stream, (Union3*)&value->apply);
  fprintf(stream, "; eval = ");
  fprint_Union3(stream, (Union3*)&value->eval);
  fprintf(stream, "; print = ");
  fprint_Union3(stream, (Union3*)&value->print);
  fprintf(stream, "; subst = ");
  fprint_Union3(stream, (Union3*)&value->subst);
  fprintf(stream, "}");
}
void fprint_Type10(FILE *stream, const Type10* value) {
  fprintf(stream, "{eval = ");
  fprint_Union3(stream, (Union3*)&value->eval);
  fprintf(stream, "; print = ");
  fprint_Union3(stream, (Union3*)&value->print);
  fprintf(stream, "; subst = ");
  fprint_Union3(stream, (Union3*)&value->subst);
  fprintf(stream, "}");
}
void fprint_Type11(FILE *stream, const Type11* value) {
  fprintf(stream, "{}");
}
void fprint_Type12(FILE *stream, const Type12* value) {
  fprintf(stream, "{}");
}
void fprint_Type13(FILE *stream, const Type13* value) {
  fprintf(stream, "{}");
}
void fprint_Type14(FILE *stream, const Type14* value) {
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
  }
}
void fprint_Union2(FILE *stream, const Union2* value) {
  switch ((*value)->tag) {
    case Union2_Type8:
      fprint_Type8(stream, &(*value)->Type8);
      break;
    case Union2_Type9:
      fprint_Type9(stream, &(*value)->Type9);
      break;
    case Union2_Type10:
      fprint_Type10(stream, &(*value)->Type10);
      break;
  }
}
void fprint_Union3(FILE *stream, const Union3* value) {
  fprint_Type4(stream, &value->Type4);
}
void fprint_Union4(FILE *stream, const Union4* value) {
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union5(FILE *stream, const Union5* value) {
  switch (value->tag) {
    case Union5_Type2:
      fprint_Type2(stream, &value->Type2);
      break;
    case Union5_Type3:
      fprint_Type3(stream, &value->Type3);
      break;
  }
}
void fprint_Union6(FILE *stream, const Union6* value) {
  switch (value->tag) {
    case Union6_Type11:
      fprint_Type11(stream, &value->Type11);
      break;
    case Union6_Type12:
      fprint_Type12(stream, &value->Type12);
      break;
    case Union6_Type13:
      fprint_Type13(stream, &value->Type13);
      break;
    case Union6_Type14:
      fprint_Type14(stream, &value->Type14);
      break;
  }
}

void ___main(const __main_Closure *_clo, Union1 *restrict $0) {
  tail_call:;
  /* let var$0 = fun id$0 -> (...) */
  Union3 var$0;
  static const var$0_Closure _var$0$ = { ._func = _var$0 };
  var$0.Type4 = (Closure*)&_var$0$;
  
  /* let lam$0 = fun id$1 -> (...) */
  Union3 lam$0;
  static const lam$0_Closure _lam$0$ = { ._func = _lam$0 };
  lam$0.Type4 = (Closure*)&_lam$0$;
  
  /* let apl$0 = fun lhs$0 -> (...) */
  Union3 apl$0;
  static const apl$0_Closure _apl$0$ = { ._func = _apl$0 };
  apl$0.Type4 = (Closure*)&_apl$0$;
  
  /* let $68 = 1 */
  Union4 $68;
  $68.Type1 = 1;
  
  /* let $69 = lam$0 $68 */
  Union3 $69;
  CALL(lam$0.Type4, &$69, $68);
  
  /* let $70 = 2 */
  Union4 $70;
  $70.Type1 = 2;
  
  /* let $71 = lam$0 $70 */
  Union3 $71;
  CALL(lam$0.Type4, &$71, $70);
  
  /* let $72 = 3 */
  Union4 $72;
  $72.Type1 = 3;
  
  /* let $73 = lam$0 $72 */
  Union3 $73;
  CALL(lam$0.Type4, &$73, $72);
  
  /* let $74 = 2 */
  Union4 $74;
  $74.Type1 = 2;
  
  /* let $75 = var$0 $74 */
  Union2 $75;
  CALL(var$0.Type4, &$75, $74);
  
  /* let $76 = apl$0 $75 */
  Union3 $76;
  CALL(apl$0.Type4, &$76, $75);
  
  /* let $77 = 1 */
  Union4 $77;
  $77.Type1 = 1;
  
  /* let $78 = var$0 $77 */
  Union2 $78;
  CALL(var$0.Type4, &$78, $77);
  
  /* let $79 = apl$0 $78 */
  Union3 $79;
  CALL(apl$0.Type4, &$79, $78);
  
  /* let $80 = 2 */
  Union4 $80;
  $80.Type1 = 2;
  
  /* let $81 = var$0 $80 */
  Union2 $81;
  CALL(var$0.Type4, &$81, $80);
  
  /* let $82 = $79 $81 */
  Union2 $82;
  CALL($79.Type4, &$82, $81);
  
  /* let $83 = apl$0 $82 */
  Union3 $83;
  CALL(apl$0.Type4, &$83, $82);
  
  /* let $84 = 3 */
  Union4 $84;
  $84.Type1 = 3;
  
  /* let $85 = var$0 $84 */
  Union2 $85;
  CALL(var$0.Type4, &$85, $84);
  
  /* let $86 = $83 $85 */
  Union2 $86;
  CALL($83.Type4, &$86, $85);
  
  /* let $87 = $76 $86 */
  Union2 $87;
  CALL($76.Type4, &$87, $86);
  
  /* let $88 = $73 $87 */
  Union2 $88;
  CALL($73.Type4, &$88, $87);
  
  /* let $89 = $71 $88 */
  Union2 $89;
  CALL($71.Type4, &$89, $88);
  
  /* let succ$0 = $69 $89 */
  Union2 succ$0;
  CALL($69.Type4, &succ$0, $89);
  
  /* let $90 = 1 */
  Union4 $90;
  $90.Type1 = 1;
  
  /* let $91 = lam$0 $90 */
  Union3 $91;
  CALL(lam$0.Type4, &$91, $90);
  
  /* let $92 = 2 */
  Union4 $92;
  $92.Type1 = 2;
  
  /* let $93 = lam$0 $92 */
  Union3 $93;
  CALL(lam$0.Type4, &$93, $92);
  
  /* let $94 = 1 */
  Union4 $94;
  $94.Type1 = 1;
  
  /* let $95 = var$0 $94 */
  Union2 $95;
  CALL(var$0.Type4, &$95, $94);
  
  /* let $96 = apl$0 $95 */
  Union3 $96;
  CALL(apl$0.Type4, &$96, $95);
  
  /* let $97 = $96 succ$0 */
  Union2 $97;
  CALL($96.Type4, &$97, succ$0);
  
  /* let $98 = apl$0 $97 */
  Union3 $98;
  CALL(apl$0.Type4, &$98, $97);
  
  /* let $99 = 2 */
  Union4 $99;
  $99.Type1 = 2;
  
  /* let $100 = var$0 $99 */
  Union2 $100;
  CALL(var$0.Type4, &$100, $99);
  
  /* let $101 = $98 $100 */
  Union2 $101;
  CALL($98.Type4, &$101, $100);
  
  /* let $102 = $93 $101 */
  Union2 $102;
  CALL($93.Type4, &$102, $101);
  
  /* let add$0 = $91 $102 */
  Union2 add$0;
  CALL($91.Type4, &add$0, $102);
  
  /* let $103 = 1 */
  Union4 $103;
  $103.Type1 = 1;
  
  /* let $104 = lam$0 $103 */
  Union3 $104;
  CALL(lam$0.Type4, &$104, $103);
  
  /* let $105 = 2 */
  Union4 $105;
  $105.Type1 = 2;
  
  /* let $106 = lam$0 $105 */
  Union3 $106;
  CALL(lam$0.Type4, &$106, $105);
  
  /* let $107 = 3 */
  Union4 $107;
  $107.Type1 = 3;
  
  /* let $108 = lam$0 $107 */
  Union3 $108;
  CALL(lam$0.Type4, &$108, $107);
  
  /* let $109 = 1 */
  Union4 $109;
  $109.Type1 = 1;
  
  /* let $110 = var$0 $109 */
  Union2 $110;
  CALL(var$0.Type4, &$110, $109);
  
  /* let $111 = apl$0 $110 */
  Union3 $111;
  CALL(apl$0.Type4, &$111, $110);
  
  /* let $112 = 2 */
  Union4 $112;
  $112.Type1 = 2;
  
  /* let $113 = var$0 $112 */
  Union2 $113;
  CALL(var$0.Type4, &$113, $112);
  
  /* let $114 = apl$0 $113 */
  Union3 $114;
  CALL(apl$0.Type4, &$114, $113);
  
  /* let $115 = 3 */
  Union4 $115;
  $115.Type1 = 3;
  
  /* let $116 = var$0 $115 */
  Union2 $116;
  CALL(var$0.Type4, &$116, $115);
  
  /* let $117 = $114 $116 */
  Union2 $117;
  CALL($114.Type4, &$117, $116);
  
  /* let $118 = $111 $117 */
  Union2 $118;
  CALL($111.Type4, &$118, $117);
  
  /* let $119 = $108 $118 */
  Union2 $119;
  CALL($108.Type4, &$119, $118);
  
  /* let $120 = $106 $119 */
  Union2 $120;
  CALL($106.Type4, &$120, $119);
  
  /* let mul$0 = $104 $120 */
  Union2 mul$0;
  CALL($104.Type4, &mul$0, $120);
  
  /* let $121 = 1 */
  Union4 $121;
  $121.Type1 = 1;
  
  /* let $122 = lam$0 $121 */
  Union3 $122;
  CALL(lam$0.Type4, &$122, $121);
  
  /* let $123 = 2 */
  Union4 $123;
  $123.Type1 = 2;
  
  /* let $124 = lam$0 $123 */
  Union3 $124;
  CALL(lam$0.Type4, &$124, $123);
  
  /* let $125 = 3 */
  Union4 $125;
  $125.Type1 = 3;
  
  /* let $126 = lam$0 $125 */
  Union3 $126;
  CALL(lam$0.Type4, &$126, $125);
  
  /* let $127 = 1 */
  Union4 $127;
  $127.Type1 = 1;
  
  /* let $128 = var$0 $127 */
  Union2 $128;
  CALL(var$0.Type4, &$128, $127);
  
  /* let $129 = apl$0 $128 */
  Union3 $129;
  CALL(apl$0.Type4, &$129, $128);
  
  /* let $130 = 4 */
  Union4 $130;
  $130.Type1 = 4;
  
  /* let $131 = lam$0 $130 */
  Union3 $131;
  CALL(lam$0.Type4, &$131, $130);
  
  /* let $132 = 5 */
  Union4 $132;
  $132.Type1 = 5;
  
  /* let $133 = lam$0 $132 */
  Union3 $133;
  CALL(lam$0.Type4, &$133, $132);
  
  /* let $134 = 5 */
  Union4 $134;
  $134.Type1 = 5;
  
  /* let $135 = var$0 $134 */
  Union2 $135;
  CALL(var$0.Type4, &$135, $134);
  
  /* let $136 = apl$0 $135 */
  Union3 $136;
  CALL(apl$0.Type4, &$136, $135);
  
  /* let $137 = 4 */
  Union4 $137;
  $137.Type1 = 4;
  
  /* let $138 = var$0 $137 */
  Union2 $138;
  CALL(var$0.Type4, &$138, $137);
  
  /* let $139 = apl$0 $138 */
  Union3 $139;
  CALL(apl$0.Type4, &$139, $138);
  
  /* let $140 = 2 */
  Union4 $140;
  $140.Type1 = 2;
  
  /* let $141 = var$0 $140 */
  Union2 $141;
  CALL(var$0.Type4, &$141, $140);
  
  /* let $142 = $139 $141 */
  Union2 $142;
  CALL($139.Type4, &$142, $141);
  
  /* let $143 = $136 $142 */
  Union2 $143;
  CALL($136.Type4, &$143, $142);
  
  /* let $144 = $133 $143 */
  Union2 $144;
  CALL($133.Type4, &$144, $143);
  
  /* let $145 = $131 $144 */
  Union2 $145;
  CALL($131.Type4, &$145, $144);
  
  /* let $146 = $129 $145 */
  Union2 $146;
  CALL($129.Type4, &$146, $145);
  
  /* let $147 = apl$0 $146 */
  Union3 $147;
  CALL(apl$0.Type4, &$147, $146);
  
  /* let $148 = 6 */
  Union4 $148;
  $148.Type1 = 6;
  
  /* let $149 = lam$0 $148 */
  Union3 $149;
  CALL(lam$0.Type4, &$149, $148);
  
  /* let $150 = 3 */
  Union4 $150;
  $150.Type1 = 3;
  
  /* let $151 = var$0 $150 */
  Union2 $151;
  CALL(var$0.Type4, &$151, $150);
  
  /* let $152 = $149 $151 */
  Union2 $152;
  CALL($149.Type4, &$152, $151);
  
  /* let $153 = $147 $152 */
  Union2 $153;
  CALL($147.Type4, &$153, $152);
  
  /* let $154 = apl$0 $153 */
  Union3 $154;
  CALL(apl$0.Type4, &$154, $153);
  
  /* let $155 = 6 */
  Union4 $155;
  $155.Type1 = 6;
  
  /* let $156 = lam$0 $155 */
  Union3 $156;
  CALL(lam$0.Type4, &$156, $155);
  
  /* let $157 = 6 */
  Union4 $157;
  $157.Type1 = 6;
  
  /* let $158 = var$0 $157 */
  Union2 $158;
  CALL(var$0.Type4, &$158, $157);
  
  /* let $159 = $156 $158 */
  Union2 $159;
  CALL($156.Type4, &$159, $158);
  
  /* let $160 = $154 $159 */
  Union2 $160;
  CALL($154.Type4, &$160, $159);
  
  /* let $161 = $126 $160 */
  Union2 $161;
  CALL($126.Type4, &$161, $160);
  
  /* let $162 = $124 $161 */
  Union2 $162;
  CALL($124.Type4, &$162, $161);
  
  /* let pred$0 = $122 $162 */
  Union2 pred$0;
  CALL($122.Type4, &pred$0, $162);
  
  /* let $163 = 1 */
  Union4 $163;
  $163.Type1 = 1;
  
  /* let $164 = lam$0 $163 */
  Union3 $164;
  CALL(lam$0.Type4, &$164, $163);
  
  /* let $165 = 2 */
  Union4 $165;
  $165.Type1 = 2;
  
  /* let $166 = lam$0 $165 */
  Union3 $166;
  CALL(lam$0.Type4, &$166, $165);
  
  /* let $167 = 2 */
  Union4 $167;
  $167.Type1 = 2;
  
  /* let $168 = var$0 $167 */
  Union2 $168;
  CALL(var$0.Type4, &$168, $167);
  
  /* let $169 = apl$0 $168 */
  Union3 $169;
  CALL(apl$0.Type4, &$169, $168);
  
  /* let $170 = $169 pred$0 */
  Union2 $170;
  CALL($169.Type4, &$170, pred$0);
  
  /* let $171 = apl$0 $170 */
  Union3 $171;
  CALL(apl$0.Type4, &$171, $170);
  
  /* let $172 = 1 */
  Union4 $172;
  $172.Type1 = 1;
  
  /* let $173 = var$0 $172 */
  Union2 $173;
  CALL(var$0.Type4, &$173, $172);
  
  /* let $174 = $171 $173 */
  Union2 $174;
  CALL($171.Type4, &$174, $173);
  
  /* let $175 = $166 $174 */
  Union2 $175;
  CALL($166.Type4, &$175, $174);
  
  /* let sub$0 = $164 $175 */
  Union2 sub$0;
  CALL($164.Type4, &sub$0, $175);
  
  /* let church$0 = fun n$0 -> (...) */
  Union3 church$0;
  church$0.Type4 = HEAP_VALUE(church$0_Closure, {
    ._func = _church$0,
    .apl$0 = apl$0,
    .lam$0 = lam$0,
    .succ$0 = succ$0,
    .var$0 = var$0,
  });
  
  /* let $192 = 0 */
  Union4 $192;
  $192.Type1 = 0;
  
  /* let $193 = lam$0 $192 */
  Union3 $193;
  CALL(lam$0.Type4, &$193, $192);
  
  /* let $194 = 0 */
  Union4 $194;
  $194.Type1 = 0;
  
  /* let $195 = var$0 $194 */
  Union2 $195;
  CALL(var$0.Type4, &$195, $194);
  
  /* let $196 = apl$0 $195 */
  Union3 $196;
  CALL(apl$0.Type4, &$196, $195);
  
  /* let $197 = $196 succ$0 */
  Union2 $197;
  CALL($196.Type4, &$197, succ$0);
  
  /* let $198 = apl$0 $197 */
  Union3 $198;
  CALL(apl$0.Type4, &$198, $197);
  
  /* let $199 = 0 */
  Union4 $199;
  $199.Type1 = 0;
  
  /* let $200 = church$0 $199 */
  Union2 $200;
  CALL(church$0.Type4, &$200, $199);
  
  /* let $201 = $198 $200 */
  Union2 $201;
  CALL($198.Type4, &$201, $200);
  
  /* let identity$0 = $193 $201 */
  Union2 identity$0;
  CALL($193.Type4, &identity$0, $201);
  
  /* let n$1 = input */
  Union4 n$1;
  __input(&n$1.Type1);
  
  /* let $202 = apl$0 identity$0 */
  Union3 $202;
  CALL(apl$0.Type4, &$202, identity$0);
  
  /* let $203 = apl$0 sub$0 */
  Union3 $203;
  CALL(apl$0.Type4, &$203, sub$0);
  
  /* let $204 = church$0 n$1 */
  Union2 $204;
  CALL(church$0.Type4, &$204, n$1);
  
  /* let $205 = $203 $204 */
  Union2 $205;
  CALL($203.Type4, &$205, $204);
  
  /* let $206 = apl$0 $205 */
  Union3 $206;
  CALL(apl$0.Type4, &$206, $205);
  
  /* let $207 = 1 */
  Union4 $207;
  $207.Type1 = 1;
  
  /* let $208 = n$1 - $207 */
  Union4 $208;
  $208.Type1 = n$1.Type1 - $207.Type1;
  
  /* let $209 = church$0 $208 */
  Union2 $209;
  CALL(church$0.Type4, &$209, $208);
  
  /* let $210 = $206 $209 */
  Union2 $210;
  CALL($206.Type4, &$210, $209);
  
  /* let one$0 = $202 $210 */
  Union2 one$0;
  CALL($202.Type4, &one$0, $210);
  
  /* let $211 = one$0.eval */
  Union3 $211;
  switch (one$0->tag) {
    case Union2_Type8:
      ABORT;
      break;
    case Union2_Type9:
      COPY(&$211, &one$0->Type9.eval, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$211, &one$0->Type10.eval, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $212 = $211 one$0 */
  Union2 $212;
  CALL($211.Type4, &$212, one$0);
  
  /* let $213 = $212.print */
  Union3 $213;
  switch ($212->tag) {
    case Union2_Type8:
      COPY(&$213, &$212->Type8.print, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$213, &$212->Type9.print, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$213, &$212->Type10.print, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $214 = {} */
  Union6 $214;
  $214.tag = Union6_Type11;
  
  /* let $0 = $213 $214 */
  CALL($213.Type4, &(*$0), $214);
}


void _$3(const $3_Closure *_clo, Union2 *restrict $4, Union2 value$0) {
  tail_call:;
  /* let $5 = var$1 == id$0 */
  Union5 $5;
  if (_clo->var$1.Type1 == _clo->id$0.Type1) {
    $5.tag = Union5_Type2;
  }
  else {
    $5.tag = Union5_Type3;
  }
  
  /* let $4 = match $5 with ... */
  switch ($5.tag) {
    case Union5_Type3:
    {
      /* let $7 = self$0 */
      (*(&(*$4))) = _clo->self$0;
      break;
    }
    case Union5_Type2:
    {
      /* let $6 = value$0 */
      (*(&(*$4))) = value$0;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _$2(const $2_Closure *_clo, Union3 *restrict $3, Union4 var$1) {
  tail_call:;
  /* let $3 = fun value$0 -> (...) */
  (*$3).Type4 = HEAP_VALUE($3_Closure, {
    ._func = _$3,
    .id$0 = _clo->id$0,
    .self$0 = _clo->self$0,
    .var$1 = var$1,
  });
}


void _$8(const $8_Closure *_clo, Union3 *restrict $2, Union2 self$0) {
  tail_call:;
  /* let $2 = fun var$1 -> (...) */
  (*$2).Type4 = HEAP_VALUE($2_Closure, {
    ._func = _$2,
    .id$0 = _clo->id$0,
    .self$0 = self$0,
  });
}


void _$10(const $10_Closure *_clo, Union1 *restrict $9, Union6 self$1) {
  tail_call:;
  /* let $9 = {Var = id$0} */
  (*$9) = HEAP_ALLOC(sizeof(*(*$9)));
  (*$9)->tag = Union1_Type7;
  COPY(&(*$9)->Type7.Var, &_clo->id$0, sizeof(Union4));
}


void _var$0(const var$0_Closure *_clo, Union2 *restrict $1, Union4 id$0) {
  tail_call:;
  /* let $8 = fun self$0 -> (...) */
  Union3 $8;
  $8.Type4 = HEAP_VALUE($8_Closure, {
    ._func = _$8,
    .id$0 = id$0,
  });
  
  /* let $10 = fun self$1 -> (...) */
  Union3 $10;
  $10.Type4 = HEAP_VALUE($10_Closure, {
    ._func = _$10,
    .id$0 = id$0,
  });
  
  /* let $1 = {subst = $8; print = $10} */
  (*$1) = HEAP_ALLOC(sizeof(*(*$1)));
  (*$1)->tag = Union2_Type8;
  COPY(&(*$1)->Type8.subst, &$8, sizeof(Union3));
  COPY(&(*$1)->Type8.print, &$10, sizeof(Union3));
}


void _$14(const $14_Closure *_clo, Union2 *restrict $15, Union2 value$1) {
  tail_call:;
  /* let $16 = var$2 == id$1 */
  Union5 $16;
  if (_clo->var$2.Type1 == _clo->id$1.Type1) {
    $16.tag = Union5_Type2;
  }
  else {
    $16.tag = Union5_Type3;
  }
  
  /* let $15 = match $16 with ... */
  switch ($16.tag) {
    case Union5_Type3:
    {
      /* let $19 = lam$0 id$1 */
      Union3 $19;
      CALL(_clo->lam$0.Type4, &$19, _clo->id$1);
      
      /* let $20 = body$0.subst */
      Union3 $20;
      switch (_clo->body$0->tag) {
        case Union2_Type8:
          COPY(&$20, &_clo->body$0->Type8.subst, sizeof(Union3));
          break;
        case Union2_Type9:
          COPY(&$20, &_clo->body$0->Type9.subst, sizeof(Union3));
          break;
        case Union2_Type10:
          COPY(&$20, &_clo->body$0->Type10.subst, sizeof(Union3));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $21 = $20 body$0 */
      Union3 $21;
      CALL($20.Type4, &$21, _clo->body$0);
      
      /* let $22 = $21 var$2 */
      Union3 $22;
      CALL($21.Type4, &$22, _clo->var$2);
      
      /* let $23 = $22 value$1 */
      Union2 $23;
      CALL($22.Type4, &$23, value$1);
      
      /* let $18 = $19 $23 */
      CALL($19.Type4, &(*$15), $23);
      break;
    }
    case Union5_Type2:
    {
      /* let $17 = self$2 */
      (*(&(*$15))) = _clo->self$2;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _$13(const $13_Closure *_clo, Union3 *restrict $14, Union4 var$2) {
  tail_call:;
  /* let $14 = fun value$1 -> (...) */
  (*$14).Type4 = HEAP_VALUE($14_Closure, {
    ._func = _$14,
    .body$0 = _clo->body$0,
    .id$1 = _clo->id$1,
    .lam$0 = _clo->lam$0,
    .self$2 = _clo->self$2,
    .var$2 = var$2,
  });
}


void _$24(const $24_Closure *_clo, Union3 *restrict $13, Union2 self$2) {
  tail_call:;
  /* let $13 = fun var$2 -> (...) */
  (*$13).Type4 = HEAP_VALUE($13_Closure, {
    ._func = _$13,
    .body$0 = _clo->body$0,
    .id$1 = _clo->id$1,
    .lam$0 = _clo->lam$0,
    .self$2 = self$2,
  });
}


void _$26(const $26_Closure *_clo, Union2 *restrict $25, Union2 self$3) {
  tail_call:;
  /* let $25 = self$3 */
  (*(&(*$25))) = self$3;
}


void _$27(const $27_Closure *_clo, Union2 *restrict $28, Union2 arg$0) {
  tail_call:;
  /* let $29 = body$0.subst */
  Union3 $29;
  switch (_clo->body$0->tag) {
    case Union2_Type8:
      COPY(&$29, &_clo->body$0->Type8.subst, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$29, &_clo->body$0->Type9.subst, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$29, &_clo->body$0->Type10.subst, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $30 = $29 body$0 */
  Union3 $30;
  CALL($29.Type4, &$30, _clo->body$0);
  
  /* let $31 = $30 id$1 */
  Union3 $31;
  CALL($30.Type4, &$31, _clo->id$1);
  
  /* let body$1 = $31 arg$0 */
  Union2 body$1;
  CALL($31.Type4, &body$1, arg$0);
  
  /* let $32 = body$1.eval */
  Union3 $32;
  switch (body$1->tag) {
    case Union2_Type8:
      ABORT;
      break;
    case Union2_Type9:
      COPY(&$32, &body$1->Type9.eval, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$32, &body$1->Type10.eval, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $28 = $32 body$1 */
  CALL($32.Type4, &(*$28), body$1);
}


void _$33(const $33_Closure *_clo, Union3 *restrict $27, Union2 self$4) {
  tail_call:;
  /* let $27 = fun arg$0 -> (...) */
  (*$27).Type4 = HEAP_VALUE($27_Closure, {
    ._func = _$27,
    .body$0 = _clo->body$0,
    .id$1 = _clo->id$1,
  });
}


void _$38(const $38_Closure *_clo, Union1 *restrict $34, Union6 self$5) {
  tail_call:;
  /* let $35 = body$0.print */
  Union3 $35;
  switch (_clo->body$0->tag) {
    case Union2_Type8:
      COPY(&$35, &_clo->body$0->Type8.print, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$35, &_clo->body$0->Type9.print, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$35, &_clo->body$0->Type10.print, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $36 = {} */
  Union6 $36;
  $36.tag = Union6_Type12;
  
  /* let $37 = $35 $36 */
  Union1 $37;
  CALL($35.Type4, &$37, $36);
  
  /* let $34 = {Id = id$1; Body = $37} */
  (*$34) = HEAP_ALLOC(sizeof(*(*$34)));
  (*$34)->tag = Union1_Type5;
  COPY(&(*$34)->Type5.Id, &_clo->id$1, sizeof(Union4));
  COPY(&(*$34)->Type5.Body, &$37, sizeof(Union1));
}


void _$11(const $11_Closure *_clo, Union2 *restrict $12, Union2 body$0) {
  tail_call:;
  /* let $24 = fun self$2 -> (...) */
  Union3 $24;
  $24.Type4 = HEAP_VALUE($24_Closure, {
    ._func = _$24,
    .body$0 = body$0,
    .id$1 = _clo->id$1,
    .lam$0 = _clo->lam$0,
  });
  
  /* let $26 = fun self$3 -> (...) */
  Union3 $26;
  static const $26_Closure _$26$ = { ._func = _$26 };
  $26.Type4 = (Closure*)&_$26$;
  
  /* let $33 = fun self$4 -> (...) */
  Union3 $33;
  $33.Type4 = HEAP_VALUE($33_Closure, {
    ._func = _$33,
    .body$0 = body$0,
    .id$1 = _clo->id$1,
  });
  
  /* let $38 = fun self$5 -> (...) */
  Union3 $38;
  $38.Type4 = HEAP_VALUE($38_Closure, {
    ._func = _$38,
    .body$0 = body$0,
    .id$1 = _clo->id$1,
  });
  
  /* let $12 = {subst = $24; eval = $26; apply = $33; print = $38} */
  (*$12) = HEAP_ALLOC(sizeof(*(*$12)));
  (*$12)->tag = Union2_Type9;
  COPY(&(*$12)->Type9.subst, &$24, sizeof(Union3));
  COPY(&(*$12)->Type9.eval, &$26, sizeof(Union3));
  COPY(&(*$12)->Type9.apply, &$33, sizeof(Union3));
  COPY(&(*$12)->Type9.print, &$38, sizeof(Union3));
}


void _lam$0(const lam$0_Closure *_clo, Union3 *restrict $11, Union4 id$1) {
  tail_call:;
  /* let $11 = fun body$0 -> (...) */
  (*$11).Type4 = HEAP_VALUE($11_Closure, {
    ._func = _$11,
    .id$1 = id$1,
    .lam$0 = UNTAGGED(Union3, Type4, (const Closure*)_clo),
  });
}


void _$42(const $42_Closure *_clo, Union2 *restrict $43, Union2 value$2) {
  tail_call:;
  /* let $44 = lhs$0.subst */
  Union3 $44;
  switch (_clo->lhs$0->tag) {
    case Union2_Type8:
      COPY(&$44, &_clo->lhs$0->Type8.subst, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$44, &_clo->lhs$0->Type9.subst, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$44, &_clo->lhs$0->Type10.subst, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $45 = $44 lhs$0 */
  Union3 $45;
  CALL($44.Type4, &$45, _clo->lhs$0);
  
  /* let $46 = $45 var$3 */
  Union3 $46;
  CALL($45.Type4, &$46, _clo->var$3);
  
  /* let $47 = $46 value$2 */
  Union2 $47;
  CALL($46.Type4, &$47, value$2);
  
  /* let $48 = apl$0 $47 */
  Union3 $48;
  CALL(_clo->apl$0.Type4, &$48, $47);
  
  /* let $49 = rhs$0.subst */
  Union3 $49;
  switch (_clo->rhs$0->tag) {
    case Union2_Type8:
      COPY(&$49, &_clo->rhs$0->Type8.subst, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$49, &_clo->rhs$0->Type9.subst, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$49, &_clo->rhs$0->Type10.subst, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $50 = $49 rhs$0 */
  Union3 $50;
  CALL($49.Type4, &$50, _clo->rhs$0);
  
  /* let $51 = $50 var$3 */
  Union3 $51;
  CALL($50.Type4, &$51, _clo->var$3);
  
  /* let $52 = $51 value$2 */
  Union2 $52;
  CALL($51.Type4, &$52, value$2);
  
  /* let $43 = $48 $52 */
  CALL($48.Type4, &(*$43), $52);
}


void _$41(const $41_Closure *_clo, Union3 *restrict $42, Union4 var$3) {
  tail_call:;
  /* let $42 = fun value$2 -> (...) */
  (*$42).Type4 = HEAP_VALUE($42_Closure, {
    ._func = _$42,
    .apl$0 = _clo->apl$0,
    .lhs$0 = _clo->lhs$0,
    .rhs$0 = _clo->rhs$0,
    .var$3 = var$3,
  });
}


void _$53(const $53_Closure *_clo, Union3 *restrict $41, Union2 self$6) {
  tail_call:;
  /* let $41 = fun var$3 -> (...) */
  (*$41).Type4 = HEAP_VALUE($41_Closure, {
    ._func = _$41,
    .apl$0 = _clo->apl$0,
    .lhs$0 = _clo->lhs$0,
    .rhs$0 = _clo->rhs$0,
  });
}


void _$59(const $59_Closure *_clo, Union2 *restrict $54, Union2 self$7) {
  tail_call:;
  /* let $55 = lhs$0.eval */
  Union3 $55;
  switch (_clo->lhs$0->tag) {
    case Union2_Type8:
      ABORT;
      break;
    case Union2_Type9:
      COPY(&$55, &_clo->lhs$0->Type9.eval, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$55, &_clo->lhs$0->Type10.eval, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let lhs$1 = $55 lhs$0 */
  Union2 lhs$1;
  CALL($55.Type4, &lhs$1, _clo->lhs$0);
  
  /* let $56 = rhs$0.eval */
  Union3 $56;
  switch (_clo->rhs$0->tag) {
    case Union2_Type8:
      ABORT;
      break;
    case Union2_Type9:
      COPY(&$56, &_clo->rhs$0->Type9.eval, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$56, &_clo->rhs$0->Type10.eval, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let rhs$1 = $56 rhs$0 */
  Union2 rhs$1;
  CALL($56.Type4, &rhs$1, _clo->rhs$0);
  
  /* let $57 = lhs$1.apply */
  Union3 $57;
  switch (lhs$1->tag) {
    case Union2_Type8:
      ABORT;
      break;
    case Union2_Type9:
      COPY(&$57, &lhs$1->Type9.apply, sizeof(Union3));
      break;
    case Union2_Type10:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $58 = $57 lhs$1 */
  Union3 $58;
  CALL($57.Type4, &$58, lhs$1);
  
  /* let $54 = $58 rhs$1 */
  CALL($58.Type4, &(*$54), rhs$1);
}


void _$67(const $67_Closure *_clo, Union1 *restrict $60, Union6 self$8) {
  tail_call:;
  /* let $61 = lhs$0.print */
  Union3 $61;
  switch (_clo->lhs$0->tag) {
    case Union2_Type8:
      COPY(&$61, &_clo->lhs$0->Type8.print, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$61, &_clo->lhs$0->Type9.print, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$61, &_clo->lhs$0->Type10.print, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $62 = {} */
  Union6 $62;
  $62.tag = Union6_Type13;
  
  /* let $63 = $61 $62 */
  Union1 $63;
  CALL($61.Type4, &$63, $62);
  
  /* let $64 = rhs$0.print */
  Union3 $64;
  switch (_clo->rhs$0->tag) {
    case Union2_Type8:
      COPY(&$64, &_clo->rhs$0->Type8.print, sizeof(Union3));
      break;
    case Union2_Type9:
      COPY(&$64, &_clo->rhs$0->Type9.print, sizeof(Union3));
      break;
    case Union2_Type10:
      COPY(&$64, &_clo->rhs$0->Type10.print, sizeof(Union3));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $65 = {} */
  Union6 $65;
  $65.tag = Union6_Type14;
  
  /* let $66 = $64 $65 */
  Union1 $66;
  CALL($64.Type4, &$66, $65);
  
  /* let $60 = {Lhs = $63; Rhs = $66} */
  (*$60) = HEAP_ALLOC(sizeof(*(*$60)));
  (*$60)->tag = Union1_Type6;
  COPY(&(*$60)->Type6.Lhs, &$63, sizeof(Union1));
  COPY(&(*$60)->Type6.Rhs, &$66, sizeof(Union1));
}


void _$39(const $39_Closure *_clo, Union2 *restrict $40, Union2 rhs$0) {
  tail_call:;
  /* let $53 = fun self$6 -> (...) */
  Union3 $53;
  $53.Type4 = HEAP_VALUE($53_Closure, {
    ._func = _$53,
    .apl$0 = _clo->apl$0,
    .lhs$0 = _clo->lhs$0,
    .rhs$0 = rhs$0,
  });
  
  /* let $59 = fun self$7 -> (...) */
  Union3 $59;
  $59.Type4 = HEAP_VALUE($59_Closure, {
    ._func = _$59,
    .lhs$0 = _clo->lhs$0,
    .rhs$0 = rhs$0,
  });
  
  /* let $67 = fun self$8 -> (...) */
  Union3 $67;
  $67.Type4 = HEAP_VALUE($67_Closure, {
    ._func = _$67,
    .lhs$0 = _clo->lhs$0,
    .rhs$0 = rhs$0,
  });
  
  /* let $40 = {subst = $53; eval = $59; print = $67} */
  (*$40) = HEAP_ALLOC(sizeof(*(*$40)));
  (*$40)->tag = Union2_Type10;
  COPY(&(*$40)->Type10.subst, &$53, sizeof(Union3));
  COPY(&(*$40)->Type10.eval, &$59, sizeof(Union3));
  COPY(&(*$40)->Type10.print, &$67, sizeof(Union3));
}


void _apl$0(const apl$0_Closure *_clo, Union3 *restrict $39, Union2 lhs$0) {
  tail_call:;
  /* let $39 = fun rhs$0 -> (...) */
  (*$39).Type4 = HEAP_VALUE($39_Closure, {
    ._func = _$39,
    .apl$0 = UNTAGGED(Union3, Type4, (const Closure*)_clo),
    .lhs$0 = lhs$0,
  });
}


void _church$0(const church$0_Closure *_clo, Union2 *restrict $176, Union4 n$0) {
  tail_call:;
  /* let $177 = 0 */
  Union4 $177;
  $177.Type1 = 0;
  
  /* let $178 = n$0 == $177 */
  Union5 $178;
  if (n$0.Type1 == $177.Type1) {
    $178.tag = Union5_Type2;
  }
  else {
    $178.tag = Union5_Type3;
  }
  
  /* let $176 = match $178 with ... */
  switch ($178.tag) {
    case Union5_Type3:
    {
      /* let $188 = apl$0 succ$0 */
      Union3 $188;
      CALL(_clo->apl$0.Type4, &$188, _clo->succ$0);
      
      /* let $189 = 1 */
      Union4 $189;
      $189.Type1 = 1;
      
      /* let $190 = n$0 - $189 */
      Union4 $190;
      $190.Type1 = n$0.Type1 - $189.Type1;
      
      /* let $191 = church$0 $190 */
      Union2 $191;
      _church$0(_clo, &$191, $190);
      
      /* let $187 = $188 $191 */
      CALL($188.Type4, &(*$176), $191);
      break;
    }
    case Union5_Type2:
    {
      /* let $180 = 0 */
      Union4 $180;
      $180.Type1 = 0;
      
      /* let $181 = lam$0 $180 */
      Union3 $181;
      CALL(_clo->lam$0.Type4, &$181, $180);
      
      /* let $182 = 1 */
      Union4 $182;
      $182.Type1 = 1;
      
      /* let $183 = lam$0 $182 */
      Union3 $183;
      CALL(_clo->lam$0.Type4, &$183, $182);
      
      /* let $184 = 1 */
      Union4 $184;
      $184.Type1 = 1;
      
      /* let $185 = var$0 $184 */
      Union2 $185;
      CALL(_clo->var$0.Type4, &$185, $184);
      
      /* let $186 = $183 $185 */
      Union2 $186;
      CALL($183.Type4, &$186, $185);
      
      /* let $179 = $181 $186 */
      CALL($181.Type4, &(*$176), $186);
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
