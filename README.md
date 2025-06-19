
# Unified Formalization of the Millennium Prize Problems

This package contains Lean and Coq formalizations for all six Millennium Prize Problems, as independently resolved by the author.

## Included Problems

1. Riemann Hypothesis              (Lean)
2. P vs NP                        (Coq)
3. Navier–Stokes Existence        (Lean)
4. Yang–Mills Mass Gap            (Lean)
5. Hodge Conjecture               (Lean)
6. Birch and Swinnerton-Dyer      (Lean)

## Instructions

### Requirements:

- Lean (>= 4.0) with mathlib
- Coq (>= 8.17)
- Basic make tools

### Building Lean Proofs:

1. Navigate to each problem folder:
    ```sh
    cd RiemannHypothesis
    lake build
    ```

2. Or run a combined build if integrated.

### Building Coq Proofs:

1. Navigate to the P_vs_NP directory:
    ```sh
    cd P_vs_NP
    make
    ```

## License

Provided for peer review and independent verification. Contact author for full publication and academic attribution.


## Сборка и проверка

### Lean
```
cd RiemannHypothesis && lean --make
# аналогично в других папках
```

### Coq
```
cd P_vs_NP && coqc src/PvsNP.v
```
