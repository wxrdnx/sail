(* generated by Ott 0.24 from: l2_parse.ott *)


type text = string

type l =
  | Unknown
  | Int of string * l option
  | Range of Lexing.position * Lexing.position

type 'a annot = l * 'a

exception Parse_error_locn of l * string


type x = text (* identifier *)
type ix = text (* infix identifier *)

type 
base_kind_aux =  (* base kind *)
   BK_type (* kind of types *)
 | BK_nat (* kind of natural number size expressions *)
 | BK_order (* kind of vector order specifications *)
 | BK_effect (* kind of effect sets *)


type 
base_kind = 
   BK_aux of base_kind_aux * l


type 
kid_aux =  (* identifiers with kind, ticked to differntiate from program variables *)
   Var of x


type 
base_effect_aux =  (* effect *)
   BE_rreg (* read register *)
 | BE_wreg (* write register *)
 | BE_rmem (* read memory *)
 | BE_wmem (* write memory *)
 | BE_undef (* undefined-instruction exception *)
 | BE_unspec (* unspecified values *)
 | BE_nondet (* nondeterminism from intra-instruction parallelism *)


type 
id_aux =  (* Identifier *)
   Id of x
 | DeIid of x (* remove infix status *)


type 
kind_aux =  (* kinds *)
   K_kind of (base_kind) list


type 
kid = 
   Kid_aux of kid_aux * l


type 
base_effect = 
   BE_aux of base_effect_aux * l


type 
id = 
   Id_aux of id_aux * l


type 
kind = 
   K_aux of kind_aux * l


type 
atyp_aux =  (* expressions of all kinds, to be translated to types, nats, orders, and effects after parsing *)
   ATyp_id of id (* identifier *)
 | ATyp_var of kid (* ticked variable *)
 | ATyp_constant of int (* constant *)
 | ATyp_times of atyp * atyp (* product *)
 | ATyp_sum of atyp * atyp (* sum *)
 | ATyp_exp of atyp (* exponential *)
 | ATyp_neg of atyp (* Internal (but not M as I want a datatype constructor) negative nexp *)
 | ATyp_inc (* increasing (little-endian) *)
 | ATyp_dec (* decreasing (big-endian) *)
 | ATyp_set of (base_effect) list (* effect set *)
 | ATyp_fn of atyp * atyp * atyp (* Function type (first-order only in user code), last atyp is an effect *)
 | ATyp_tup of (atyp) list (* Tuple type *)
 | ATyp_app of id * (atyp) list (* type constructor application *)

and atyp = 
   ATyp_aux of atyp_aux * l


type 
kinded_id_aux =  (* optionally kind-annotated identifier *)
   KOpt_none of kid (* identifier *)
 | KOpt_kind of kind * kid (* kind-annotated variable *)


type 
n_constraint_aux =  (* constraint over kind $_$ *)
   NC_fixed of atyp * atyp
 | NC_bounded_ge of atyp * atyp
 | NC_bounded_le of atyp * atyp
 | NC_nat_set_bounded of kid * (int) list


type 
kinded_id = 
   KOpt_aux of kinded_id_aux * l


type 
n_constraint = 
   NC_aux of n_constraint_aux * l


type 
quant_item_aux =  (* Either a kinded identifier or a nexp constraint for a typquant *)
   QI_id of kinded_id (* An optionally kinded identifier *)
 | QI_const of n_constraint (* A constraint for this type *)


type 
quant_item = 
   QI_aux of quant_item_aux * l


type 
typquant_aux =  (* type quantifiers and constraints *)
   TypQ_tq of (quant_item) list
 | TypQ_no_forall (* sugar, omitting quantifier and constraints *)


type 
lit_aux =  (* Literal constant *)
   L_unit (* $() : _$ *)
 | L_zero (* $_ : _$ *)
 | L_one (* $_ : _$ *)
 | L_true (* $_ : _$ *)
 | L_false (* $_ : _$ *)
 | L_num of int (* natural number constant *)
 | L_hex of string (* bit vector constant, C-style *)
 | L_bin of string (* bit vector constant, C-style *)
 | L_undef (* undefined value *)
 | L_string of string (* string constant *)


