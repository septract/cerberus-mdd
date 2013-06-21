(* generated by Ott 0.21.2 from: AilTypesAux_.ott *)

Require Import ZArith.

Require Import AilTypes.
Require Import Implementation.
Require Import Range_defns.

Local Open Scope Z.

(* defns JisSigned *)
Inductive signed : implementation -> integerType -> Prop :=    (* defn isSigned *)
 | Signed_Int : forall (P:implementation) (ibt:integerBaseType),
     signed P (Signed ibt)
 | Signed_Char : forall (P:implementation),
     Implementation.signed P Char = true  ->
     signed P Char.

Inductive unqualified : qualifiers -> Set :=
  | Unqualified  : unqualified no_qualifiers.

(** definitions *)

(* defns JisInteger *)
Inductive integer : ctype -> Set :=    (* defn isInteger *)
 | Integer_Integer : forall (it:integerType),
     integer (Basic (Integer it)).
(** definitions *)

(* defns JisVoid *)
Inductive void : ctype -> Prop :=    (* defn isVoid *)
 | Void_Void : 
     void Void.
(** definitions *)

(* defns JisPointer *)
Inductive pointer : ctype -> Prop :=    (* defn isPointer *)
 | Pointer_Pointer : forall (q:qualifiers) (t:ctype),
     pointer (Pointer q t).
(** definitions *)

(* defns JisBool *)
Inductive boolean : ctype -> Prop :=    (* defn isBool *)
 | Boolean : 
     boolean (Basic (Integer Bool)).

(* defns JisUnsigned *)
Inductive unsigned : implementation -> integerType -> Prop :=    (* defn isUnsigned *)
 | Unsigned_Int : forall (P:implementation) (ibt:integerBaseType),
     unsigned P (Unsigned ibt)
 | Unsigned_Bool : forall (P:implementation),
     unsigned P Bool
 | Unsigned_Char : forall (P:implementation),
     ~ Implementation.signed P Char = true->
     unsigned P Char.
(** definitions *)

Inductive signedType : integerType -> Set :=    (* defn isSigned *)
 | SignedType : forall (ibt:integerBaseType),
     signedType (Signed ibt).

Inductive unsignedType : integerType -> Set :=    (* defn isUnsigned *)
 | UnsignedType_Int : forall (ibt:integerBaseType),
     unsignedType (Unsigned ibt)
 | UnsignedType_Bool : unsignedType Bool.

(** definitions *)

(* defns JinRange *)
Inductive inIntegerRange : implementation -> nat -> integerType -> Prop :=    (* defn inRange *)
 | InIntegerRange : forall (P:implementation) (n:nat) (it:integerType),
     memNat n (integer_range P it)  ->
     inIntegerRange P n it.
(** definitions *)

(* defns JleRange *)
Inductive leIntegerRange : implementation -> integerType -> integerType -> Prop :=    (* defn leRange *)
 | LeIntegerRange : forall (P:implementation) (it1 it2:integerType),
     sub (integer_range P it1) (integer_range P it2) ->
     leIntegerRange P it1 it2.
(** definitions *)

(* defns JeqRank *)
Inductive eqIntegerRankBase : integerType -> integerType -> Prop :=    (* defn eqRank *)
 | EqIntegerRankBase_Unsigned : forall (ibt:integerBaseType),
     eqIntegerRankBase (Signed ibt) (Unsigned ibt)
 | EqIntegerRankBase_UnsignedChar : 
     eqIntegerRankBase Char (Unsigned Ichar)
 | EqIntegerRankBase_SignedChar : 
     eqIntegerRankBase Char (Signed Ichar).

Inductive eqIntegerRank : integerType -> integerType -> Prop :=    (* defn eqRank *)
 | EqIntegerRank_Base  : forall it1 it2, eqIntegerRankBase it1 it2 -> eqIntegerRank it1 it2
 | EqIntegerRank_Sym   : forall it1 it2, eqIntegerRankBase it1 it2 -> eqIntegerRank it2 it1
 | EqIntegerRank_Refl  : forall (it:integerType), eqIntegerRank it it.
(** definitions *)

(* defns JltRank *)
Inductive ltIntegerRankBase : implementation -> integerType -> integerType -> Prop :=    (* defn ltRank *)
 | LtIntegerRankBase_Precision : forall (P:implementation) (ibt1 ibt2:integerBaseType),
     precision P (Signed ibt1) < precision  P (Signed ibt2)  ->
     ltIntegerRankBase P (Signed ibt1) (Signed ibt2)
 | LtIntegerRankBase_Bool : forall (P:implementation) (it:integerType),
      Bool <> it  ->
     ltIntegerRankBase P Bool it
 | LtIntegerRankBase_LongLong : forall (P:implementation),
     ltIntegerRankBase P (Signed Long) (Signed LongLong)
 | LtIntegerRankBase_Long : forall (P:implementation),
     ltIntegerRankBase P (Signed Int) (Signed Long)
 | LtIntegerRankBase_Int : forall (P:implementation),
     ltIntegerRankBase P (Signed Short) (Signed Int)
 | LtIntegerRankBase_Short : forall (P:implementation),
     ltIntegerRankBase P (Signed Ichar) (Signed Short).

