(****************************************************************************)
(*     Sail                                                                 *)
(*                                                                          *)
(*  Sail and the Sail architecture models here, comprising all files and    *)
(*  directories except the ASL-derived Sail code in the aarch64 directory,  *)
(*  are subject to the BSD two-clause licence below.                        *)
(*                                                                          *)
(*  The ASL derived parts of the ARMv8.3 specification in                   *)
(*  aarch64/no_vector and aarch64/full are copyright ARM Ltd.               *)
(*                                                                          *)
(*  Copyright (c) 2013-2021                                                 *)
(*    Kathyrn Gray                                                          *)
(*    Shaked Flur                                                           *)
(*    Stephen Kell                                                          *)
(*    Gabriel Kerneis                                                       *)
(*    Robert Norton-Wright                                                  *)
(*    Christopher Pulte                                                     *)
(*    Peter Sewell                                                          *)
(*    Alasdair Armstrong                                                    *)
(*    Brian Campbell                                                        *)
(*    Thomas Bauereiss                                                      *)
(*    Anthony Fox                                                           *)
(*    Jon French                                                            *)
(*    Dominic Mulligan                                                      *)
(*    Stephen Kell                                                          *)
(*    Mark Wassell                                                          *)
(*    Alastair Reid (Arm Ltd)                                               *)
(*                                                                          *)
(*  All rights reserved.                                                    *)
(*                                                                          *)
(*  This work was partially supported by EPSRC grant EP/K008528/1 <a        *)
(*  href="http://www.cl.cam.ac.uk/users/pes20/rems">REMS: Rigorous          *)
(*  Engineering for Mainstream Systems</a>, an ARM iCASE award, EPSRC IAA   *)
(*  KTF funding, and donations from Arm.  This project has received         *)
(*  funding from the European Research Council (ERC) under the European     *)
(*  Union’s Horizon 2020 research and innovation programme (grant           *)
(*  agreement No 789108, ELVER).                                            *)
(*                                                                          *)
(*  This software was developed by SRI International and the University of  *)
(*  Cambridge Computer Laboratory (Department of Computer Science and       *)
(*  Technology) under DARPA/AFRL contracts FA8650-18-C-7809 ("CIFV")        *)
(*  and FA8750-10-C-0237 ("CTSRD").                                         *)
(*                                                                          *)
(*  Redistribution and use in source and binary forms, with or without      *)
(*  modification, are permitted provided that the following conditions      *)
(*  are met:                                                                *)
(*  1. Redistributions of source code must retain the above copyright       *)
(*     notice, this list of conditions and the following disclaimer.        *)
(*  2. Redistributions in binary form must reproduce the above copyright    *)
(*     notice, this list of conditions and the following disclaimer in      *)
(*     the documentation and/or other materials provided with the           *)
(*     distribution.                                                        *)
(*                                                                          *)
(*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''      *)
(*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED       *)
(*  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A         *)
(*  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR     *)
(*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,            *)
(*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        *)
(*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF        *)
(*  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND     *)
(*  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,      *)
(*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT      *)
(*  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF      *)
(*  SUCH DAMAGE.                                                            *)
(****************************************************************************)

open Libsail

open Interactive.State

let opt_lean_output_dir : string option ref = ref None

let lean_options =
  [
    ( "-lean_output_dir",
      Arg.String (fun dir -> opt_lean_output_dir := Some dir),
      "<directory> set a custom directory to output generated Lean"
    );
  ]

(* TODO[javra]: Currently these are the same as the Coq rewrites, we might want to change them. *)
let lean_rewrites =
  let open Rewrites in
  [
    ("instantiate_outcomes", [String_arg "coq"]);
    ("realize_mappings", []);
    ("remove_vector_subrange_pats", []);
    ("remove_duplicate_valspecs", []);
    ("toplevel_string_append", []);
    ("pat_string_append", []);
    ("mapping_patterns", []);
    ("add_unspecified_rec", []);
    ("undefined", [Bool_arg true]);
    ("vector_string_pats_to_bit_list", []);
    ("remove_not_pats", []);
    ("remove_impossible_int_cases", []);
    ("tuple_assignments", []);
    ("vector_concat_assignments", []);
    ("simple_assignments", []);
    ("remove_vector_concat", []);
    ("remove_bitvector_pats", []);
    ("remove_numeral_pats", []);
    ("pattern_literals", [Literal_arg "lem"]);
    ("guarded_pats", []);
    (* ("register_ref_writes", rewrite_register_ref_writes); *)
    ("nexp_ids", []);
    ("split", [String_arg "execute"]);
    ("minimise_recursive_functions", []);
    ("remove_bitfield_records", []);
    ("recheck_defs", []);
    (* Put prover regstate generation after removing bitfield records,
       which has to be followed by type checking *)
    ("prover_regstate", [Bool_arg true]);
    (* ("remove_assert", rewrite_ast_remove_assert); *)
    ("move_termination_measures", []);
    ("top_sort_defs", []);
    ("const_prop_mutrec", [String_arg "coq"]);
    ("exp_lift_assign", []);
    ("early_return", []);
    (* We need to do the exhaustiveness check before merging, because it may
       introduce new wildcard clauses *)
    ("recheck_defs", []);
    ("make_cases_exhaustive", []);
    (* merge funcls before adding the measure argument so that it doesn't
       disappear into an internal pattern match *)
    ("merge_function_clauses", []);
    ("recheck_defs", []);
    ("rewrite_explicit_measure", []);
    ("rewrite_loops_with_escape_effect", []);
    ("recheck_defs", []);
    ("infer_effects", [Bool_arg true]);
    ("attach_effects", []);
    ("remove_blocks", []);
    ("attach_effects", []);
    ("letbind_effects", []);
    ("remove_e_assign", []);
    ("attach_effects", []);
    ("internal_lets", []);
    ("remove_superfluous_letbinds", []);
    ("remove_superfluous_returns", []);
    ("bit_lists_to_lits", []);
    ("toplevel_let_patterns", []);
    ("recheck_defs", []);
    ("attach_effects", []);
  ]

let output files = failwith "Lean backend not yet implemented"

let lean_target out_file { ctx; ast; effect_info; env; _ } =
  let out_file = match out_file with Some f -> f | None -> "out" in
  output [(out_file, ctx, effect_info, env, ast)]

let _ = Target.register ~name:"lean" ~options:lean_options ~rewrites:lean_rewrites ~asserts_termination:true lean_target
