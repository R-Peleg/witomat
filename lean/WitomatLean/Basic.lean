import Mathlib.Data.Nat.Basic
import Mathlib.Data.Nat.Find
import Mathlib.Data.Set.Basic
import Mathlib.Order.Basic

/-- A subtraction game is defined by a function that maps each state (a natural number)
    to a set of possible next states. -/
def SubtractionGame := ℕ → Set ℕ

/-- A valid subtraction game ensures that every move leads to a strictly smaller natural number,
    guaranteeing that the game always ends. -/
def IsValid (g : SubtractionGame) : Prop :=
  ∀ n m, m ∈ g n → m < n

/-- The minimum excluded value (mex) of a set of natural numbers. -/
noncomputable def mex (s : Set ℕ) : ℕ :=
  open Classical in
  if h : ∃ n, n ∉ s then Nat.find h else 0

lemma mex_not_mem (s : Set ℕ) (h : ∃ n, n ∉ s) : mex s ∉ s := by
  classical
  rw [mex, dif_pos h]
  exact Nat.find_spec h

lemma mex_min (s : Set ℕ) (h : ∃ n, n ∉ s) (m : ℕ) (hm : m < mex s) : m ∈ s := by
  classical
  rw [mex, dif_pos h] at hm
  by_contra h_not_mem
  have : Nat.find h ≤ m := Nat.find_min' h h_not_mem
  exact Nat.lt_le_asymm hm this

/-- The Sprague-Grundy function for a valid subtraction game. -/
noncomputable def grundy (g : SubtractionGame) (h_v : IsValid g) (n : ℕ) : ℕ :=
  Nat.strongRecOn' n (fun n ih =>
    mex ((fun (m : {x // x ∈ g n}) => ih m.val (h_v n m.val m.property)) '' Set.univ)
  )

theorem grundy_eq (g : SubtractionGame) (h_v : IsValid g) (n : ℕ) :
    grundy g h_v n = mex ((fun (m : {x // x ∈ g n}) => grundy g h_v m.val) '' Set.univ) := by
  rw [grundy, Nat.strongRecOn'_beta]
  rfl