Inductive ltIntegerRankCongruence : implementation -> integerType -> integerType -> Prop :=
 | LtIntegerRankCongruence :  forall (P:implementation) (it1 it2 it1' it2':integerType),
     eqIntegerRank it1 it1' ->
     eqIntegerRank it2 it2' ->
     ltIntegerRankBase P it1 it2 ->
     ltIntegerRankCongruence P it1' it2'.

Inductive ltIntegerRank : implementation -> integerType -> integerType -> Prop :=    (* defn ltRank *)
 | LtIntegerRank_Base : forall P it1 it2, ltIntegerRankCongruence P it1 it2 -> ltIntegerRank P it1 it2
 | LtIntegerRank_Transitive : forall (P:implementation) (it1 it2 it:integerType),
     ltIntegerRankCongruence P it1 it ->
     ltIntegerRank P it it2 ->
     ltIntegerRank P it1 it2.
(** definitions *)

(* defns JleRank *)
Inductive leIntegerRank : implementation -> integerType -> integerType -> Prop :=    (* defn leRank *)
 | LeIntegerRank_Eq : forall (P:implementation) (it1 it2:integerType),
     eqIntegerRank it1 it2 ->
     leIntegerRank P it1 it2
 | LeIntegerRank_Lt : forall (P:implementation) (it1 it2:integerType),
     ltIntegerRank P it1 it2 ->
     leIntegerRank P it1 it2.
(** definitions *)

(* defns JisArithmetic *)
Inductive arithmetic : ctype -> Prop :=    (* defn isArithmetic *)
 | Arithmetic_Integer : forall (t:ctype),
     integer    t ->
     arithmetic t.
(** definitions *)

(* defns JisScalar *)
Inductive scalar : ctype -> Prop :=    (* defn isScalar *)
 | Scalar_Pointer : forall (t:ctype),
     pointer t ->
     scalar  t
 | Scalar_Arithmetic : forall (t:ctype),
     arithmetic t ->
     scalar t.
(** definitions *)

(* defns JisArray *)
Inductive array : ctype -> Prop :=    (* defn isArray *)
 | Array_Array : forall (t:ctype) (n:nat),
     array (Array t n).
(** definitions *)

(* defns JisFunction *)
Inductive function : ctype -> Prop :=    (* defn isFunction *)
 | Function_Function : forall (p : list (qualifiers * ctype)) (t:ctype),
     function (Function t p) .
(** definitions *)

(* defns JisUnsignedOf *)
Inductive correspondingUnsigned : integerType -> integerType -> Prop :=    (* defn isCorrespondingUnsigned *)
 | CorrespondingUnsigned : forall (ibt:integerBaseType),
     correspondingUnsigned (Signed ibt) (Unsigned ibt).
(** definitions *)

(* defns JisPromotion *)
Inductive integerPromotion : implementation -> integerType -> integerType -> Set :=    (* defn isPromotion *)
 | IntegerPromotion_ToSignedInt : forall (P:implementation) (it:integerType),
      ~ it = Unsigned Int ->
      ~ it = Signed   Int ->
     leIntegerRank P it (Signed Int) ->
     leIntegerRange P it (Signed Int) ->
     integerPromotion P it (Signed Int)
 | IntegerPromotion_ToUnsignedInt : forall (P:implementation) (it:integerType),
      ~ it = Unsigned Int ->
      ~ it = Signed   Int ->
     leIntegerRank P it (Signed Int) ->
      ~ leIntegerRange P it (Signed Int) ->
     integerPromotion P it (Unsigned Int)
 | IntegerPromotion_UnsignedInt : forall (P:implementation),
     integerPromotion P (Unsigned Int) (Unsigned Int)
 | IntegerPromotion_SignedInt : forall (P:implementation),
     integerPromotion P (Signed Int) (Signed Int)
 | IntegerPromotion_Rank : forall (P:implementation) (it:integerType),
      ~ leIntegerRank P it (Signed Int) ->
     integerPromotion P it it.

