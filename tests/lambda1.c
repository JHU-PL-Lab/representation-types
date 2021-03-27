
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
  Empty Lam; /* Union5 */
} Type6;

typedef struct /* $6 */ {
  Empty Apl; /* Union6 */
  Univ  Lhs; /* Union1 */
  Univ  Rhs; /* Union1 */
} Type7;

typedef struct /* $4 */ {
} Type8;

typedef struct /* $7 */ {
} Type9;

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

typedef struct { Type8 Type8; }  Union5;
typedef struct { Type9 Type9; }  Union6;
typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
} var$1_Closure;

typedef struct {
  Func *_func;
} var$0_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union3 subst$0;
  Union2 var$1;
} value$0_Closure;

typedef struct {
  Func *_func;
  Union3 subst$0;
} term$1_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union3 subst$0;
  Union1 value$0;
  Union2 var$1;
} term$0_Closure;

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
} apl$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union3 subst$0;
  Union1 value$0;
  Union2 var$1;
} $9_Closure;

typedef struct {
  Func *_func;
  Union3 apl$0;
  Union3 lam$0;
  Union3 subst$0;
  Union2 var$1;
} $8_Closure;

typedef struct {
  Func *_func;
  Union1 e1$0;
} $5_Closure;

typedef struct {
  Func *_func;
  Union2 id$1;
} $2_Closure;

