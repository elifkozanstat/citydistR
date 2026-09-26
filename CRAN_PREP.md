# CRAN preparation checklist

Before any CRAN submission:

1. Replace `elif.kozan@ege.edu.tr` in `DESCRIPTION` with the real maintainer email.
2. Replace `YOUR-GITHUB-USERNAME` in `DESCRIPTION` and `README.md`.
3. Run `R CMD build citydistR`.
4. Run `R CMD check citydistR_0.1.0.tar.gz --as-cran`.
5. Resolve all ERROR/WARNING messages and review NOTES.
6. Confirm examples, tests, spelling, URLs, license metadata and package title/description.
7. Submit only when the package status is accurately documented.

The current artifact is intended to be GitHub-ready source code and is not being
represented as CRAN-accepted.
