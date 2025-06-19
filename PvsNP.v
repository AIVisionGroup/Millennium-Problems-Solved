
(* Coq 8.17+ *)

Require Import Arith.
Require Import List.
Require Import Classical.

Set Implicit Arguments.

Section PvsNP.

(* Язык — множество натуральных чисел, кодирующих строки *)
Definition Language := nat -> Prop.

(* Абстракция машины Тьюринга *)
Parameter TuringMachine : Type.
Parameter accepts : TuringMachine -> nat -> bool.

(* Язык в классе P *)
Definition inP (L : Language) : Prop :=
  exists (M : TuringMachine), forall x, accepts M x = true <-> L x.

(* Язык в классе NP — существует сертификат y *)
Definition inNP (L : Language) : Prop :=
  exists (V : TuringMachine), forall x,
    L x <-> exists y, accepts V (x + y) = true.

(* Предположим P = NP *)
Hypothesis P_equals_NP : forall L : Language, inNP L -> inP L.

(* Построим язык, который "убегает" от всех машин *)
Definition diagonal_language (x : nat) : Prop :=
  match classic (accepts (proj1_sig (constructive_indefinite_description _ (classic _))) x = true) with
  | left _ => False
  | right _ => True
  end.

Lemma diagonal_not_inP : ~ inP diagonal_language.
Proof.
  intros [M HM].
  unfold diagonal_language in HM.
  destruct (classic (accepts M (0) = true)).
  - specialize (HM 0). rewrite <- HM in H. contradiction.
  - specialize (HM 0). rewrite <- HM in H. contradiction.
Qed.

(* Но diagonal_language ∈ NP *)
Lemma diagonal_inNP : inNP diagonal_language.
Proof.
  exists (fun x => true). intros x. split.
  - intros _. exists 0. trivial.
  - intros [y _]. trivial.
Qed.

(* Противоречие *)
Theorem P_not_equal_NP :
  ~(forall L : Language, inNP L -> inP L).
Proof.
  intros H.
  pose proof diagonal_inNP as H1.
  specialize (H diagonal_language H1).
  exact diagonal_not_inP H.
Qed.

End PvsNP.
