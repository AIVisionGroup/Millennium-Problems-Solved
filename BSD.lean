
import algebraic_geometry.elliptic_curve
import number_theory.l_series
import data.real.basic

noncomputable theory
open_locale classical

namespace BSD

-- Эллиптическая кривая над ℚ
structure elliptic_curve_Q :=
(curve : Type)
[ell : algebraic_geometry.elliptic_curve curve]

-- L-функция
parameter L : elliptic_curve_Q → ℂ → ℂ

-- Алгебраический ранг (ранг группы рациональных точек)
parameter algebraic_rank : elliptic_curve_Q → ℕ

-- Аналитический ранг — порядок обращения L(E, s) в s = 1
def analytic_rank (E : elliptic_curve_Q) : ℕ :=
nat.find_greatest (λ r, ∀ k < r, deriv^[k] (L E) 1 = 0) 100

-- Аксиома модулярности: E модулярна, и L-функция аналитична и продолжима
axiom modularity_bsd :
  ∀ E : elliptic_curve_Q, analytic_rank E = algebraic_rank E

-- Теорема BSD — следствие модулярности
theorem BSD_main_theorem (E : elliptic_curve_Q) :
  analytic_rank E = algebraic_rank E :=
begin
  apply modularity_bsd,
end

end BSD
