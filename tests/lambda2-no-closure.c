
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
  Univ  id; /* Union3 */
  Univ  subst; /* Union2 */
} Type5;

typedef struct /* $10 */ {
  Univ  apply; /* Union2 */
  Univ  body; /* Union1 */
  Univ  eval; /* Union2 */
  Univ  id; /* Union3 */
  Univ  subst; /* Union2 */
} Type6;

typedef struct /* $40 */ {
  Univ  eval; /* Union2 */
  Univ  lhs; /* Union1 */
  Univ  rhs; /* Union1 */
  Univ  subst; /* Union2 */
} Type7;

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
  Union2 apl$0;
  Union1 self$4;
} var$3_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
  Union1 self$1;
} var$2_Closure;

typedef struct {
  Func *_func;
} var$1_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
  Union1 self$0;
} var$0_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union1 self$4;
  Union3 var$3;
} value$2_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
  Union1 self$1;
  Union3 var$2;
} value$1_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
  Union1 self$0;
  Union3 var$0;
} value$0_Closure;

typedef struct {
  Func *_func;
} self$5_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
} self$4_Closure;

typedef struct {
  Func *_func;
} self$3_Closure;

typedef struct {
  Func *_func;
} self$2_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
} self$1_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
} self$0_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union1 lhs$0;
} rhs$0_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union2 lam$0;
  Union1 succ$0;
  Union2 var$1;
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
  Union2 apl$0;
  Union2 lam$0;
  Union1 succ$0;
  Union2 var$1;
} church$0_Closure;

typedef struct {
  Func *_func;
  Union3 id$1;
  Union2 lam$0;
} body$0_Closure;

typedef struct {
  Func *_func;
  Union1 self$3;
} arg$0_Closure;

typedef struct {
  Func *_func;
} apl$0_Closure;

typedef struct {
  Func *_func;
} __main_Closure;

typedef struct {
  Func *_func;
  Union3 id$1;
  Union2 lam$0;
} $9_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
} $8_Closure;

typedef struct {
  Func *_func;
} $67_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
} $57_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union1 self$4;
  Union3 var$3;
} $42_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union1 self$4;
} $41_Closure;

typedef struct {
  Func *_func;
  Union2 apl$0;
  Union1 lhs$0;
} $39_Closure;

typedef struct {
  Func *_func;
} $38_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
  Union1 self$0;
  Union3 var$0;
} $3_Closure;

typedef struct {
  Func *_func;
  Union1 self$3;
} $29_Closure;

typedef struct {
  Func *_func;
} $28_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
} $26_Closure;

typedef struct {
  Func *_func;
  Union3 id$0;
  Union1 self$0;
} $2_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
  Union1 self$1;
  Union3 var$2;
} $12_Closure;

typedef struct {
  Func *_func;
  Union2 lam$0;
  Union1 self$1;
} $11_Closure;

