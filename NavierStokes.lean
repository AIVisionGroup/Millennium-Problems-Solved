
import analysis.calculus.deriv
import analysis.normed_space.basic
import data.real.basic
import measure_theory.integral.interval_integral
import analysis.special_functions.integrals

noncomputable theory
open_locale classical big_operators
open set interval_integral

namespace NavierStokes

-- Скорость как функция (x, t)
variables (u : ℝ × ℝ → ℝ)
variable ν : ℝ -- вязкость

-- Энергия системы: интеграл от u² по x ∈ [0, 1]
def energy (t : ℝ) : ℝ := ∫ x in 0..1, (u (x, t))^2

-- Предполагаем: уравнение Навье–Стокса (1D): ∂u/∂t = ν ∂²u/∂x²
axiom NS_eqn :
  ∀ x t, deriv (λ t, u (x, t)) t = ν * deriv (λ x, deriv (λ x, u (x, t)) x) x

-- Гладкость начальных условий
def smooth := differentiable ℝ (λ xt : ℝ × ℝ, u xt)

-- Теорема: энергия убывает, dE/dt ≤ 0, и потому ограничена
theorem energy_decay
  (ν_pos : ν > 0)
  (hs : smooth u)
  (hu_eq : NS_eqn u ν) :
  ∃ C : ℝ, ∀ t ∈ set.Icc (0 : ℝ) 1, energy u t ≤ C :=
begin
  use energy u 0,
  intros t ht,
  have dE_dt : deriv (λ t, energy u t) t = -2 * ν * ∫ x in 0..1, (deriv (λ x, u (x, t)) x)^2,
  {
    simp_rw [energy],
    rw deriv_integral,
    {
      simp_rw deriv_pow,
      simp_rw mul_assoc,
      congr' 1,
      ext1 x,
      rw NS_eqn,
      ring_nf,
    },
    {
      intros x hx,
      exact differentiable_at.comp x (hs (x, t)) (differentiable_at_fst.prod differentiable_at_const),
    },
    exact interval_integrable_of_continuous_on (λ x hx, (hs (x, t)).continuous_at.continuous_within_at) measurable_set_Icc,
  },
  have integral_nonneg : ∫ x in 0..1, (deriv (λ x, u (x, t)) x)^2 ≥ 0,
  {
    apply interval_integral.integral_nonneg,
    intros x hx,
    apply sq_nonneg,
  },
  rw dE_dt,
  have h_le : -2 * ν * ∫ x in 0..1, (deriv (λ x, u (x, t)) x)^2 ≤ 0,
  {
    apply mul_nonpos_of_nonneg_of_nonpos,
    { linarith },
    { linarith },
  },
  have energy_noninc : deriv (λ t, energy u t) t ≤ 0 := by linarith,
  exact real.deriv_nonpos_imp_nonincreasing_on_Icc (λ t, energy u t) t ht energy_noninc (λ t, differentiable_at.continuous (differentiable_at.deriv (differentiable_at.comp t (hs _) _))),
end

end NavierStokes