(* defns JisUsualArithmetic *)
Inductive usualArithmeticPromotedInteger : implementation -> integerType -> integerType -> integerType -> Prop :=    (* defn isUsualArithmetic *)
 | UsualArithmeticPromotedInteger_Eq : forall (P:implementation) (it:integerType),
     usualArithmeticPromotedInteger P it it it
 | UsualArithmeticPromotedInteger_GtSameSigned : forall (P:implementation) (it1 it2:integerType),
      ~ it1 = it2 ->
      signedType it1 ->
      signedType it2 ->
     ltIntegerRank P it2 it1 ->
     usualArithmeticPromotedInteger P it1 it2 it1
 | UsualArithmeticPromotedInteger_GtSameUnsigned : forall (P:implementation) (it1 it2:integerType),
      ~ it1 = it2 ->
      unsignedType it1 ->
      unsignedType it2 ->
     ltIntegerRank P it2 it1 ->
     usualArithmeticPromotedInteger P it1 it2 it1
 | UsualArithmeticIntegerPromoted_LtSameSigned : forall (P:implementation) (it1 it2:integerType),
      ~ it1 = it2 ->
      signedType it1 ->
      signedType it2 ->
     ltIntegerRank P it1 it2 ->
     usualArithmeticPromotedInteger P it1 it2 it2
 | UsualArithmeticPromotedInteger_LtSameUnsigned : forall (P:implementation) (it1 it2:integerType),
      ~ it1 = it2 ->
     unsignedType it1 ->
     unsignedType it2 ->
     ltIntegerRank P it1 it2 ->
     usualArithmeticPromotedInteger P it1 it2 it2
 | UsualArithmeticPromotedInteger_LtUnsigned : forall (P:implementation) (it1 it2 :integerType),
      ~ it1 = it2->
     signedType   it1 ->
     unsignedType it2 ->
     leIntegerRank P it1 it2 ->
     usualArithmeticPromotedInteger P it1 it2 it2
 | UsualArithmeticPromotedInteger_GtUnsigned : forall (P:implementation) (it1 it2:integerType),
      ~ (   it1  =  it2   )  ->
     unsignedType it1 ->
     signedType it2 ->
     leIntegerRank P it2 it1 ->
     usualArithmeticPromotedInteger P it1 it2 it1
 | UsualArithmeticPromotedInteger_LtSigned : forall (P:implementation) (it1 it2:integerType),
      ~ (   it1  =  it2   )  ->
     unsignedType it1 ->
     signedType it2 ->
     leIntegerRank P it1 it2 ->
     leIntegerRange P it1 it2 ->
     usualArithmeticPromotedInteger P it1 it2 it2
 | UsualArithmeticPromotedInteger_GtSigned : forall (P:implementation) (it1 it2 :integerType),
      ~ (   it1  =  it2   )  ->
     signedType it1 ->
     unsignedType it2 ->
     leIntegerRank P it2 it1 ->
     leIntegerRange P it2 it1 ->
     usualArithmeticPromotedInteger P it1 it2 it1
 | UsualArithmeticPromotedInteger_LtSigned' : forall (P:implementation) (it1 it2 it2':integerType),
      ~ (   it1  =  it2   )  ->
     unsignedType it1 ->
     signedType it2 ->
     leIntegerRank P it1 it2 ->
      ~ (  leIntegerRange P it1 it2  )  ->
     correspondingUnsigned it2 it2' ->
     usualArithmeticPromotedInteger P it1 it2 it2'
 | UsualArithmeticPromotedInteger_GtSigned' : forall (P:implementation) (it1 it2 it1':integerType),
      ~ (   it1  =  it2   )  ->
     signedType it1 ->
     unsignedType it2 ->
     leIntegerRank P it2 it1 ->
      ~ (  leIntegerRange P it2 it1  )  ->
     correspondingUnsigned it1 it1' ->
     usualArithmeticPromotedInteger P it1 it2 it1'.
(** definitions *)

Inductive usualArithmeticInteger (P : implementation) : integerType -> integerType -> integerType -> Prop :=
  | UsualArithmeticInteger :
      forall (it1 it2 it1' it2' it : integerType),
      integerPromotion P it1 it1' ->
      integerPromotion P it2 it2' ->
      usualArithmeticPromotedInteger P it1' it2' it ->
      usualArithmeticInteger P it1 it2 it.

Inductive usualArithmetic (P : implementation) : ctype -> ctype -> ctype -> Prop :=
  | UsualArithmetic_Integer :
      forall (it1 it2 it : integerType),
      usualArithmeticInteger P it1 it2 it ->
      usualArithmetic P (Basic (Integer it1)) (Basic (Integer it2)) (Basic (Integer it)).

(* defns Jobject *)
Inductive object : ctype -> Prop :=    (* defn object *)
 | Object_BasicType : forall (bt:basicType),
     object (Basic bt)
 | Object_Void : 
     object Void
 | Object_Pointer : forall (q:qualifiers) (t:ctype),
     object  (Pointer q t) 
 | Object_Array : forall (t:ctype) (n:nat),
     object (Array t n) .