type 
typquant = 
   TypQ_aux of typquant_aux * l


type 
lit = 
   L_aux of lit_aux * l


type 
typschm_aux =  (* type scheme *)
   TypSchm_ts of typquant * atyp


type 
pat_aux =  (* Pattern *)
   P_lit of lit (* literal constant pattern *)
 | P_wild (* wildcard *)
 | P_as of pat * id (* named pattern *)
 | P_typ of atyp * pat (* typed pattern *)
 | P_id of id (* identifier *)
 | P_app of id * (pat) list (* union constructor pattern *)
 | P_record of (fpat) list * bool (* struct pattern *)
 | P_vector of (pat) list (* vector pattern *)
 | P_vector_indexed of ((int * pat)) list (* vector pattern (with explicit indices) *)
 | P_vector_concat of (pat) list (* concatenated vector pattern *)
 | P_tup of (pat) list (* tuple pattern *)
 | P_list of (pat) list (* list pattern *)

and pat = 
   P_aux of pat_aux * l

and fpat_aux =  (* Field pattern *)
   FP_Fpat of id * pat

and fpat = 
   FP_aux of fpat_aux * l


type 
typschm = 
   TypSchm_aux of typschm_aux * l


type 
exp_aux =  (* Expression *)
   E_block of (exp) list (* block (parsing conflict with structs?) *)
 | E_id of id (* identifier *)
 | E_lit of lit (* literal constant *)
 | E_cast of atyp * exp (* cast *)
 | E_app of id * (exp) list (* function application *)
 | E_app_infix of exp * id * exp (* infix function application *)
 | E_tuple of (exp) list (* tuple *)
 | E_if of exp * exp * exp (* conditional *)
 | E_for of id * exp * exp * exp * atyp * exp (* loop *)
 | E_vector of (exp) list (* vector (indexed from 0) *)
 | E_vector_indexed of ((int * exp)) list (* vector (indexed consecutively) *)
 | E_vector_access of exp * exp (* vector access *)
 | E_vector_subrange of exp * exp * exp (* subvector extraction *)
 | E_vector_update of exp * exp * exp (* vector functional update *)
 | E_vector_update_subrange of exp * exp * exp * exp (* vector subrange update (with vector) *)
 | E_list of (exp) list (* list *)
 | E_cons of exp * exp (* cons *)
 | E_record of fexps (* struct *)
 | E_record_update of exp * (exp) list (* functional update of struct *)
 | E_field of exp * id (* field projection from struct *)
 | E_case of exp * (pexp) list (* pattern matching *)
 | E_let of letbind * exp (* let expression *)
 | E_assign of exp * exp (* imperative assignment *)

and exp = 
   E_aux of exp_aux * l

and fexp_aux =  (* Field-expression *)
   FE_Fexp of id * exp

and fexp = 
   FE_aux of fexp_aux * l

and fexps_aux =  (* Field-expression list *)
   FES_Fexps of (fexp) list * bool

and fexps = 
   FES_aux of fexps_aux * l

and pexp_aux =  (* Pattern match *)
   Pat_exp of pat * exp

and pexp = 
   Pat_aux of pexp_aux * l

and letbind_aux =  (* Let binding *)
   LB_val_explicit of typschm * pat * exp (* value binding, explicit type (pat must be total) *)
 | LB_val_implicit of pat * exp (* value binding, implicit type (pat must be total) *)

and letbind = 
   LB_aux of letbind_aux * l


type 
type_union_aux =  (* Type union constructors *)
   Tu_id of id
 | Tu_ty_id of atyp * id


type 
name_scm_opt_aux =  (* Optional variable-naming-scheme specification for variables of defined type *)
   Name_sect_none
 | Name_sect_some of string


type 
effect_opt_aux =  (* Optional effect annotation for functions *)
   Effect_opt_pure (* sugar for empty effect set *)
 | Effect_opt_effect of atyp


