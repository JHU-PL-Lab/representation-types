
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

typedef struct /* $1 */ {
  Univ  Var; /* Union2 */
} Type5;

typedef struct /* $3 */ {
  Univ  Arg; /* Union2 */
  Univ  Body; /* Union1 */
  Empty Lam; /* Union6 */
} Type6;

typedef struct /* $6 */ {
  Empty Apl; /* Union7 */
  Univ  Lhs; /* Union1 */
  Univ  Rhs; /* Union1 */
} Type7;

typedef struct /* $22 */ {
  Univ  _0; /* Union2 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
} Type8;

typedef struct /* $26 */ {
  Univ  _0; /* Union2 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
} Type9;

typedef struct /* $30 */ {
  Univ  _0; /* Union2 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
} Type10;

typedef struct /* $40 */ {
  Univ  _0; /* Union2 */
  Univ  _1; /* Union1 */
  Univ  _2; /* Union1 */
} Type11;

typedef struct /* $4 */ {
} Type12;

typedef struct /* $7 */ {
} Type13;

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

typedef struct { Type1 Type1; }  Union2;
typedef struct { Type4 Type4; }  Union3;
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
  enum {
    Union5_Type8,
    Union5_Type9,
    Union5_Type10,
    Union5_Type11,
  } tag;
  union {
    Type8 Type8;
    Type9 Type9;
    Type10 Type10;
    Type11 Type11;
  };
}  *Union5;

typedef struct { Type12 Type12; }  Union6;
typedef struct { Type13 Type13; }  Union7;
typedef struct {
  Func *_func;
} var$0_Closure;

typedef struct {
  Func *_func;
  Union3 subst$0;
} term$1_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
} subst$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union1 succ$0;
  Union3 var$0;
} n$0_Closure;

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
  Union3 subst$0;
} eval$0_Closure;

typedef struct {
  Func *_func;
  Union1 e1$0;
} e2$0_Closure;

typedef struct {
  Func *_func;
} e1$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union1 succ$0;
  Union3 var$0;
} church$0_Closure;

typedef struct {
  Func *_func;
  Union2 id$1;
} body$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
} args$0_Closure;

typedef struct {
  Func *_func;
} apl$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union1 e1$0;
} $5_Closure;

typedef struct {
  Func *_func;
  Union2 id$1;
} $2_Closure;