Func _var$3;
Func _var$2;
Func _var$1;
Func _var$0;
Func _value$2;
Func _value$1;
Func _value$0;
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
Func _$9;
Func _$8;
Func _$67;
Func _$57;
Func _$42;
Func _$41;
Func _$39;
Func _$38;
Func _$3;
Func _$29;
Func _$28;
Func _$26;
Func _$2;
Func _$12;
Func _$11;

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
  fprintf(stream, "{id = ");
  fprint_Union3(stream, (Union3*)&value->id);
  fprintf(stream, "; subst = ");
  fprint_Union2(stream, (Union2*)&value->subst);
  fprintf(stream, "}");
}
void fprint_Type6(FILE *stream, const Type6* value) {
  fprintf(stream, "{apply = ");
  fprint_Union2(stream, (Union2*)&value->apply);
  fprintf(stream, "; body = ");
  fprint_Union1(stream, (Union1*)&value->body);
  fprintf(stream, "; eval = ");
  fprint_Union2(stream, (Union2*)&value->eval);
  fprintf(stream, "; id = ");
  fprint_Union3(stream, (Union3*)&value->id);
  fprintf(stream, "; subst = ");
  fprint_Union2(stream, (Union2*)&value->subst);
  fprintf(stream, "}");
}
void fprint_Type7(FILE *stream, const Type7* value) {
  fprintf(stream, "{eval = ");
  fprint_Union2(stream, (Union2*)&value->eval);
  fprintf(stream, "; lhs = ");
  fprint_Union1(stream, (Union1*)&value->lhs);
  fprintf(stream, "; rhs = ");
  fprint_Union1(stream, (Union1*)&value->rhs);
  fprintf(stream, "; subst = ");
  fprint_Union2(stream, (Union2*)&value->subst);
  fprintf(stream, "}");
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
  /* let var$1 = fun id$0 -> (...) */
  Union2 var$1;
  static const var$1_Closure _var$1$ = { ._func = _var$1 };
  var$1.Type4 = (Closure*)&_var$1$;
  
  /* let lam$0 = fun id$1 -> (...) */
  Union2 lam$0;
  static const lam$0_Closure _lam$0$ = { ._func = _lam$0 };
  lam$0.Type4 = (Closure*)&_lam$0$;
  
  /* let apl$0 = fun lhs$0 -> (...) */
  Union2 apl$0;
  static const apl$0_Closure _apl$0$ = { ._func = _apl$0 };
  apl$0.Type4 = (Closure*)&_apl$0$;
  
  /* let $68 = 1 */
  Union3 $68;
  $68.Type1 = 1;
  
  /* let $69 = lam$0 $68 */
  Union2 $69;
  CALL(lam$0.Type4, &$69, $68);
  
  /* let $70 = 2 */
  Union3 $70;
  $70.Type1 = 2;
  
  /* let $71 = lam$0 $70 */
  Union2 $71;
  CALL(lam$0.Type4, &$71, $70);
  
  /* let $72 = 3 */
  Union3 $72;
  $72.Type1 = 3;
  
  /* let $73 = lam$0 $72 */
  Union2 $73;
  CALL(lam$0.Type4, &$73, $72);
  
  /* let $74 = 2 */
  Union3 $74;
  $74.Type1 = 2;
  
  /* let $75 = var$1 $74 */
  Union1 $75;
  CALL(var$1.Type4, &$75, $74);
  
  /* let $76 = apl$0 $75 */
  Union2 $76;
  CALL(apl$0.Type4, &$76, $75);
  
  /* let $77 = 1 */
  Union3 $77;
  $77.Type1 = 1;
  
  /* let $78 = var$1 $77 */
  Union1 $78;
  CALL(var$1.Type4, &$78, $77);
  
  /* let $79 = apl$0 $78 */
  Union2 $79;
  CALL(apl$0.Type4, &$79, $78);
  
  /* let $80 = 2 */
  Union3 $80;
  $80.Type1 = 2;
  
  /* let $81 = var$1 $80 */
  Union1 $81;
  CALL(var$1.Type4, &$81, $80);
  
  /* let $82 = $79 $81 */
  Union1 $82;
  CALL($79.Type4, &$82, $81);
  
  /* let $83 = apl$0 $82 */
  Union2 $83;
  CALL(apl$0.Type4, &$83, $82);
  
  /* let $84 = 3 */
  Union3 $84;
  $84.Type1 = 3;
  
  /* let $85 = var$1 $84 */
  Union1 $85;
  CALL(var$1.Type4, &$85, $84);
  
  /* let $86 = $83 $85 */
  Union1 $86;
  CALL($83.Type4, &$86, $85);
  
  /* let $87 = $76 $86 */
  Union1 $87;
  CALL($76.Type4, &$87, $86);
  
  /* let $88 = $73 $87 */
  Union1 $88;
  CALL($73.Type4, &$88, $87);
  
  /* let $89 = $71 $88 */
  Union1 $89;
  CALL($71.Type4, &$89, $88);
  
  /* let succ$0 = $69 $89 */
  Union1 succ$0;
  CALL($69.Type4, &succ$0, $89);
  
  /* let $90 = 1 */
  Union3 $90;
  $90.Type1 = 1;
  
  /* let $91 = lam$0 $90 */
  Union2 $91;
  CALL(lam$0.Type4, &$91, $90);
  
  /* let $92 = 2 */
  Union3 $92;
  $92.Type1 = 2;
  
  /* let $93 = lam$0 $92 */
  Union2 $93;
  CALL(lam$0.Type4, &$93, $92);
  
  /* let $94 = 1 */
  Union3 $94;
  $94.Type1 = 1;
  
  /* let $95 = var$1 $94 */
  Union1 $95;
  CALL(var$1.Type4, &$95, $94);
  
  /* let $96 = apl$0 $95 */
  Union2 $96;
  CALL(apl$0.Type4, &$96, $95);
  
  /* let $97 = $96 succ$0 */
  Union1 $97;
  CALL($96.Type4, &$97, succ$0);
  
  /* let $98 = apl$0 $97 */
  Union2 $98;
  CALL(apl$0.Type4, &$98, $97);
  
  /* let $99 = 2 */
  Union3 $99;
  $99.Type1 = 2;
  
  /* let $100 = var$1 $99 */
  Union1 $100;
  CALL(var$1.Type4, &$100, $99);
  
  /* let $101 = $98 $100 */
  Union1 $101;
  CALL($98.Type4, &$101, $100);
  
  /* let $102 = $93 $101 */
  Union1 $102;
  CALL($93.Type4, &$102, $101);
  
  /* let add$0 = $91 $102 */
  Union1 add$0;
  CALL($91.Type4, &add$0, $102);
  
  /* let $103 = 1 */
  Union3 $103;
  $103.Type1 = 1;
  
  /* let $104 = lam$0 $103 */
  Union2 $104;
  CALL(lam$0.Type4, &$104, $103);
  
  /* let $105 = 2 */
  Union3 $105;
  $105.Type1 = 2;
  
  /* let $106 = lam$0 $105 */
  Union2 $106;
  CALL(lam$0.Type4, &$106, $105);
  
  /* let $107 = 3 */
  Union3 $107;
  $107.Type1 = 3;
  
  /* let $108 = lam$0 $107 */
  Union2 $108;
  CALL(lam$0.Type4, &$108, $107);
  
  /* let $109 = 1 */
  Union3 $109;
  $109.Type1 = 1;
  
  /* let $110 = var$1 $109 */
  Union1 $110;
  CALL(var$1.Type4, &$110, $109);
  
  /* let $111 = apl$0 $110 */
  Union2 $111;
  CALL(apl$0.Type4, &$111, $110);
  
  /* let $112 = 2 */
  Union3 $112;
  $112.Type1 = 2;
  
  /* let $113 = var$1 $112 */
  Union1 $113;
  CALL(var$1.Type4, &$113, $112);
  
  /* let $114 = apl$0 $113 */
  Union2 $114;
  CALL(apl$0.Type4, &$114, $113);
  
  /* let $115 = 3 */
  Union3 $115;
  $115.Type1 = 3;
  
  /* let $116 = var$1 $115 */
  Union1 $116;
  CALL(var$1.Type4, &$116, $115);
  
  /* let $117 = $114 $116 */
  Union1 $117;
  CALL($114.Type4, &$117, $116);
  
  /* let $118 = $111 $117 */
  Union1 $118;
  CALL($111.Type4, &$118, $117);
  
  /* let $119 = $108 $118 */
  Union1 $119;
  CALL($108.Type4, &$119, $118);
  
  /* let $120 = $106 $119 */
  Union1 $120;
  CALL($106.Type4, &$120, $119);
  
  /* let mul$0 = $104 $120 */
  Union1 mul$0;
  CALL($104.Type4, &mul$0, $120);
  
  /* let $121 = 1 */
  Union3 $121;
  $121.Type1 = 1;
  
  /* let $122 = lam$0 $121 */
  Union2 $122;
  CALL(lam$0.Type4, &$122, $121);
  
  /* let $123 = 2 */
  Union3 $123;
  $123.Type1 = 2;
  
  /* let $124 = lam$0 $123 */
  Union2 $124;
  CALL(lam$0.Type4, &$124, $123);
  
  /* let $125 = 3 */
  Union3 $125;
  $125.Type1 = 3;
  
  /* let $126 = lam$0 $125 */
  Union2 $126;
  CALL(lam$0.Type4, &$126, $125);
  
  /* let $127 = 1 */
  Union3 $127;
  $127.Type1 = 1;
  
  /* let $128 = var$1 $127 */
  Union1 $128;
  CALL(var$1.Type4, &$128, $127);
  
  /* let $129 = apl$0 $128 */
  Union2 $129;
  CALL(apl$0.Type4, &$129, $128);
  
  /* let $130 = 4 */
  Union3 $130;
  $130.Type1 = 4;
  
  /* let $131 = lam$0 $130 */
  Union2 $131;
  CALL(lam$0.Type4, &$131, $130);
  
  /* let $132 = 5 */
  Union3 $132;
  $132.Type1 = 5;
  
  /* let $133 = lam$0 $132 */
  Union2 $133;
  CALL(lam$0.Type4, &$133, $132);
  
  /* let $134 = 5 */
  Union3 $134;
  $134.Type1 = 5;
  
  /* let $135 = var$1 $134 */
  Union1 $135;
  CALL(var$1.Type4, &$135, $134);
  
  /* let $136 = apl$0 $135 */
  Union2 $136;
  CALL(apl$0.Type4, &$136, $135);
  
  /* let $137 = 4 */
  Union3 $137;
  $137.Type1 = 4;
  
  /* let $138 = var$1 $137 */
  Union1 $138;
  CALL(var$1.Type4, &$138, $137);
  
  /* let $139 = apl$0 $138 */
  Union2 $139;
  CALL(apl$0.Type4, &$139, $138);
  
  /* let $140 = 2 */
  Union3 $140;
  $140.Type1 = 2;
  
  /* let $141 = var$1 $140 */
  Union1 $141;
  CALL(var$1.Type4, &$141, $140);
  
  /* let $142 = $139 $141 */
  Union1 $142;
  CALL($139.Type4, &$142, $141);
  
  /* let $143 = $136 $142 */
  Union1 $143;
  CALL($136.Type4, &$143, $142);
  
  /* let $144 = $133 $143 */
  Union1 $144;
  CALL($133.Type4, &$144, $143);
  
  /* let $145 = $131 $144 */
  Union1 $145;
  CALL($131.Type4, &$145, $144);
  
  /* let $146 = $129 $145 */
  Union1 $146;
  CALL($129.Type4, &$146, $145);
  
  /* let $147 = apl$0 $146 */
  Union2 $147;
  CALL(apl$0.Type4, &$147, $146);
  
  /* let $148 = 6 */
  Union3 $148;
  $148.Type1 = 6;
  
  /* let $149 = lam$0 $148 */
  Union2 $149;
  CALL(lam$0.Type4, &$149, $148);
  
  /* let $150 = 3 */
  Union3 $150;
  $150.Type1 = 3;
  
  /* let $151 = var$1 $150 */
  Union1 $151;
  CALL(var$1.Type4, &$151, $150);
  
  /* let $152 = $149 $151 */
  Union1 $152;
  CALL($149.Type4, &$152, $151);
  
  /* let $153 = $147 $152 */
  Union1 $153;
  CALL($147.Type4, &$153, $152);
  
  /* let $154 = apl$0 $153 */
  Union2 $154;
  CALL(apl$0.Type4, &$154, $153);
  
  /* let $155 = 6 */
  Union3 $155;
  $155.Type1 = 6;
  
  /* let $156 = lam$0 $155 */
  Union2 $156;
  CALL(lam$0.Type4, &$156, $155);
  
  /* let $157 = 6 */
  Union3 $157;
  $157.Type1 = 6;
  
  /* let $158 = var$1 $157 */
  Union1 $158;
  CALL(var$1.Type4, &$158, $157);
  
  /* let $159 = $156 $158 */
  Union1 $159;
  CALL($156.Type4, &$159, $158);
  
  /* let $160 = $154 $159 */
  Union1 $160;
  CALL($154.Type4, &$160, $159);
  
  /* let $161 = $126 $160 */
  Union1 $161;
  CALL($126.Type4, &$161, $160);
  
  /* let $162 = $124 $161 */
  Union1 $162;
  CALL($124.Type4, &$162, $161);
  
  /* let pred$0 = $122 $162 */
  Union1 pred$0;
  CALL($122.Type4, &pred$0, $162);
  
  /* let $163 = 1 */
  Union3 $163;
  $163.Type1 = 1;
  
  /* let $164 = lam$0 $163 */
  Union2 $164;
  CALL(lam$0.Type4, &$164, $163);
  
  /* let $165 = 2 */
  Union3 $165;
  $165.Type1 = 2;
  
  /* let $166 = lam$0 $165 */
  Union2 $166;
  CALL(lam$0.Type4, &$166, $165);
  
  /* let $167 = 2 */
  Union3 $167;
  $167.Type1 = 2;
  
  /* let $168 = var$1 $167 */
  Union1 $168;
  CALL(var$1.Type4, &$168, $167);
  
  /* let $169 = apl$0 $168 */
  Union2 $169;
  CALL(apl$0.Type4, &$169, $168);
  
  /* let $170 = $169 pred$0 */
  Union1 $170;
  CALL($169.Type4, &$170, pred$0);
  
  /* let $171 = apl$0 $170 */
  Union2 $171;
  CALL(apl$0.Type4, &$171, $170);
  
  /* let $172 = 1 */
  Union3 $172;
  $172.Type1 = 1;
  
  /* let $173 = var$1 $172 */
  Union1 $173;
  CALL(var$1.Type4, &$173, $172);
  
  /* let $174 = $171 $173 */
  Union1 $174;
  CALL($171.Type4, &$174, $173);
  
  /* let $175 = $166 $174 */
  Union1 $175;
  CALL($166.Type4, &$175, $174);
  
  /* let sub$0 = $164 $175 */
  Union1 sub$0;
  CALL($164.Type4, &sub$0, $175);
  
  /* let church$0 = fun n$0 -> (...) */
  Union2 church$0;
  church$0.Type4 = HEAP_VALUE(church$0_Closure, {
    ._func = _church$0,
    .apl$0 = apl$0,
    .lam$0 = lam$0,
    .succ$0 = succ$0,
    .var$1 = var$1,
  });
  
  /* let $192 = 0 */
  Union3 $192;
  $192.Type1 = 0;
  
  /* let $193 = lam$0 $192 */
  Union2 $193;
  CALL(lam$0.Type4, &$193, $192);
  
  /* let $194 = 0 */
  Union3 $194;
  $194.Type1 = 0;
  
  /* let $195 = var$1 $194 */
  Union1 $195;
  CALL(var$1.Type4, &$195, $194);
  
  /* let $196 = apl$0 $195 */
  Union2 $196;
  CALL(apl$0.Type4, &$196, $195);
  
  /* let $197 = $196 succ$0 */
  Union1 $197;
  CALL($196.Type4, &$197, succ$0);
  
  /* let $198 = apl$0 $197 */
  Union2 $198;
  CALL(apl$0.Type4, &$198, $197);
  
  /* let $199 = 0 */
  Union3 $199;
  $199.Type1 = 0;
  
  /* let $200 = church$0 $199 */
  Union1 $200;
  CALL(church$0.Type4, &$200, $199);
  
  /* let $201 = $198 $200 */
  Union1 $201;
  CALL($198.Type4, &$201, $200);
  
  /* let identity$0 = $193 $201 */
  Union1 identity$0;
  CALL($193.Type4, &identity$0, $201);
  
  /* let n$1 = input */
  Union3 n$1;
  __input(&n$1.Type1);
  
  /* let $202 = apl$0 identity$0 */
  Union2 $202;
  CALL(apl$0.Type4, &$202, identity$0);
  
  /* let $203 = apl$0 sub$0 */
  Union2 $203;
  CALL(apl$0.Type4, &$203, sub$0);
  
  /* let $204 = church$0 n$1 */
  Union1 $204;
  CALL(church$0.Type4, &$204, n$1);
  
  /* let $205 = $203 $204 */
  Union1 $205;
  CALL($203.Type4, &$205, $204);
  
  /* let $206 = apl$0 $205 */
  Union2 $206;
  CALL(apl$0.Type4, &$206, $205);
  
  /* let $207 = 1 */
  Union3 $207;
  $207.Type1 = 1;
  
  /* let $208 = n$1 - $207 */
  Union3 $208;
  $208.Type1 = n$1.Type1 - $207.Type1;
  
  /* let $209 = church$0 $208 */
  Union1 $209;
  CALL(church$0.Type4, &$209, $208);
  
  /* let $210 = $206 $209 */
  Union1 $210;
  CALL($206.Type4, &$210, $209);
  
  /* let one$0 = $202 $210 */
  Union1 one$0;
  CALL($202.Type4, &one$0, $210);
  
  /* let $211 = one$0.eval */
  Union2 $211;
  switch (one$0->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$211, &one$0->Type6.eval, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$211, &one$0->Type7.eval, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $0 = $211 one$0 */
  CALL($211.Type4, &(*$0), one$0);
}


void _$3(const $3_Closure *_clo, Union1 *restrict $4, Union1 value$0) {
  tail_call:;
  /* let $5 = var$0 == id$0 */
  Union4 $5;
  if (_clo->var$0.Type1 == _clo->id$0.Type1) {
    $5.tag = Union4_Type2;
  }
  else {
    $5.tag = Union4_Type3;
  }
  
  /* let $4 = match $5 with ... */
  switch ($5.tag) {
    case Union4_Type3:
    {
      /* let $7 = self$0 */
      (*(&(*$4))) = _clo->self$0;
      break;
    }
    case Union4_Type2:
    {
      /* let $6 = value$0 */
      (*(&(*$4))) = value$0;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _$2(const $2_Closure *_clo, Union2 *restrict $3, Union3 var$0) {
  tail_call:;
  /* let $3 = fun value$0 -> (...) */
  (*$3).Type4 = HEAP_VALUE($3_Closure, {
    ._func = _$3,
    .id$0 = _clo->id$0,
    .self$0 = _clo->self$0,
    .var$0 = var$0,
  });
}


void _$8(const $8_Closure *_clo, Union2 *restrict $2, Union1 self$0) {
  tail_call:;
  /* let $2 = fun var$0 -> (...) */
  (*$2).Type4 = HEAP_VALUE($2_Closure, {
    ._func = _$2,
    .id$0 = _clo->id$0,
    .self$0 = self$0,
  });
}


void _var$1(const var$1_Closure *_clo, Union1 *restrict $1, Union3 id$0) {
  tail_call:;
  /* let $8 = fun self$0 -> (...) */
  Union2 $8;
  $8.Type4 = HEAP_VALUE($8_Closure, {
    ._func = _$8,
    .id$0 = id$0,
  });
  
  /* let $1 = {id = id$0; subst = $8} */
  (*$1) = HEAP_ALLOC(sizeof(*(*$1)));
  (*$1)->tag = Union1_Type5;
  COPY(&(*$1)->Type5.id, &id$0, sizeof(Union3));
  COPY(&(*$1)->Type5.subst, &$8, sizeof(Union2));
}


void _$12(const $12_Closure *_clo, Union1 *restrict $13, Union1 value$1) {
  tail_call:;
  /* let $14 = self$1.id */
  Union3 $14;
  switch (_clo->self$1->tag) {
    case Union1_Type5:
      COPY(&$14, &_clo->self$1->Type5.id, sizeof(Union3));
      break;
    case Union1_Type6:
      COPY(&$14, &_clo->self$1->Type6.id, sizeof(Union3));
      break;
    case Union1_Type7:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $15 = var$2 == $14 */
  Union4 $15;
  if (_clo->var$2.Type1 == $14.Type1) {
    $15.tag = Union4_Type2;
  }
  else {
    $15.tag = Union4_Type3;
  }
  
  /* let $13 = match $15 with ... */
  switch ($15.tag) {
    case Union4_Type3:
    {
      /* let $18 = self$1.id */
      Union3 $18;
      switch (_clo->self$1->tag) {
        case Union1_Type5:
          COPY(&$18, &_clo->self$1->Type5.id, sizeof(Union3));
          break;
        case Union1_Type6:
          COPY(&$18, &_clo->self$1->Type6.id, sizeof(Union3));
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $19 = lam$0 $18 */
      Union2 $19;
      CALL(_clo->lam$0.Type4, &$19, $18);
      
      /* let $20 = self$1.body */
      Union1 $20;
      switch (_clo->self$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          COPY(&$20, &_clo->self$1->Type6.body, sizeof(Union1));
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $21 = $20.subst */
      Union2 $21;
      switch ($20->tag) {
        case Union1_Type5:
          COPY(&$21, &$20->Type5.subst, sizeof(Union2));
          break;
        case Union1_Type6:
          COPY(&$21, &$20->Type6.subst, sizeof(Union2));
          break;
        case Union1_Type7:
          COPY(&$21, &$20->Type7.subst, sizeof(Union2));
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $22 = self$1.body */
      Union1 $22;
      switch (_clo->self$1->tag) {
        case Union1_Type5:
          ABORT;
          break;
        case Union1_Type6:
          COPY(&$22, &_clo->self$1->Type6.body, sizeof(Union1));
          break;
        case Union1_Type7:
          ABORT;
          break;
        default:
          UNREACHABLE;
      }
      
      /* let $23 = $21 $22 */
      Union2 $23;
      CALL($21.Type4, &$23, $22);
      
      /* let $24 = $23 var$2 */
      Union2 $24;
      CALL($23.Type4, &$24, _clo->var$2);
      
      /* let $25 = $24 value$1 */
      Union1 $25;
      CALL($24.Type4, &$25, value$1);
      
      /* let $17 = $19 $25 */
      CALL($19.Type4, &(*$13), $25);
      break;
    }
    case Union4_Type2:
    {
      /* let $16 = self$1 */
      (*(&(*$13))) = _clo->self$1;
      break;
    }
    default:
      UNREACHABLE;
  }
}


void _$11(const $11_Closure *_clo, Union2 *restrict $12, Union3 var$2) {
  tail_call:;
  /* let $12 = fun value$1 -> (...) */
  (*$12).Type4 = HEAP_VALUE($12_Closure, {
    ._func = _$12,
    .lam$0 = _clo->lam$0,
    .self$1 = _clo->self$1,
    .var$2 = var$2,
  });
}


void _$26(const $26_Closure *_clo, Union2 *restrict $11, Union1 self$1) {
  tail_call:;
  /* let $11 = fun var$2 -> (...) */
  (*$11).Type4 = HEAP_VALUE($11_Closure, {
    ._func = _$11,
    .lam$0 = _clo->lam$0,
    .self$1 = self$1,
  });
}


void _$28(const $28_Closure *_clo, Union1 *restrict $27, Union1 self$2) {
  tail_call:;
  /* let $27 = self$2 */
  (*(&(*$27))) = self$2;
}


void _$29(const $29_Closure *_clo, Union1 *restrict $30, Union1 arg$0) {
  tail_call:;
  /* let $31 = self$3.body */
  Union1 $31;
  switch (_clo->self$3->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$31, &_clo->self$3->Type6.body, sizeof(Union1));
      break;
    case Union1_Type7:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $32 = $31.subst */
  Union2 $32;
  switch ($31->tag) {
    case Union1_Type5:
      COPY(&$32, &$31->Type5.subst, sizeof(Union2));
      break;
    case Union1_Type6:
      COPY(&$32, &$31->Type6.subst, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$32, &$31->Type7.subst, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $33 = self$3.body */
  Union1 $33;
  switch (_clo->self$3->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$33, &_clo->self$3->Type6.body, sizeof(Union1));
      break;
    case Union1_Type7:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $34 = $32 $33 */
  Union2 $34;
  CALL($32.Type4, &$34, $33);
  
  /* let $35 = self$3.id */
  Union3 $35;
  switch (_clo->self$3->tag) {
    case Union1_Type5:
      COPY(&$35, &_clo->self$3->Type5.id, sizeof(Union3));
      break;
    case Union1_Type6:
      COPY(&$35, &_clo->self$3->Type6.id, sizeof(Union3));
      break;
    case Union1_Type7:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $36 = $34 $35 */
  Union2 $36;
  CALL($34.Type4, &$36, $35);
  
  /* let body$1 = $36 arg$0 */
  Union1 body$1;
  CALL($36.Type4, &body$1, arg$0);
  
  /* let $37 = body$1.eval */
  Union2 $37;
  switch (body$1->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$37, &body$1->Type6.eval, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$37, &body$1->Type7.eval, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $30 = $37 body$1 */
  CALL($37.Type4, &(*$30), body$1);
}


void _$38(const $38_Closure *_clo, Union2 *restrict $29, Union1 self$3) {
  tail_call:;
  /* let $29 = fun arg$0 -> (...) */
  (*$29).Type4 = HEAP_VALUE($29_Closure, {
    ._func = _$29,
    .self$3 = self$3,
  });
}


void _$9(const $9_Closure *_clo, Union1 *restrict $10, Union1 body$0) {
  tail_call:;
  /* let $26 = fun self$1 -> (...) */
  Union2 $26;
  $26.Type4 = HEAP_VALUE($26_Closure, {
    ._func = _$26,
    .lam$0 = _clo->lam$0,
  });
  
  /* let $28 = fun self$2 -> (...) */
  Union2 $28;
  static const $28_Closure _$28$ = { ._func = _$28 };
  $28.Type4 = (Closure*)&_$28$;
  
  /* let $38 = fun self$3 -> (...) */
  Union2 $38;
  static const $38_Closure _$38$ = { ._func = _$38 };
  $38.Type4 = (Closure*)&_$38$;
  
  /* let $10 = {id = id$1; body = body$0; subst = $26; eval = $28; apply = $38} */
  (*$10) = HEAP_ALLOC(sizeof(*(*$10)));
  (*$10)->tag = Union1_Type6;
  COPY(&(*$10)->Type6.id, &_clo->id$1, sizeof(Union3));
  COPY(&(*$10)->Type6.body, &body$0, sizeof(Union1));
  COPY(&(*$10)->Type6.subst, &$26, sizeof(Union2));
  COPY(&(*$10)->Type6.eval, &$28, sizeof(Union2));
  COPY(&(*$10)->Type6.apply, &$38, sizeof(Union2));
}


void _lam$0(const lam$0_Closure *_clo, Union2 *restrict $9, Union3 id$1) {
  tail_call:;
  /* let $9 = fun body$0 -> (...) */
  (*$9).Type4 = HEAP_VALUE($9_Closure, {
    ._func = _$9,
    .id$1 = id$1,
    .lam$0 = UNTAGGED(Union2, Type4, (const Closure*)_clo),
  });
}


void _$42(const $42_Closure *_clo, Union1 *restrict $43, Union1 value$2) {
  tail_call:;
  /* let $44 = self$4.lhs */
  Union1 $44;
  switch (_clo->self$4->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$44, &_clo->self$4->Type7.lhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $45 = $44.subst */
  Union2 $45;
  switch ($44->tag) {
    case Union1_Type5:
      COPY(&$45, &$44->Type5.subst, sizeof(Union2));
      break;
    case Union1_Type6:
      COPY(&$45, &$44->Type6.subst, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$45, &$44->Type7.subst, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $46 = self$4.lhs */
  Union1 $46;
  switch (_clo->self$4->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$46, &_clo->self$4->Type7.lhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $47 = $45 $46 */
  Union2 $47;
  CALL($45.Type4, &$47, $46);
  
  /* let $48 = $47 var$3 */
  Union2 $48;
  CALL($47.Type4, &$48, _clo->var$3);
  
  /* let $49 = $48 value$2 */
  Union1 $49;
  CALL($48.Type4, &$49, value$2);
  
  /* let $50 = apl$0 $49 */
  Union2 $50;
  CALL(_clo->apl$0.Type4, &$50, $49);
  
  /* let $51 = self$4.rhs */
  Union1 $51;
  switch (_clo->self$4->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$51, &_clo->self$4->Type7.rhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $52 = $51.subst */
  Union2 $52;
  switch ($51->tag) {
    case Union1_Type5:
      COPY(&$52, &$51->Type5.subst, sizeof(Union2));
      break;
    case Union1_Type6:
      COPY(&$52, &$51->Type6.subst, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$52, &$51->Type7.subst, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $53 = self$4.rhs */
  Union1 $53;
  switch (_clo->self$4->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$53, &_clo->self$4->Type7.rhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $54 = $52 $53 */
  Union2 $54;
  CALL($52.Type4, &$54, $53);
  
  /* let $55 = $54 var$3 */
  Union2 $55;
  CALL($54.Type4, &$55, _clo->var$3);
  
  /* let $56 = $55 value$2 */
  Union1 $56;
  CALL($55.Type4, &$56, value$2);
  
  /* let $43 = $50 $56 */
  CALL($50.Type4, &(*$43), $56);
}


void _$41(const $41_Closure *_clo, Union2 *restrict $42, Union3 var$3) {
  tail_call:;
  /* let $42 = fun value$2 -> (...) */
  (*$42).Type4 = HEAP_VALUE($42_Closure, {
    ._func = _$42,
    .apl$0 = _clo->apl$0,
    .self$4 = _clo->self$4,
    .var$3 = var$3,
  });
}


void _$57(const $57_Closure *_clo, Union2 *restrict $41, Union1 self$4) {
  tail_call:;
  /* let $41 = fun var$3 -> (...) */
  (*$41).Type4 = HEAP_VALUE($41_Closure, {
    ._func = _$41,
    .apl$0 = _clo->apl$0,
    .self$4 = self$4,
  });
}


void _$67(const $67_Closure *_clo, Union1 *restrict $58, Union1 self$5) {
  tail_call:;
  /* let $59 = self$5.lhs */
  Union1 $59;
  switch (self$5->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$59, &self$5->Type7.lhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $60 = $59.eval */
  Union2 $60;
  switch ($59->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$60, &$59->Type6.eval, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$60, &$59->Type7.eval, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $61 = self$5.lhs */
  Union1 $61;
  switch (self$5->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$61, &self$5->Type7.lhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let lhs$1 = $60 $61 */
  Union1 lhs$1;
  CALL($60.Type4, &lhs$1, $61);
  
  /* let $62 = self$5.rhs */
  Union1 $62;
  switch (self$5->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$62, &self$5->Type7.rhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $63 = $62.eval */
  Union2 $63;
  switch ($62->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$63, &$62->Type6.eval, sizeof(Union2));
      break;
    case Union1_Type7:
      COPY(&$63, &$62->Type7.eval, sizeof(Union2));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $64 = self$5.rhs */
  Union1 $64;
  switch (self$5->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      ABORT;
      break;
    case Union1_Type7:
      COPY(&$64, &self$5->Type7.rhs, sizeof(Union1));
      break;
    default:
      UNREACHABLE;
  }
  
  /* let rhs$1 = $63 $64 */
  Union1 rhs$1;
  CALL($63.Type4, &rhs$1, $64);
  
  /* let $65 = lhs$1.apply */
  Union2 $65;
  switch (lhs$1->tag) {
    case Union1_Type5:
      ABORT;
      break;
    case Union1_Type6:
      COPY(&$65, &lhs$1->Type6.apply, sizeof(Union2));
      break;
    case Union1_Type7:
      ABORT;
      break;
    default:
      UNREACHABLE;
  }
  
  /* let $66 = $65 lhs$1 */
  Union2 $66;
  CALL($65.Type4, &$66, lhs$1);
  
  /* let $58 = $66 rhs$1 */
  CALL($66.Type4, &(*$58), rhs$1);
}


void _$39(const $39_Closure *_clo, Union1 *restrict $40, Union1 rhs$0) {
  tail_call:;
  /* let $57 = fun self$4 -> (...) */
  Union2 $57;
  $57.Type4 = HEAP_VALUE($57_Closure, {
    ._func = _$57,
    .apl$0 = _clo->apl$0,
  });
  
  /* let $67 = fun self$5 -> (...) */
  Union2 $67;
  static const $67_Closure _$67$ = { ._func = _$67 };
  $67.Type4 = (Closure*)&_$67$;
  
  /* let $40 = {lhs = lhs$0; rhs = rhs$0; subst = $57; eval = $67} */
  (*$40) = HEAP_ALLOC(sizeof(*(*$40)));
  (*$40)->tag = Union1_Type7;
  COPY(&(*$40)->Type7.lhs, &_clo->lhs$0, sizeof(Union1));
  COPY(&(*$40)->Type7.rhs, &rhs$0, sizeof(Union1));
  COPY(&(*$40)->Type7.subst, &$57, sizeof(Union2));
  COPY(&(*$40)->Type7.eval, &$67, sizeof(Union2));
}


void _apl$0(const apl$0_Closure *_clo, Union2 *restrict $39, Union1 lhs$0) {
  tail_call:;
  /* let $39 = fun rhs$0 -> (...) */
  (*$39).Type4 = HEAP_VALUE($39_Closure, {
    ._func = _$39,
    .apl$0 = UNTAGGED(Union2, Type4, (const Closure*)_clo),
    .lhs$0 = lhs$0,
  });
}


void _church$0(const church$0_Closure *_clo, Union1 *restrict $176, Union3 n$0) {
  tail_call:;
  /* let $177 = 0 */
  Union3 $177;
  $177.Type1 = 0;
  
  /* let $178 = n$0 == $177 */
  Union4 $178;
  if (n$0.Type1 == $177.Type1) {
    $178.tag = Union4_Type2;
  }
  else {
    $178.tag = Union4_Type3;
  }
  
  /* let $176 = match $178 with ... */
  switch ($178.tag) {
    case Union4_Type3:
    {
      /* let $188 = apl$0 succ$0 */
      Union2 $188;
      CALL(_clo->apl$0.Type4, &$188, _clo->succ$0);
      
      /* let $189 = 1 */
      Union3 $189;
      $189.Type1 = 1;
      
      /* let $190 = n$0 - $189 */
      Union3 $190;
      $190.Type1 = n$0.Type1 - $189.Type1;
      
      /* let $191 = church$0 $190 */
      Union1 $191;
      _church$0(_clo, &$191, $190);
      
      /* let $187 = $188 $191 */
      CALL($188.Type4, &(*$176), $191);
      break;
    }
    case Union4_Type2:
    {
      /* let $180 = 0 */
      Union3 $180;
      $180.Type1 = 0;
      
      /* let $181 = lam$0 $180 */
      Union2 $181;
      CALL(_clo->lam$0.Type4, &$181, $180);
      
      /* let $182 = 1 */
      Union3 $182;
      $182.Type1 = 1;
      
      /* let $183 = lam$0 $182 */
      Union2 $183;
      CALL(_clo->lam$0.Type4, &$183, $182);
      
      /* let $184 = 1 */
      Union3 $184;
      $184.Type1 = 1;
      
      /* let $185 = var$1 $184 */
      Union1 $185;
      CALL(_clo->var$1.Type4, &$185, $184);
      
      /* let $186 = $183 $185 */
      Union1 $186;
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