type 
tannot_opt_aux =  (* Optional type annotation for functions *)
   Typ_annot_opt_none
 | Typ_annot_opt_some of typquant * atyp


type 
rec_opt_aux =  (* Optional recursive annotation for functions *)
   Rec_nonrec (* non-recursive *)
 | Rec_rec (* recursive *)


type 
funcl_aux =  (* Function clause *)
   FCL_Funcl of id * pat * exp


type 
index_range_aux =  (* index specification, for bitfields in register types *)
   BF_single of int (* single index *)
 | BF_range of int * int (* index range *)
 | BF_concat of index_range * index_range (* concatenation of index ranges *)

and index_range = 
   BF_aux of index_range_aux * l


type 
type_union = 
   Tu_aux of type_union_aux * l


type 
name_scm_opt = 
   Name_sect_aux of name_scm_opt_aux * l


type 
effect_opt = 
   Effect_opt_aux of effect_opt_aux * l


type 
tannot_opt = 
   Typ_annot_opt_aux of tannot_opt_aux * l


type 
rec_opt = 
   Rec_aux of rec_opt_aux * l


type 
funcl = 
   FCL_aux of funcl_aux * l


type 
type_def_aux =  (* Type definition body *)
   TD_abbrev of id * name_scm_opt * typschm (* type abbreviation *)
 | TD_record of id * name_scm_opt * typquant * ((atyp * id)) list * bool (* struct type definition *)
 | TD_variant of id * name_scm_opt * typquant * (type_union) list * bool (* union type definition *)
 | TD_enum of id * name_scm_opt * (id) list * bool (* enumeration type definition *)
 | TD_register of id * atyp * atyp * ((index_range * id)) list (* register mutable bitfield type definition *)


type 
default_typing_spec_aux =  (* Default kinding or typing assumption *)
   DT_kind of base_kind * kid
 | DT_typ of typschm * id


type 
scattered_def_aux =  (* Function and type union definitions that can be spread across
         a file. Each one must end in $_$ *)
   SD_scattered_function of rec_opt * tannot_opt * effect_opt * id (* scattered function definition header *)
 | SD_scattered_funcl of funcl (* scattered function definition clause *)
 | SD_scattered_variant of id * name_scm_opt * typquant (* scattered union definition header *)
 | SD_scattered_unioncl of id * type_union (* scattered union definition member *)
 | SD_scattered_end of id (* scattered definition end *)


type 
val_spec_aux =  (* Value type specification *)
   VS_val_spec of typschm * id
 | VS_extern_no_rename of typschm * id
 | VS_extern_spec of typschm * id * string


type 
fundef_aux =  (* Function definition *)
   FD_function of rec_opt * tannot_opt * effect_opt * (funcl) list


type 
type_def = 
   TD_aux of type_def_aux * l


type 
default_typing_spec = 
   DT_aux of default_typing_spec_aux * l


type 
scattered_def = 
   SD_aux of scattered_def_aux * l


type 
val_spec = 
   VS_aux of val_spec_aux * l


type 
fundef = 
   FD_aux of fundef_aux * l


type 
def_aux =  (* Top-level definition *)
   DEF_type of type_def (* type definition *)
 | DEF_fundef of fundef (* function definition *)
 | DEF_val of letbind (* value definition *)
 | DEF_spec of val_spec (* top-level type constraint *)
 | DEF_default of default_typing_spec (* default kind and type assumptions *)
 | DEF_scattered of scattered_def (* scattered definition *)
 | DEF_reg_dec of atyp * id (* register declaration *)


type 
def = 
   DEF_aux of def_aux * l


type 
defs =  (* Definition sequence *)
   Defs of (def) list


type 
lexp_aux =  (* lvalue expression *)
   LEXP_id of id (* identifier *)
 | LEXP_mem of id * (exp) list
 | LEXP_vector of lexp * exp (* vector element *)
 | LEXP_vector_range of lexp * exp * exp (* subvector *)
 | LEXP_field of lexp * id (* struct field *)

and lexp = 
   LEXP_aux of lexp_aux * l