Func _var$0;
Func _term$1;
Func _subst$0;
Func _n$0;
Func _lam$0;
Func _id$1;
Func _id$0;
Func _eval$0;
Func _e2$0;
Func _e1$0;
Func _church$0;
Func _body$0;
Func _args$0;
Func _apl$0;
Func ___main;
Func _$5;
Func _$2;

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
static inline void fprint_Union0(FILE *, const Union0*);
static inline void fprint_Union1(FILE *, const Union1*);
static inline void fprint_Union2(FILE *, const Union2*);
static inline void fprint_Union3(FILE *, const Union3*);
static inline void fprint_Union4(FILE *, const Union4*);
static inline void fprint_Union5(FILE *, const Union5*);
static inline void fprint_Union6(FILE *, const Union6*);
static inline void fprint_Union7(FILE *, const Union7*);

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
  fprintf(stream, "{Var = ");
  fprint_Union2(stream, (Union2*)&value->Var);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{Arg = ");
  fprint_Union2(stream, (Union2*)&value->Arg);
  fprintf(stream, "; Body = ");
  fprint_Union1(stream, (Union1*)&value->Body);
  fprintf(stream, "; Lam = ");
  fprint_Union6(stream, (Union6*)&value->Lam);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{Apl = ");
  fprint_Union7(stream, (Union7*)&value->Apl);
  fprintf(stream, "; Lhs = ");
  fprint_Union1(stream, (Union1*)&value->Lhs);
  fprintf(stream, "; Rhs = ");
  fprint_Union1(stream, (Union1*)&value->Rhs);
  fprintf(stream, "}");
}
void fprint_Type8(FILE *stream, const Type8* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union2(stream, (Union2*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "}");
}
void fprint_Type9(FILE *stream, const Type9* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union2(stream, (Union2*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "}");
}
void fprint_Type10(FILE *stream, const Type10* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union2(stream, (Union2*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "}");
}
void fprint_Type11(FILE *stream, const Type11* value) {
  fprintf(stream, "{_0 = ");
  fprint_Union2(stream, (Union2*)&value->_0);
  fprintf(stream, "; _1 = ");
  fprint_Union1(stream, (Union1*)&value->_1);
  fprintf(stream, "; _2 = ");
  fprint_Union1(stream, (Union1*)&value->_2);
  fprintf(stream, "}");
}
void fprint_Type12(FILE *stream, const Type12* value) {
  fprintf(stream, "{}");
}
void fprint_Type13(FILE *stream, const Type13* value) {
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
  fprint_Type1(stream, &value->Type1);
}
void fprint_Union3(FILE *stream, const Union3* value) {
  fprint_Type4(stream, &value->Type4);
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
void fprint_Union5(FILE *stream, const Union5* value) {
  switch ((*value)->tag) {
    case Union5_Type8:
      fprint_Type8(stream, &(*value)->Type8);
      break;
    case Union5_Type9:
      fprint_Type9(stream, &(*value)->Type9);
      break;
    case Union5_Type10:
      fprint_Type10(stream, &(*value)->Type10);
      break;
    case Union5_Type11:
      fprint_Type11(stream, &(*value)->Type11);
      break;
  }
}
void fprint_Union6(FILE *stream, const Union6* value) {
  fprint_Type12(stream, &value->Type12);
}
void fprint_Union7(FILE *stream, const Union7* value) {
  fprint_Type13(stream, &value->Type13);
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
  
  /* let apl$0 = fun e1$0 -> (...) */
  Union3 apl$0;
  static const apl$0_Closure _apl$0$ = { ._func = _apl$0 };
  apl$0.Type4 = (Closure*)&_apl$0$;
  
  /* let subst$0 = fun args$0 -> (...) */
  Union3 subst$0;
  subst$0.Type4 = HEAP_VALUE(subst$0_Closure, {
    ._func = _subst$0,
    .apl$0 = apl$0,
    .lam$0 = lam$0,
  });
  
  /* let eval$0 = fun term$1 -> (...) */
  Union3 eval$0;
  eval$0.Type4 = HEAP_VALUE(eval$0_Closure, {
    ._func = _eval$0,
    .subst$0 = subst$0,
  });
  
  /* let $41 = 1 */
  Union2 $41;
  $41.Type1 = 1;
  
  /* let $42 = lam$0 $41 */
  Union3 $42;
  CALL(lam$0.Type4, &$42, $41);
  
  /* let $43 = 2 */
  Union2 $43;
  $43.Type1 = 2;
  
  /* let $44 = lam$0 $43 */
  Union3 $44;
  CALL(lam$0.Type4, &$44, $43);
  
  /* let $45 = 3 */
  Union2 $45;
  $45.Type1 = 3;
  
  /* let $46 = lam$0 $45 */
  Union3 $46;
  CALL(lam$0.Type4, &$46, $45);
  
  /* let $47 = 2 */
  Union2 $47;
  $47.Type1 = 2;
  
  /* let $48 = var$0 $47 */
  Union1 $48;
  CALL(var$0.Type4, &$48, $47);
  
  /* let $49 = apl$0 $48 */
  Union3 $49;
  CALL(apl$0.Type4, &$49, $48);
  
  /* let $50 = 1 */
  Union2 $50;
  $50.Type1 = 1;
  
  /* let $51 = var$0 $50 */
  Union1 $51;
  CALL(var$0.Type4, &$51, $50);
  
  /* let $52 = apl$0 $51 */
  Union3 $52;
  CALL(apl$0.Type4, &$52, $51);
  
  /* let $53 = 2 */
  Union2 $53;
  $53.Type1 = 2;
  
  /* let $54 = var$0 $53 */
  Union1 $54;
  CALL(var$0.Type4, &$54, $53);
  
  /* let $55 = $52 $54 */
  Union1 $55;
  CALL($52.Type4, &$55, $54);
  
  /* let $56 = apl$0 $55 */
  Union3 $56;
  CALL(apl$0.Type4, &$56, $55);
  
  /* let $57 = 3 */
  Union2 $57;
  $57.Type1 = 3;
  
  /* let $58 = var$0 $57 */
  Union1 $58;
  CALL(var$0.Type4, &$58, $57);
  
  /* let $59 = $56 $58 */
  Union1 $59;
  CALL($56.Type4, &$59, $58);
  
  /* let $60 = $49 $59 */
  Union1 $60;
  CALL($49.Type4, &$60, $59);
  
  /* let $61 = $46 $60 */
  Union1 $61;
  CALL($46.Type4, &$61, $60);
  
  /* let $62 = $44 $61 */
  Union1 $62;
  CALL($44.Type4, &$62, $61);
  
  /* let succ$0 = $42 $62 */
  Union1 succ$0;
  CALL($42.Type4, &succ$0, $62);
  
  /* let $63 = 1 */
  Union2 $63;
  $63.Type1 = 1;
  
  /* let $64 = lam$0 $63 */
  Union3 $64;
  CALL(lam$0.Type4, &$64, $63);
  
  /* let $65 = 2 */
  Union2 $65;
  $65.Type1 = 2;
  
  /* let $66 = lam$0 $65 */
  Union3 $66;
  CALL(lam$0.Type4, &$66, $65);
  
  /* let $67 = 1 */
  Union2 $67;
  $67.Type1 = 1;
  
  /* let $68 = var$0 $67 */
  Union1 $68;
  CALL(var$0.Type4, &$68, $67);
  
  /* let $69 = apl$0 $68 */
  Union3 $69;
  CALL(apl$0.Type4, &$69, $68);
  
  /* let $70 = $69 succ$0 */
  Union1 $70;
  CALL($69.Type4, &$70, succ$0);
  
  /* let $71 = apl$0 $70 */
  Union3 $71;
  CALL(apl$0.Type4, &$71, $70);
  
  /* let $72 = 2 */
  Union2 $72;
  $72.Type1 = 2;
  
  /* let $73 = var$0 $72 */
  Union1 $73;
  CALL(var$0.Type4, &$73, $72);
  
  /* let $74 = $71 $73 */
  Union1 $74;
  CALL($71.Type4, &$74, $73);
  
  /* let $75 = $66 $74 */
  Union1 $75;
  CALL($66.Type4, &$75, $74);
  
  /* let add$0 = $64 $75 */
  Union1 add$0;
  CALL($64.Type4, &add$0, $75);
  
  /* let $76 = 1 */
  Union2 $76;
  $76.Type1 = 1;
  
  /* let $77 = lam$0 $76 */
  Union3 $77;
  CALL(lam$0.Type4, &$77, $76);
  
  /* let $78 = 2 */
  Union2 $78;
  $78.Type1 = 2;
  
  /* let $79 = lam$0 $78 */
  Union3 $79;
  CALL(lam$0.Type4, &$79, $78);
  
  /* let $80 = 3 */
  Union2 $80;
  $80.Type1 = 3;
  
  /* let $81 = lam$0 $80 */
  Union3 $81;
  CALL(lam$0.Type4, &$81, $80);
  
  /* let $82 = 1 */
  Union2 $82;
  $82.Type1 = 1;
  
  /* let $83 = var$0 $82 */
  Union1 $83;
  CALL(var$0.Type4, &$83, $82);
  
  /* let $84 = apl$0 $83 */
  Union3 $84;
  CALL(apl$0.Type4, &$84, $83);
  
  /* let $85 = 2 */
  Union2 $85;
  $85.Type1 = 2;
  
  /* let $86 = var$0 $85 */
  Union1 $86;
  CALL(var$0.Type4, &$86, $85);
  
  /* let $87 = apl$0 $86 */
  Union3 $87;
  CALL(apl$0.Type4, &$87, $86);
  
  /* let $88 = 3 */
  Union2 $88;
  $88.Type1 = 3;
  
  /* let $89 = var$0 $88 */
  Union1 $89;
  CALL(var$0.Type4, &$89, $88);
  
  /* let $90 = $87 $89 */
  Union1 $90;
  CALL($87.Type4, &$90, $89);
  
  /* let $91 = $84 $90 */
  Union1 $91;
  CALL($84.Type4, &$91, $90);
  
  /* let $92 = $81 $91 */
  Union1 $92;
  CALL($81.Type4, &$92, $91);
  
  /* let $93 = $79 $92 */
  Union1 $93;
  CALL($79.Type4, &$93, $92);
  
  /* let mul$0 = $77 $93 */
  Union1 mul$0;
  CALL($77.Type4, &mul$0, $93);
  
  /* let $94 = 1 */
  Union2 $94;
  $94.Type1 = 1;
  
  /* let $95 = lam$0 $94 */
  Union3 $95;
  CALL(lam$0.Type4, &$95, $94);
  
  /* let $96 = 2 */
  Union2 $96;
  $96.Type1 = 2;
  
  /* let $97 = lam$0 $96 */
  Union3 $97;
  CALL(lam$0.Type4, &$97, $96);
  
  /* let $98 = 3 */
  Union2 $98;
  $98.Type1 = 3;
  
  /* let $99 = lam$0 $98 */
  Union3 $99;
  CALL(lam$0.Type4, &$99, $98);
  
  /* let $100 = 1 */
  Union2 $100;
  $100.Type1 = 1;
  
  /* let $101 = var$0 $100 */
  Union1 $101;
  CALL(var$0.Type4, &$101, $100);
  
  /* let $102 = apl$0 $101 */
  Union3 $102;
  CALL(apl$0.Type4, &$102, $101);
  
  /* let $103 = 4 */
  Union2 $103;
  $103.Type1 = 4;
  
  /* let $104 = lam$0 $103 */
  Union3 $104;
  CALL(lam$0.Type4, &$104, $103);
  
  /* let $105 = 5 */
  Union2 $105;
  $105.Type1 = 5;
  
  /* let $106 = lam$0 $105 */
  Union3 $106;
  CALL(lam$0.Type4, &$106, $105);
  
  /* let $107 = 5 */
  Union2 $107;
  $107.Type1 = 5;
  
  /* let $108 = var$0 $107 */
  Union1 $108;
  CALL(var$0.Type4, &$108, $107);
  
  /* let $109 = apl$0 $108 */
  Union3 $109;
  CALL(apl$0.Type4, &$109, $108);
  
  /* let $110 = 4 */
  Union2 $110;
  $110.Type1 = 4;
  
  /* let $111 = var$0 $110 */
  Union1 $111;
  CALL(var$0.Type4, &$111, $110);
  
  /* let $112 = apl$0 $111 */
  Union3 $112;
  CALL(apl$0.Type4, &$112, $111);
  
  /* let $113 = 2 */
  Union2 $113;
  $113.Type1 = 2;
  
  /* let $114 = var$0 $113 */
  Union1 $114;
  CALL(var$0.Type4, &$114, $113);
  
  /* let $115 = $112 $114 */
  Union1 $115;
  CALL($112.Type4, &$115, $114);
  
  /* let $116 = $109 $115 */
  Union1 $116;
  CALL($109.Type4, &$116, $115);
  
  /* let $117 = $106 $116 */
  Union1 $117;
  CALL($106.Type4, &$117, $116);
  
  /* let $118 = $104 $117 */
  Union1 $118;
  CALL($104.Type4, &$118, $117);
  
  /* let $119 = $102 $118 */
  Union1 $119;
  CALL($102.Type4, &$119, $118);
  
  /* let $120 = apl$0 $119 */
  Union3 $120;
  CALL(apl$0.Type4, &$120, $119);
  
  /* let $121 = 6 */
  Union2 $121;
  $121.Type1 = 6;
  
  /* let $122 = lam$0 $121 */
  Union3 $122;
  CALL(lam$0.Type4, &$122, $121);
  
  /* let $123 = 3 */
  Union2 $123;
  $123.Type1 = 3;
  
  /* let $124 = var$0 $123 */
  Union1 $124;
  CALL(var$0.Type4, &$124, $123);
  
  /* let $125 = $122 $124 */
  Union1 $125;
  CALL($122.Type4, &$125, $124);
  
  /* let $126 = $120 $125 */
  Union1 $126;
  CALL($120.Type4, &$126, $125);
  
  /* let $127 = apl$0 $126 */
  Union3 $127;
  CALL(apl$0.Type4, &$127, $126);
  
  /* let $128 = 6 */
  Union2 $128;
  $128.Type1 = 6;
  
  /* let $129 = lam$0 $128 */
  Union3 $129;
  CALL(lam$0.Type4, &$129, $128);
  
  /* let $130 = 6 */
  Union2 $130;
  $130.Type1 = 6;
  
  /* let $131 = var$0 $130 */
  Union1 $131;
  CALL(var$0.Type4, &$131, $130);
  
  /* let $132 = $129 $131 */
  Union1 $132;
  CALL($129.Type4, &$132, $131);
  
  /* let $133 = $127 $132 */
  Union1 $133;
  CALL($127.Type4, &$133, $132);
  
  /* let $134 = $99 $133 */
  Union1 $134;
  CALL($99.Type4, &$134, $133);
  
  /* let $135 = $97 $134 */
  Union1 $135;
  CALL($97.Type4, &$135, $134);
  
  /* let pred$0 = $95 $135 */
  Union1 pred$0;
  CALL($95.Type4, &pred$0, $135);
  
  /* let $136 = 1 */
  Union2 $136;
  $136.Type1 = 1;
  
  /* let $137 = lam$0 $136 */
  Union3 $137;
  CALL(lam$0.Type4, &$137, $136);
  
  /* let $138 = 2 */
  Union2 $138;
  $138.Type1 = 2;
  
  /* let $139 = lam$0 $138 */
  Union3 $139;
  CALL(lam$0.Type4, &$139, $138);
  
  /* let $140 = 2 */
  Union2 $140;
  $140.Type1 = 2;
  
  /* let $141 = var$0 $140 */
  Union1 $141;
  CALL(var$0.Type4, &$141, $140);
  
  /* let $142 = apl$0 $141 */
  Union3 $142;
  CALL(apl$0.Type4, &$142, $141);
  
  /* let $143 = $142 pred$0 */
  Union1 $143;
  CALL($142.Type4, &$143, pred$0);
  
  /* let $144 = apl$0 $143 */
  Union3 $144;
  CALL(apl$0.Type4, &$144, $143);
  
  /* let $145 = 1 */
  Union2 $145;
  $145.Type1 = 1;
  
  /* let $146 = var$0 $145 */
  Union1 $146;
  CALL(var$0.Type4, &$146, $145);
  
  /* let $147 = $144 $146 */
  Union1 $147;
  CALL($144.Type4, &$147, $146);
  
  /* let $148 = $139 $147 */
  Union1 $148;
  CALL($139.Type4, &$148, $147);
  
  /* let sub$0 = $137 $148 */
  Union1 sub$0;
  CALL($137.Type4, &sub$0, $148);
  
  /* let church$0 = fun n$0 -> (...) */
  Union3 church$0;
  church$0.Type4 = HEAP_VALUE(church$0_Closure, {
    ._func = _church$0,
    .apl$0 = apl$0,
    .lam$0 = lam$0,
    .succ$0 = succ$0,
    .var$0 = var$0,
  });
  
  /* let $165 = 0 */
  Union2 $165;
  $165.Type1 = 0;
  
  /* let $166 = lam$0 $165 */
  Union3 $166;
  CALL(lam$0.Type4, &$166, $165);
  
  /* let $167 = 0 */
  Union2 $167;
  $167.Type1 = 0;
  
  /* let $168 = var$0 $167 */
  Union1 $168;
  CALL(var$0.Type4, &$168, $167);
  
  /* let $169 = apl$0 $168 */
  Union3 $169;
  CALL(apl$0.Type4, &$169, $168);
  
  /* let $170 = $169 succ$0 */
  Union1 $170;
  CALL($169.Type4, &$170, succ$0);
  
  /* let $171 = apl$0 $170 */
  Union3 $171;
  CALL(apl$0.Type4, &$171, $170);
  
  /* let $172 = 0 */
  Union2 $172;
  $172.Type1 = 0;
  
  /* let $173 = church$0 $172 */
  Union1 $173;
  CALL(church$0.Type4, &$173, $172);
  
  /* let $174 = $171 $173 */
  Union1 $174;
  CALL($171.Type4, &$174, $173);
  
  /* let identity$0 = $166 $174 */
  Union1 identity$0;
  CALL($166.Type4, &identity$0, $174);
  
  /* let n$1 = input */
  Union2 n$1;
  __input(&n$1.Type1);
  
  /* let $175 = apl$0 sub$0 */
  Union3 $175;
  CALL(apl$0.Type4, &$175, sub$0);
  
  /* let $176 = church$0 n$1 */
  Union1 $176;
  CALL(church$0.Type4, &$176, n$1);
  
  /* let $177 = $175 $176 */
  Union1 $177;
  CALL($175.Type4, &$177, $176);
  
  /* let $178 = apl$0 $177 */
  Union3 $178;
  CALL(apl$0.Type4, &$178, $177);
  
  /* let $179 = 1 */
  Union2 $179;
  $179.Type1 = 1;
  
  /* let $180 = n$1 - $179 */
  Union2 $180;
  $180.Type1 = n$1.Type1 - $179.Type1;
  
  /* let $181 = church$0 $180 */
  Union1 $181;
  CALL(church$0.Type4, &$181, $180);
  
  /* let one$0 = $178 $181 */
  Union1 one$0;
  CALL($178.Type4, &one$0, $181);
  
  /* let $182 = apl$0 identity$0 */
  Union3 $182;
  CALL(apl$0.Type4, &$182, identity$0);
  
  /* let $183 = $182 one$0 */
  Union1 $183;
  CALL($182.Type4, &$183, one$0);
  
  /* let $0 = eval$0 $183 */
  CALL(eval$0.Type4, &(*$0), $183);
}


void _var$0(const var$0_Closure *_clo, Union1 *restrict $1, Union2 id$0) {
  tail_call:;
  /* let $1 = {Var = id$0} */
  (*$1) = HEAP_ALLOC(sizeof(*(*$1)));
  (*$1)->tag = Union1_Type5;
  COPY(&(*$1)->Type5.Var, &id$0, sizeof(Union2));
}


void _$2(const $2_Closure *_clo, Union1 *restrict $3, Union1 body$0) {
  tail_call:;
  /* let $4 = {} */
  Union6 $4;
  
  /* let $3 = {Lam = $4; Arg = id$1; Body = body$0} */
  (*$3) = HEAP_ALLOC(sizeof(*(*$3)));
  (*$3)->tag = Union1_Type6;
  COPY(&(*$3)->Type6.Arg, &_clo->id$1, sizeof(Union2));
  COPY(&(*$3)->Type6.Body, &body$0, sizeof(Union1));
}


void _lam$0(const lam$0_Closure *_clo, Union3 *restrict $2, Union2 id$1) {
  tail_call:;
  /* let $2 = fun body$0 -> (...) */
  (*$2).Type4 = HEAP_VALUE($2_Closure, {
    ._func = _$2,
    .id$1 = id$1,
  });
}


void _$5(const $5_Closure *_clo, Union1 *restrict $6, Union1 e2$0) {
  tail_call:;
  /* let $7 = {} */
  Union7 $7;
  
  /* let $6 = {Apl = $7; Lhs = e1$0; Rhs = e2$0} */
  (*$6) = HEAP_ALLOC(sizeof(*(*$6)));
  (*$6)->tag = Union1_Type7;
  COPY(&(*$6)->Type7.Lhs, &_clo->e1$0, sizeof(Union1));
  COPY(&(*$6)->Type7.Rhs, &e2$0, sizeof(Union1));
}


void _apl$0(const apl$0_Closure *_clo, Union3 *restrict $5, Union1 e1$0) {
  tail_call:;
  /* let $5 = fun e2$0 -> (...) */
  (*$5).Type4 = HEAP_VALUE($5_Closure, {
    ._func = _$5,
    .e1$0 = e1$0,
  });
}


void _subst$0(const subst$0_Closure *_clo, Union1 *restrict $8, Union5 args$0) {
  tail_call:;
  /* let var$1 = args$0._0 */
  Union2 var$1;
  switch (args$0->tag) {
    case Union5_Type8:
      COPY(&var$1, &args$0->Type8._0, sizeof(Union2));
      break;
    case Union5_Type9:
      COPY(&var$1, &args$0->Type9._0, sizeof(Union2));
      break;
    case Union5_Type10:
      COPY(&var$1, &args$0->Type10._0, sizeof(Union2));
      break;
    case Union5_Type11:
      COPY(&var$1, &args$0->Type11._0, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let value$0 = args$0._1 */
  Union1 value$0;
  switch (args$0->tag) {
    case Union5_Type8:
      COPY(&value$0, &args$0->Type8._1, sizeof(Union1));
      break;
    case Union5_Type9:
      COPY(&value$0, &args$0->Type9._1, sizeof(Union1));
      break;
    case Union5_Type10:
      COPY(&value$0, &args$0->Type10._1, sizeof(Union1));
      break;
    case Union5_Type11:
      COPY(&value$0, &args$0->Type11._1, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let term$0 = args$0._2 */
  Union1 term$0;
  switch (args$0->tag) {
    case Union5_Type8:
      COPY(&term$0, &args$0->Type8._2, sizeof(Union1));
      break;
    case Union5_Type9:
      COPY(&term$0, &args$0->Type9._2, sizeof(Union1));
      break;
    case Union5_Type10:
      COPY(&term$0, &args$0->Type10._2, sizeof(Union1));
      break;
    case Union5_Type11:
      COPY(&term$0, &args$0->Type11._2, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $8 = match term$0 with ... */
  switch (term$0->tag) {
    case Union1_Type7:
    {
      /* let $25 = term$0.Lhs */
      Union1 $25;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$25, &term$0->Type7.Lhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $26 = {_2 = $25; _1 = value$0; _0 = var$1} */
      Union5 $26;
      $26 = HEAP_ALLOC(sizeof(*$26));
      $26->tag = Union5_Type9;
      COPY(&$26->Type9._2, &$25, sizeof(Union1));
      COPY(&$26->Type9._1, &value$0, sizeof(Union1));
      COPY(&$26->Type9._0, &var$1, sizeof(Union2));
      
      /* let $27 = subst$0 $26 */
      Union1 $27;
      _subst$0(_clo, &$27, $26);
      
      /* let $28 = apl$0 $27 */
      Union3 $28;
      CALL(_clo->apl$0.Type4, &$28, $27);
      
      /* let $29 = term$0.Rhs */
      Union1 $29;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$29, &term$0->Type7.Rhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $30 = {_2 = $29; _1 = value$0; _0 = var$1} */
      Union5 $30;
      $30 = HEAP_ALLOC(sizeof(*$30));
      $30->tag = Union5_Type10;
      COPY(&$30->Type10._2, &$29, sizeof(Union1));
      COPY(&$30->Type10._1, &value$0, sizeof(Union1));
      COPY(&$30->Type10._0, &var$1, sizeof(Union2));
      
      /* let $31 = subst$0 $30 */
      Union1 $31;
      _subst$0(_clo, &$31, $30);
      
      /* let $24 = $28 $31 */
      CALL($28.Type4, &(*$8), $31);
      break;
    }
    case Union1_Type6:
    {
      /* let $15 = term$0.Arg */
      Union2 $15;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          COPY(&$15, &term$0->Type6.Arg, sizeof(Union2));
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $16 = $15 == var$1 */
      Union4 $16;
      if ($15.Type1 == var$1.Type1) {
        $16.tag = Union4_Type2;
      }
      else {
        $16.tag = Union4_Type3;
      }
      
      /* let $14 = match $16 with ... */
      switch ($16.tag) {
        case Union4_Type3:
        {
          /* let $19 = term$0.Arg */
          Union2 $19;
          switch (term$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$19, &term$0->Type6.Arg, sizeof(Union2));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $20 = lam$0 $19 */
          Union3 $20;
          CALL(_clo->lam$0.Type4, &$20, $19);
          
          /* let $21 = term$0.Body */
          Union1 $21;
          switch (term$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$21, &term$0->Type6.Body, sizeof(Union1));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $22 = {_2 = $21; _1 = value$0; _0 = var$1} */
          Union5 $22;
          $22 = HEAP_ALLOC(sizeof(*$22));
          $22->tag = Union5_Type8;
          COPY(&$22->Type8._2, &$21, sizeof(Union1));
          COPY(&$22->Type8._1, &value$0, sizeof(Union1));
          COPY(&$22->Type8._0, &var$1, sizeof(Union2));
          
          /* let $23 = subst$0 $22 */
          Union1 $23;
          _subst$0(_clo, &$23, $22);
          
          /* let $18 = $20 $23 */
          CALL($20.Type4, &(*$8), $23);
          break;
        }
        case Union4_Type2:
        {
          /* let $17 = term$0 */
          (*(&(*$8))) = term$0;
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    case Union1_Type5:
    {
      /* let $10 = term$0.Var */
      Union2 $10;
      switch (term$0->tag) {
        case Union1_Type5:
          COPY(&$10, &term$0->Type5.Var, sizeof(Union2));
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $11 = $10 == var$1 */
      Union4 $11;
      if ($10.Type1 == var$1.Type1) {
        $11.tag = Union4_Type2;
      }
      else {
        $11.tag = Union4_Type3;
      }
      
      /* let $9 = match $11 with ... */
      switch ($11.tag) {
        case Union4_Type3:
        {
          /* let $13 = term$0 */
          (*(&(*$8))) = term$0;
          break;
        }
        case Union4_Type2:
        {
          /* let $12 = value$0 */
          (*(&(*$8))) = value$0;
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _eval$0(const eval$0_Closure *_clo, Union1 *restrict $32, Union1 term$1) {
  tail_call:;
  /* let $32 = match term$1 with ... */
  switch (term$1->tag) {
    case Union1_Type7:
    {
      /* let $35 = term$1.Lhs */
      Union1 $35;
      switch (term$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$35, &term$1->Type7.Lhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let lhs$0 = eval$0 $35 */
      Union1 lhs$0;
      _eval$0(_clo, &lhs$0, $35);
      
      /* let $36 = term$1.Rhs */
      Union1 $36;
      switch (term$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$36, &term$1->Type7.Rhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let rhs$0 = eval$0 $36 */
      Union1 rhs$0;
      _eval$0(_clo, &rhs$0, $36);
      
      /* let $34 = match lhs$0 with ... */
      switch (lhs$0->tag) {
        case Union1_Type6:
        {
          /* let $38 = lhs$0.Arg */
          Union2 $38;
          switch (lhs$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$38, &lhs$0->Type6.Arg, sizeof(Union2));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $39 = lhs$0.Body */
          Union1 $39;
          switch (lhs$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$39, &lhs$0->Type6.Body, sizeof(Union1));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $40 = {_2 = $39; _1 = rhs$0; _0 = $38} */
          Union5 $40;
          $40 = HEAP_ALLOC(sizeof(*$40));
          $40->tag = Union5_Type11;
          COPY(&$40->Type11._2, &$39, sizeof(Union1));
          COPY(&$40->Type11._1, &rhs$0, sizeof(Union1));
          COPY(&$40->Type11._0, &$38, sizeof(Union2));
          
          /* let subst_body$0 = subst$0 $40 */
          Union1 subst_body$0;
          CALL(_clo->subst$0.Type4, &subst_body$0, $40);
          
          /* let $37 = eval$0 subst_body$0 */
          term$1 = subst_body$0;
          goto tail_call;
          break;
        }
        case Union1_Type7:
        case Union1_Type5:
        {
          ABORT;
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    case Union1_Type6:
    {
      /* let $33 = term$1 */
      (*(&(*$32))) = term$1;
      break;
    }
    case Union1_Type5:
    {
      ABORT;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _church$0(const church$0_Closure *_clo, Union1 *restrict $149, Union2 n$0) {
  tail_call:;
  /* let $150 = 0 */
  Union2 $150;
  $150.Type1 = 0;
  
  /* let $151 = n$0 == $150 */
  Union4 $151;
  if (n$0.Type1 == $150.Type1) {
    $151.tag = Union4_Type2;
  }
  else {
    $151.tag = Union4_Type3;
  }
  
  /* let $149 = match $151 with ... */
  switch ($151.tag) {
    case Union4_Type3:
    {
      /* let $161 = apl$0 succ$0 */
      Union3 $161;
      CALL(_clo->apl$0.Type4, &$161, _clo->succ$0);
      
      /* let $162 = 1 */
      Union2 $162;
      $162.Type1 = 1;
      
      /* let $163 = n$0 - $162 */
      Union2 $163;
      $163.Type1 = n$0.Type1 - $162.Type1;
      
      /* let $164 = church$0 $163 */
      Union1 $164;
      _church$0(_clo, &$164, $163);
      
      /* let $160 = $161 $164 */
      CALL($161.Type4, &(*$149), $164);
      break;
    }
    case Union4_Type2:
    {
      /* let $153 = 0 */
      Union2 $153;
      $153.Type1 = 0;
      
      /* let $154 = lam$0 $153 */
      Union3 $154;
      CALL(_clo->lam$0.Type4, &$154, $153);
      
      /* let $155 = 1 */
      Union2 $155;
      $155.Type1 = 1;
      
      /* let $156 = lam$0 $155 */
      Union3 $156;
      CALL(_clo->lam$0.Type4, &$156, $155);
      
      /* let $157 = 1 */
      Union2 $157;
      $157.Type1 = 1;
      
      /* let $158 = var$0 $157 */
      Union1 $158;
      CALL(_clo->var$0.Type4, &$158, $157);
      
      /* let $159 = $156 $158 */
      Union1 $159;
      CALL($156.Type4, &$159, $158);
      
      /* let $152 = $154 $159 */
      CALL($154.Type4, &(*$149), $159);
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