Func _var$1;
Func _var$0;
Func _value$0;
Func _term$1;
Func _term$0;
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
Func _apl$0;
Func ___main;
Func _$9;
Func _$8;
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
  fprint_Union5(stream, (Union5*)&value->Lam);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{Apl = ");
  fprint_Union6(stream, (Union6*)&value->Apl);
  fprintf(stream, "; Lhs = ");
  fprint_Union1(stream, (Union1*)&value->Lhs);
  fprintf(stream, "; Rhs = ");
  fprint_Union1(stream, (Union1*)&value->Rhs);
  fprintf(stream, "}");
}
void fprint_Type8(FILE *stream, const Type8* value) {
  fprintf(stream, "{}");
}
void fprint_Type9(FILE *stream, const Type9* value) {
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
  fprint_Type8(stream, &value->Type8);
}
void fprint_Union6(FILE *stream, const Union6* value) {
  fprint_Type9(stream, &value->Type9);
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
  
  /* let subst$0 = fun var$1 -> (...) */
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
  
  /* let $47 = 1 */
  Union2 $47;
  $47.Type1 = 1;
  
  /* let $48 = lam$0 $47 */
  Union3 $48;
  CALL(lam$0.Type4, &$48, $47);
  
  /* let $49 = 2 */
  Union2 $49;
  $49.Type1 = 2;
  
  /* let $50 = lam$0 $49 */
  Union3 $50;
  CALL(lam$0.Type4, &$50, $49);
  
  /* let $51 = 3 */
  Union2 $51;
  $51.Type1 = 3;
  
  /* let $52 = lam$0 $51 */
  Union3 $52;
  CALL(lam$0.Type4, &$52, $51);
  
  /* let $53 = 2 */
  Union2 $53;
  $53.Type1 = 2;
  
  /* let $54 = var$0 $53 */
  Union1 $54;
  CALL(var$0.Type4, &$54, $53);
  
  /* let $55 = apl$0 $54 */
  Union3 $55;
  CALL(apl$0.Type4, &$55, $54);
  
  /* let $56 = 1 */
  Union2 $56;
  $56.Type1 = 1;
  
  /* let $57 = var$0 $56 */
  Union1 $57;
  CALL(var$0.Type4, &$57, $56);
  
  /* let $58 = apl$0 $57 */
  Union3 $58;
  CALL(apl$0.Type4, &$58, $57);
  
  /* let $59 = 2 */
  Union2 $59;
  $59.Type1 = 2;
  
  /* let $60 = var$0 $59 */
  Union1 $60;
  CALL(var$0.Type4, &$60, $59);
  
  /* let $61 = $58 $60 */
  Union1 $61;
  CALL($58.Type4, &$61, $60);
  
  /* let $62 = apl$0 $61 */
  Union3 $62;
  CALL(apl$0.Type4, &$62, $61);
  
  /* let $63 = 3 */
  Union2 $63;
  $63.Type1 = 3;
  
  /* let $64 = var$0 $63 */
  Union1 $64;
  CALL(var$0.Type4, &$64, $63);
  
  /* let $65 = $62 $64 */
  Union1 $65;
  CALL($62.Type4, &$65, $64);
  
  /* let $66 = $55 $65 */
  Union1 $66;
  CALL($55.Type4, &$66, $65);
  
  /* let $67 = $52 $66 */
  Union1 $67;
  CALL($52.Type4, &$67, $66);
  
  /* let $68 = $50 $67 */
  Union1 $68;
  CALL($50.Type4, &$68, $67);
  
  /* let succ$0 = $48 $68 */
  Union1 succ$0;
  CALL($48.Type4, &succ$0, $68);
  
  /* let $69 = 1 */
  Union2 $69;
  $69.Type1 = 1;
  
  /* let $70 = lam$0 $69 */
  Union3 $70;
  CALL(lam$0.Type4, &$70, $69);
  
  /* let $71 = 2 */
  Union2 $71;
  $71.Type1 = 2;
  
  /* let $72 = lam$0 $71 */
  Union3 $72;
  CALL(lam$0.Type4, &$72, $71);
  
  /* let $73 = 1 */
  Union2 $73;
  $73.Type1 = 1;
  
  /* let $74 = var$0 $73 */
  Union1 $74;
  CALL(var$0.Type4, &$74, $73);
  
  /* let $75 = apl$0 $74 */
  Union3 $75;
  CALL(apl$0.Type4, &$75, $74);
  
  /* let $76 = $75 succ$0 */
  Union1 $76;
  CALL($75.Type4, &$76, succ$0);
  
  /* let $77 = apl$0 $76 */
  Union3 $77;
  CALL(apl$0.Type4, &$77, $76);
  
  /* let $78 = 2 */
  Union2 $78;
  $78.Type1 = 2;
  
  /* let $79 = var$0 $78 */
  Union1 $79;
  CALL(var$0.Type4, &$79, $78);
  
  /* let $80 = $77 $79 */
  Union1 $80;
  CALL($77.Type4, &$80, $79);
  
  /* let $81 = $72 $80 */
  Union1 $81;
  CALL($72.Type4, &$81, $80);
  
  /* let add$0 = $70 $81 */
  Union1 add$0;
  CALL($70.Type4, &add$0, $81);
  
  /* let $82 = 1 */
  Union2 $82;
  $82.Type1 = 1;
  
  /* let $83 = lam$0 $82 */
  Union3 $83;
  CALL(lam$0.Type4, &$83, $82);
  
  /* let $84 = 2 */
  Union2 $84;
  $84.Type1 = 2;
  
  /* let $85 = lam$0 $84 */
  Union3 $85;
  CALL(lam$0.Type4, &$85, $84);
  
  /* let $86 = 3 */
  Union2 $86;
  $86.Type1 = 3;
  
  /* let $87 = lam$0 $86 */
  Union3 $87;
  CALL(lam$0.Type4, &$87, $86);
  
  /* let $88 = 1 */
  Union2 $88;
  $88.Type1 = 1;
  
  /* let $89 = var$0 $88 */
  Union1 $89;
  CALL(var$0.Type4, &$89, $88);
  
  /* let $90 = apl$0 $89 */
  Union3 $90;
  CALL(apl$0.Type4, &$90, $89);
  
  /* let $91 = 2 */
  Union2 $91;
  $91.Type1 = 2;
  
  /* let $92 = var$0 $91 */
  Union1 $92;
  CALL(var$0.Type4, &$92, $91);
  
  /* let $93 = apl$0 $92 */
  Union3 $93;
  CALL(apl$0.Type4, &$93, $92);
  
  /* let $94 = 3 */
  Union2 $94;
  $94.Type1 = 3;
  
  /* let $95 = var$0 $94 */
  Union1 $95;
  CALL(var$0.Type4, &$95, $94);
  
  /* let $96 = $93 $95 */
  Union1 $96;
  CALL($93.Type4, &$96, $95);
  
  /* let $97 = $90 $96 */
  Union1 $97;
  CALL($90.Type4, &$97, $96);
  
  /* let $98 = $87 $97 */
  Union1 $98;
  CALL($87.Type4, &$98, $97);
  
  /* let $99 = $85 $98 */
  Union1 $99;
  CALL($85.Type4, &$99, $98);
  
  /* let mul$0 = $83 $99 */
  Union1 mul$0;
  CALL($83.Type4, &mul$0, $99);
  
  /* let $100 = 1 */
  Union2 $100;
  $100.Type1 = 1;
  
  /* let $101 = lam$0 $100 */
  Union3 $101;
  CALL(lam$0.Type4, &$101, $100);
  
  /* let $102 = 2 */
  Union2 $102;
  $102.Type1 = 2;
  
  /* let $103 = lam$0 $102 */
  Union3 $103;
  CALL(lam$0.Type4, &$103, $102);
  
  /* let $104 = 3 */
  Union2 $104;
  $104.Type1 = 3;
  
  /* let $105 = lam$0 $104 */
  Union3 $105;
  CALL(lam$0.Type4, &$105, $104);
  
  /* let $106 = 1 */
  Union2 $106;
  $106.Type1 = 1;
  
  /* let $107 = var$0 $106 */
  Union1 $107;
  CALL(var$0.Type4, &$107, $106);
  
  /* let $108 = apl$0 $107 */
  Union3 $108;
  CALL(apl$0.Type4, &$108, $107);
  
  /* let $109 = 4 */
  Union2 $109;
  $109.Type1 = 4;
  
  /* let $110 = lam$0 $109 */
  Union3 $110;
  CALL(lam$0.Type4, &$110, $109);
  
  /* let $111 = 5 */
  Union2 $111;
  $111.Type1 = 5;
  
  /* let $112 = lam$0 $111 */
  Union3 $112;
  CALL(lam$0.Type4, &$112, $111);
  
  /* let $113 = 5 */
  Union2 $113;
  $113.Type1 = 5;
  
  /* let $114 = var$0 $113 */
  Union1 $114;
  CALL(var$0.Type4, &$114, $113);
  
  /* let $115 = apl$0 $114 */
  Union3 $115;
  CALL(apl$0.Type4, &$115, $114);
  
  /* let $116 = 4 */
  Union2 $116;
  $116.Type1 = 4;
  
  /* let $117 = var$0 $116 */
  Union1 $117;
  CALL(var$0.Type4, &$117, $116);
  
  /* let $118 = apl$0 $117 */
  Union3 $118;
  CALL(apl$0.Type4, &$118, $117);
  
  /* let $119 = 2 */
  Union2 $119;
  $119.Type1 = 2;
  
  /* let $120 = var$0 $119 */
  Union1 $120;
  CALL(var$0.Type4, &$120, $119);
  
  /* let $121 = $118 $120 */
  Union1 $121;
  CALL($118.Type4, &$121, $120);
  
  /* let $122 = $115 $121 */
  Union1 $122;
  CALL($115.Type4, &$122, $121);
  
  /* let $123 = $112 $122 */
  Union1 $123;
  CALL($112.Type4, &$123, $122);
  
  /* let $124 = $110 $123 */
  Union1 $124;
  CALL($110.Type4, &$124, $123);
  
  /* let $125 = $108 $124 */
  Union1 $125;
  CALL($108.Type4, &$125, $124);
  
  /* let $126 = apl$0 $125 */
  Union3 $126;
  CALL(apl$0.Type4, &$126, $125);
  
  /* let $127 = 6 */
  Union2 $127;
  $127.Type1 = 6;
  
  /* let $128 = lam$0 $127 */
  Union3 $128;
  CALL(lam$0.Type4, &$128, $127);
  
  /* let $129 = 3 */
  Union2 $129;
  $129.Type1 = 3;
  
  /* let $130 = var$0 $129 */
  Union1 $130;
  CALL(var$0.Type4, &$130, $129);
  
  /* let $131 = $128 $130 */
  Union1 $131;
  CALL($128.Type4, &$131, $130);
  
  /* let $132 = $126 $131 */
  Union1 $132;
  CALL($126.Type4, &$132, $131);
  
  /* let $133 = apl$0 $132 */
  Union3 $133;
  CALL(apl$0.Type4, &$133, $132);
  
  /* let $134 = 6 */
  Union2 $134;
  $134.Type1 = 6;
  
  /* let $135 = lam$0 $134 */
  Union3 $135;
  CALL(lam$0.Type4, &$135, $134);
  
  /* let $136 = 6 */
  Union2 $136;
  $136.Type1 = 6;
  
  /* let $137 = var$0 $136 */
  Union1 $137;
  CALL(var$0.Type4, &$137, $136);
  
  /* let $138 = $135 $137 */
  Union1 $138;
  CALL($135.Type4, &$138, $137);
  
  /* let $139 = $133 $138 */
  Union1 $139;
  CALL($133.Type4, &$139, $138);
  
  /* let $140 = $105 $139 */
  Union1 $140;
  CALL($105.Type4, &$140, $139);
  
  /* let $141 = $103 $140 */
  Union1 $141;
  CALL($103.Type4, &$141, $140);
  
  /* let pred$0 = $101 $141 */
  Union1 pred$0;
  CALL($101.Type4, &pred$0, $141);
  
  /* let $142 = 1 */
  Union2 $142;
  $142.Type1 = 1;
  
  /* let $143 = lam$0 $142 */
  Union3 $143;
  CALL(lam$0.Type4, &$143, $142);
  
  /* let $144 = 2 */
  Union2 $144;
  $144.Type1 = 2;
  
  /* let $145 = lam$0 $144 */
  Union3 $145;
  CALL(lam$0.Type4, &$145, $144);
  
  /* let $146 = 2 */
  Union2 $146;
  $146.Type1 = 2;
  
  /* let $147 = var$0 $146 */
  Union1 $147;
  CALL(var$0.Type4, &$147, $146);
  
  /* let $148 = apl$0 $147 */
  Union3 $148;
  CALL(apl$0.Type4, &$148, $147);
  
  /* let $149 = $148 pred$0 */
  Union1 $149;
  CALL($148.Type4, &$149, pred$0);
  
  /* let $150 = apl$0 $149 */
  Union3 $150;
  CALL(apl$0.Type4, &$150, $149);
  
  /* let $151 = 1 */
  Union2 $151;
  $151.Type1 = 1;
  
  /* let $152 = var$0 $151 */
  Union1 $152;
  CALL(var$0.Type4, &$152, $151);
  
  /* let $153 = $150 $152 */
  Union1 $153;
  CALL($150.Type4, &$153, $152);
  
  /* let $154 = $145 $153 */
  Union1 $154;
  CALL($145.Type4, &$154, $153);
  
  /* let sub$0 = $143 $154 */
  Union1 sub$0;
  CALL($143.Type4, &sub$0, $154);
  
  /* let church$0 = fun n$0 -> (...) */
  Union3 church$0;
  church$0.Type4 = HEAP_VALUE(church$0_Closure, {
    ._func = _church$0,
    .apl$0 = apl$0,
    .lam$0 = lam$0,
    .succ$0 = succ$0,
    .var$0 = var$0,
  });
  
  /* let $171 = 0 */
  Union2 $171;
  $171.Type1 = 0;
  
  /* let $172 = lam$0 $171 */
  Union3 $172;
  CALL(lam$0.Type4, &$172, $171);
  
  /* let $173 = 0 */
  Union2 $173;
  $173.Type1 = 0;
  
  /* let $174 = var$0 $173 */
  Union1 $174;
  CALL(var$0.Type4, &$174, $173);
  
  /* let $175 = apl$0 $174 */
  Union3 $175;
  CALL(apl$0.Type4, &$175, $174);
  
  /* let $176 = $175 succ$0 */
  Union1 $176;
  CALL($175.Type4, &$176, succ$0);
  
  /* let $177 = apl$0 $176 */
  Union3 $177;
  CALL(apl$0.Type4, &$177, $176);
  
  /* let $178 = 0 */
  Union2 $178;
  $178.Type1 = 0;
  
  /* let $179 = church$0 $178 */
  Union1 $179;
  CALL(church$0.Type4, &$179, $178);
  
  /* let $180 = $177 $179 */
  Union1 $180;
  CALL($177.Type4, &$180, $179);
  
  /* let identity$0 = $172 $180 */
  Union1 identity$0;
  CALL($172.Type4, &identity$0, $180);
  
  /* let n$1 = input */
  Union2 n$1;
  __input(&n$1.Type1);
  
  /* let $181 = apl$0 sub$0 */
  Union3 $181;
  CALL(apl$0.Type4, &$181, sub$0);
  
  /* let $182 = church$0 n$1 */
  Union1 $182;
  CALL(church$0.Type4, &$182, n$1);
  
  /* let $183 = $181 $182 */
  Union1 $183;
  CALL($181.Type4, &$183, $182);
  
  /* let $184 = apl$0 $183 */
  Union3 $184;
  CALL(apl$0.Type4, &$184, $183);
  
  /* let $185 = 1 */
  Union2 $185;
  $185.Type1 = 1;
  
  /* let $186 = n$1 - $185 */
  Union2 $186;
  $186.Type1 = n$1.Type1 - $185.Type1;
  
  /* let $187 = church$0 $186 */
  Union1 $187;
  CALL(church$0.Type4, &$187, $186);
  
  /* let one$0 = $184 $187 */
  Union1 one$0;
  CALL($184.Type4, &one$0, $187);
  
  /* let $188 = apl$0 identity$0 */
  Union3 $188;
  CALL(apl$0.Type4, &$188, identity$0);
  
  /* let $189 = $188 one$0 */
  Union1 $189;
  CALL($188.Type4, &$189, one$0);
  
  /* let $0 = eval$0 $189 */
  CALL(eval$0.Type4, &(*$0), $189);
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
  Union5 $4;
  
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
  Union6 $7;
  
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


void _$9(const $9_Closure *_clo, Union1 *restrict $10, Union1 term$0) {
  tail_call:;
  /* let $10 = match term$0 with ... */
  switch (term$0->tag) {
    case Union1_Type7:
    {
      /* let $28 = subst$0 var$1 */
      Union3 $28;
      CALL(_clo->subst$0.Type4, &$28, _clo->var$1);
      
      /* let $29 = $28 value$0 */
      Union3 $29;
      CALL($28.Type4, &$29, _clo->value$0);
      
      /* let $30 = term$0.Lhs */
      Union1 $30;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$30, &term$0->Type7.Lhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $31 = $29 $30 */
      Union1 $31;
      CALL($29.Type4, &$31, $30);
      
      /* let $32 = apl$0 $31 */
      Union3 $32;
      CALL(_clo->apl$0.Type4, &$32, $31);
      
      /* let $33 = subst$0 var$1 */
      Union3 $33;
      CALL(_clo->subst$0.Type4, &$33, _clo->var$1);
      
      /* let $34 = $33 value$0 */
      Union3 $34;
      CALL($33.Type4, &$34, _clo->value$0);
      
      /* let $35 = term$0.Rhs */
      Union1 $35;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$35, &term$0->Type7.Rhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $36 = $34 $35 */
      Union1 $36;
      CALL($34.Type4, &$36, $35);
      
      /* let $27 = $32 $36 */
      CALL($32.Type4, &(*$10), $36);
      break;
    }
    case Union1_Type6:
    {
      /* let $17 = term$0.Arg */
      Union2 $17;
      switch (term$0->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          COPY(&$17, &term$0->Type6.Arg, sizeof(Union2));
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $18 = $17 == var$1 */
      Union4 $18;
      if ($17.Type1 == _clo->var$1.Type1) {
        $18.tag = Union4_Type2;
      }
      else {
        $18.tag = Union4_Type3;
      }
      
      /* let $16 = match $18 with ... */
      switch ($18.tag) {
        case Union4_Type3:
        {
          /* let $21 = term$0.Arg */
          Union2 $21;
          switch (term$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$21, &term$0->Type6.Arg, sizeof(Union2));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $22 = lam$0 $21 */
          Union3 $22;
          CALL(_clo->lam$0.Type4, &$22, $21);
          
          /* let $23 = subst$0 var$1 */
          Union3 $23;
          CALL(_clo->subst$0.Type4, &$23, _clo->var$1);
          
          /* let $24 = $23 value$0 */
          Union3 $24;
          CALL($23.Type4, &$24, _clo->value$0);
          
          /* let $25 = term$0.Body */
          Union1 $25;
          switch (term$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$25, &term$0->Type6.Body, sizeof(Union1));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $26 = $24 $25 */
          Union1 $26;
          CALL($24.Type4, &$26, $25);
          
          /* let $20 = $22 $26 */
          CALL($22.Type4, &(*$10), $26);
          break;
        }
        case Union4_Type2:
        {
          /* let $19 = term$0 */
          (*(&(*$10))) = term$0;
          break;
        }
        default:
          UNREACHABLE;
      }
      break;
    }
    case Union1_Type5:
    {
      /* let $12 = term$0.Var */
      Union2 $12;
      switch (term$0->tag) {
        case Union1_Type5:
          COPY(&$12, &term$0->Type5.Var, sizeof(Union2));
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
      
      /* let $13 = $12 == var$1 */
      Union4 $13;
      if ($12.Type1 == _clo->var$1.Type1) {
        $13.tag = Union4_Type2;
      }
      else {
        $13.tag = Union4_Type3;
      }
      
      /* let $11 = match $13 with ... */
      switch ($13.tag) {
        case Union4_Type3:
        {
          /* let $15 = term$0 */
          (*(&(*$10))) = term$0;
          break;
        }
        case Union4_Type2:
        {
          /* let $14 = value$0 */
          (*(&(*$10))) = _clo->value$0;
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


void _$8(const $8_Closure *_clo, Union3 *restrict $9, Union1 value$0) {
  tail_call:;
  /* let $9 = fun term$0 -> (...) */
  (*$9).Type4 = HEAP_VALUE($9_Closure, {
    ._func = _$9,
    .apl$0 = _clo->apl$0,
    .lam$0 = _clo->lam$0,
    .subst$0 = _clo->subst$0,
    .value$0 = value$0,
    .var$1 = _clo->var$1,
  });
}


void _subst$0(const subst$0_Closure *_clo, Union3 *restrict $8, Union2 var$1) {
  tail_call:;
  /* let $8 = fun value$0 -> (...) */
  (*$8).Type4 = HEAP_VALUE($8_Closure, {
    ._func = _$8,
    .apl$0 = _clo->apl$0,
    .lam$0 = _clo->lam$0,
    .subst$0 = UNTAGGED(Union3, Type4, (const Closure*)_clo),
    .var$1 = var$1,
  });
}


void _eval$0(const eval$0_Closure *_clo, Union1 *restrict $37, Union1 term$1) {
  tail_call:;
  /* let $37 = match term$1 with ... */
  switch (term$1->tag) {
    case Union1_Type7:
    {
      /* let $40 = term$1.Lhs */
      Union1 $40;
      switch (term$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$40, &term$1->Type7.Lhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let lhs$0 = eval$0 $40 */
      Union1 lhs$0;
      _eval$0(_clo, &lhs$0, $40);
      
      /* let $41 = term$1.Rhs */
      Union1 $41;
      switch (term$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          ABORT;
          break;
        case Union1_Type7:
          COPY(&$41, &term$1->Type7.Rhs, sizeof(Union1));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let rhs$0 = eval$0 $41 */
      Union1 rhs$0;
      _eval$0(_clo, &rhs$0, $41);
      
      /* let $39 = match lhs$0 with ... */
      switch (lhs$0->tag) {
        case Union1_Type6:
        {
          /* let $43 = lhs$0.Arg */
          Union2 $43;
          switch (lhs$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$43, &lhs$0->Type6.Arg, sizeof(Union2));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let $44 = subst$0 $43 */
          Union3 $44;
          CALL(_clo->subst$0.Type4, &$44, $43);
          
          /* let $45 = $44 rhs$0 */
          Union3 $45;
          CALL($44.Type4, &$45, rhs$0);
          
          /* let $46 = lhs$0.Body */
          Union1 $46;
          switch (lhs$0->tag) {
            case Union1_Type5:
              ABORT;
              break;
            case Union1_Type6:
              COPY(&$46, &lhs$0->Type6.Body, sizeof(Union1));
              break;
            case Union1_Type7:
              ABORT;
              break;
            default:
              UNREACHABLE;
          }
          
          /* let subst_body$0 = $45 $46 */
          Union1 subst_body$0;
          CALL($45.Type4, &subst_body$0, $46);
          
          /* let $42 = eval$0 subst_body$0 */
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
      /* let $38 = term$1 */
      (*(&(*$37))) = term$1;
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


void _church$0(const church$0_Closure *_clo, Union1 *restrict $155, Union2 n$0) {
  tail_call:;
  /* let $156 = 0 */
  Union2 $156;
  $156.Type1 = 0;
  
  /* let $157 = n$0 == $156 */
  Union4 $157;
  if (n$0.Type1 == $156.Type1) {
    $157.tag = Union4_Type2;
  }
  else {
    $157.tag = Union4_Type3;
  }
  
  /* let $155 = match $157 with ... */
  switch ($157.tag) {
    case Union4_Type3:
    {
      /* let $167 = apl$0 succ$0 */
      Union3 $167;
      CALL(_clo->apl$0.Type4, &$167, _clo->succ$0);
      
      /* let $168 = 1 */
      Union2 $168;
      $168.Type1 = 1;
      
      /* let $169 = n$0 - $168 */
      Union2 $169;
      $169.Type1 = n$0.Type1 - $168.Type1;
      
      /* let $170 = church$0 $169 */
      Union1 $170;
      _church$0(_clo, &$170, $169);
      
      /* let $166 = $167 $170 */
      CALL($167.Type4, &(*$155), $170);
      break;
    }
    case Union4_Type2:
    {
      /* let $159 = 0 */
      Union2 $159;
      $159.Type1 = 0;
      
      /* let $160 = lam$0 $159 */
      Union3 $160;
      CALL(_clo->lam$0.Type4, &$160, $159);
      
      /* let $161 = 1 */
      Union2 $161;
      $161.Type1 = 1;
      
      /* let $162 = lam$0 $161 */
      Union3 $162;
      CALL(_clo->lam$0.Type4, &$162, $161);
      
      /* let $163 = 1 */
      Union2 $163;
      $163.Type1 = 1;
      
      /* let $164 = var$0 $163 */
      Union1 $164;
      CALL(_clo->var$0.Type4, &$164, $163);
      
      /* let $165 = $162 $164 */
      Union1 $165;
      CALL($162.Type4, &$165, $164);
      
      /* let $158 = $160 $165 */
      CALL($160.Type4, &(*$155), $165);
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