(** definitions *)

(* defns Jcomplete *)
Inductive complete : ctype -> Prop :=    (* defn complete *)
 | Complete_BasicType : forall (bt:basicType),
     complete (Basic bt)
 | Complete_Pointer : forall (q:qualifiers) (t:ctype),
     complete (Pointer q t) 
 | Complete_Array : forall (t:ctype) (n:nat),
     complete (Array t n) .
(** definitions *)

(* defns JisIncomplete *)
Inductive incomplete : ctype -> Prop :=    (* defnincomplete *)
 | Incomplete_Void : 
    incomplete Void.
(** definitions *)

(* defns JisModifiable *)
Inductive modifiable : qualifiers -> ctype -> Prop :=    (* defn isModifiable *)
 | Modifiable : forall (q:qualifiers) (t:ctype),
       object     t   ->
     ~ array      t   ->
     ~ incomplete t   ->
     ~ const q = true ->
     modifiable q t.
(** definitions *)

(* defns Jreal *)
Inductive real : ctype -> Prop :=    (* defn real *)
 | Real_Integer : forall (t:ctype),
     integer t ->
     real t.
(** definitions *)

(* defns JisLvalueConvertible *)
Inductive lvalueConvertible : ctype -> Prop :=    (* defn isLvalueConvertible *)
 | LvalueConvertible : forall (t:ctype),
     ~ array  t ->
     complete t ->
     lvalueConvertible t.
(** definitions *)

(* defns JisCompatible *)
Inductive compatible : ctype -> ctype -> Prop :=    (* defn isCompatible *)
 | Compatible_Void :
     compatible Void Void
 | Compatible_EqBasic : forall (bt:basicType),
     compatible (Basic bt) (Basic bt)
 | Compatible_EqPointer : forall (q1 q2 : qualifiers) (t1 t2:ctype),
     q1 = q2 ->
     compatible t1 t2 ->
     compatible (Pointer q1 t1) (Pointer q2 t2)
 | Compatible_Array : forall (n:nat) (t1 t2:ctype),
     compatible t1 t2 ->
     compatible (Array t1 n) (Array t2 n)
 | Compatible_Function : forall (p1 p2 : list (qualifiers * ctype)) (t1 t2 : ctype),
     compatible t1 t2 ->
     compatibleParams p1 p2 ->
     compatible (Function t1 p1) (Function t2 p2)
with compatibleParams : list (qualifiers * ctype) -> list (qualifiers * ctype) -> Prop :=
 | CompatibleParams_Nil  :
     compatibleParams nil nil
 | CompatibleParams_Cons : forall q1 t1 p1 q2 t2 p2,
     compatible t1 t2 ->
     compatibleParams p1 p2 ->
     compatibleParams ((q1, t1) :: p1) ((q2, t2) :: p2).

(*
Qualifiers of paramaters are ignored, c.f 6.7.6.3 #15:

In the determination of type compatibility and of a composite type, each
parameter declared with function or array type is taken as having the adjusted
type and each parameter declared with qualified type is taken as having the
unqualified version of its declared type.)

*)

(* Not that the adjustment (c.f. 6.7.6.3 # 15) of parameter types has already happened*)

(* defns JisComposite *)
Inductive composite : ctype -> ctype -> ctype -> Prop :=    (* defn isComposite *)
 | Composite_EqVoid :
     composite Void Void Void
 | Composite_EqBasic : forall (bt:basicType),
     composite (Basic bt) (Basic bt) (Basic bt)
 | Composite_EqPointer : forall (q1 q2 q : qualifiers) (t1 t2 ty : ctype),
     q1 = q ->
     q2 = q ->
     composite t1 t2 ty ->
     composite (Pointer q1 t1) (Pointer q2 t2) (Pointer q ty)
 | Composite_Array : forall (t1:ctype) (n:nat) (t2 t:ctype),
     composite t1 t2 t ->
     composite  (Array t1 n)   (Array t2 n)   (Array t n)
 | Composite_Function : forall (p1 p2 p : list (qualifiers * ctype)) (t1 t2 t : ctype),
     composite t1 t2 t ->
     compositeParams p1 p2 p ->
     composite (Function t1 p1) (Function t2 p2) (Function t p)
with compositeParams : list (qualifiers * ctype) -> list (qualifiers * ctype) -> list (qualifiers * ctype) -> Prop :=
 | CompositeParams_Nil :
     compositeParams nil nil nil
 | CompositeParams_Cons : forall q1 q2 q3 t1 t2 t3 p1 p2 p3,
     composite  t1 t2 t3 ->
     compositeParams p1 p2 p3 ->
     unqualified q3 ->
     compositeParams ((q1, t1) :: p1) ((q2, t2) :: p2) ((q3, t3) :: p3).
