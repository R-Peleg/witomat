import WitomatLean.Basic
import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.Basic

open Nat

/-- The subtraction game where one can take 1, 2, ..., k objects. -/
def gameK (k : ℕ) : SubtractionGame :=
  fun n => {m | m < n ∧ n ≤ m + k}

lemma gameK_valid (k : ℕ) : IsValid (gameK k) := by
  intro n m h
  exact h.1

/-- The Sprague-Grundy function of gameK k is n % (k+1). -/
theorem grundy_gameK (k n : ℕ) : grundy (gameK k) (gameK_valid k) n = n % (k + 1) := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    rw [grundy_eq]
    let s := n % (k + 1)
    let S := (fun (m : {x // x ∈ gameK k n}) => grundy (gameK k) (gameK_valid k) m.val) '' Set.univ
    have h_S : S = (fun m => m % (k + 1)) '' (gameK k n) := by
      ext y
      constructor
      · rintro ⟨m, _, rfl⟩
        use m.val
        constructor
        · exact m.property
        · exact ih _ (gameK_valid k n m.val m.property)
      · rintro ⟨m, hm, rfl⟩
        use ⟨m, hm⟩
        simp
        exact ih _ (gameK_valid k n m hm)
    rw [h_S]
    have h_not_mem_s : s ∉ (fun m => m % (k + 1)) '' (gameK k n) := by
      rintro ⟨m, ⟨hm_lt, hm_ge⟩, h_eq⟩
      have : k + 1 ≤ n - m := Nat.le_of_mod_eq_iff_add_le hm_lt h_eq
      have : n - m ≤ k := Nat.le_sub_of_add_le hm_ge
      exact Nat.lt_le_asymm (Nat.lt_succ_self k) (Nat.le_trans this ‹k + 1 ≤ n - m›)
    apply Nat.le_antisymm
    · -- mex(S) ≤ s
      apply Nat.le_of_not_lt
      intro h_lt
      have h_ex : ∃ x, x ∉ (fun m => m % (k + 1)) '' (gameK k n) := ⟨s, h_not_mem_s⟩
      have h_mem : s ∈ (fun m => m % (k + 1)) '' (gameK k n) := by
        rw [mex, dif_pos h_ex] at h_lt
        apply mex_min _ h_ex _ h_lt
      exact h_not_mem_s h_mem
    · -- mex(S) ≥ s
      apply Nat.le_of_not_lt
      intro h_lt
      have h_ex : ∃ x, x ∉ (fun m => m % (k + 1)) '' (gameK k n) := ⟨s, h_not_mem_s⟩
      let r := mex ((fun m => m % (k + 1)) '' (gameK k n))
      have hr_lt : r < s := by rw [mex, dif_pos h_ex] at h_lt; exact h_lt
      have : r ∈ (fun m => m % (k + 1)) '' (gameK k n) := by
        let q := n / (k + 1)
        use q * (k + 1) + r
        constructor
        · constructor
          · rw [Nat.div_add_mod n (k + 1)]
            apply Nat.add_lt_add_left hr_lt
          · rw [Nat.div_add_mod n (k + 1)]
            apply Nat.le_trans _ (Nat.le_add_right _ _)
            apply Nat.add_le_add_left
            apply Nat.le_trans (Nat.le_of_lt hr_lt)
            apply Nat.le_add_right _ k
        · rw [Nat.add_mod, Nat.mul_mod_right, Nat.zero_add, Nat.mod_mod]
          apply Nat.mod_eq_of_lt
          apply Nat.lt_trans hr_lt
          apply Nat.mod_lt _ (Nat.succ_pos k)
      exact mex_not_mem _ h_ex this

/-- Specific case for k=3. -/
theorem grundy_game3 (n : ℕ) : grundy (gameK 3) (gameK_valid 3) n = n % 4 :=
  grundy_gameK 3 n
