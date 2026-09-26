# Validation status

Package: citydistR 0.1.1

## Local CRAN-style check

Environment:
- R 4.6.1
- macOS Sonoma
- Apple silicon
- TinyTeX / pdflatex available

Command:
`R CMD check --as-cran`

Result:
- **0 errors**
- **0 warnings**
- **2 notes**

Notes:
1. `New submission`.
2. Local HTML-manual validation was skipped because the installed HTML Tidy was not recent enough.

The PDF manual check completed successfully.

## Win-builder R-devel check

Environment:
- R Under development (unstable), Windows Server 2022 x64
- x86_64-w64-mingw32

Result:
- **0 errors**
- **0 warnings**
- **1 note**

The only NOTE was:
`New submission`

The package installed successfully, tests passed, examples passed, and both PDF and HTML manual checks passed.
