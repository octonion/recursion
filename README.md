# Blackjack hand enumeration across 150 implementations

An experiment in **implementing the same recursive counting problem across programming languages**, from ALGOL, B, BCPL, and Simula to contemporary systems languages, functional languages, scripting languages, and foreign-function interfaces.

This is primarily a collection of source-code examples and historical build notes, **not a curated set of verified modern builds or a standardized performance benchmark**. Some compilers and interpreters are obsolete or require patches. The 150 directories are *implementations and language combinations*, not 150 distinct programming languages.

## Contents

- [The counting problem](#the-counting-problem)
- [Reference results](#reference-results)
- [Quick start](#quick-start)
- [Language catalog (A–Z)](#language-catalog-a-z)
- [Cross-language interoperability](#cross-language-interoperability)
- [Language families and lineages](#language-families-and-lineages)
- [Versions and historical toolchains](#versions-and-historical-toolchains)
- [Build status and reproducibility](#build-status-and-reproducibility)
- [Contributing](#contributing)
- [License](#license)

## The counting problem

The programs count **ordered sequences of card ranks** that can be drawn without exceeding a running total of 21, from a finite single deck, after a dealer's exposed card has been removed.

The deck is represented by ten ranks, with values `1, 2, ..., 10` and initial multiplicities

```text
rank:        1  2  3  4  5  6  7  8  9  10
multiplicity:4  4  4  4  4  4  4  4  4  16
```

Here rank 1 represents an ace, **always counted as 1**; rank 10 combines tens, jacks, queens, and kings. The programs do not implement the complete rules of casino Blackjack.

For each possible dealer upcard rank `d`, the program:

1. Removes **one** card of rank `d` from the deck.
2. Considers each possible rank `j` for the player's **first card**, removing one such card.
3. Recursively draws **at least one additional player card**; each legal new prefix (total at most 21) contributes one outcome, representing the choice to stop after that draw.
4. Also explores further draws when the running total is below 21. Draws that bust are discarded, and a total of exactly 21 cannot be extended.
5. Sums these counts over the ten possible initial player ranks.

**Important conventions:** A hand with *only one* player card is not counted. Rank order matters, but individual physical cards of the same rank are indistinguishable for counting purposes. The rank multiplicities limit the available draws; **they are not probability weights**. Thus the result is not the number of suit-distinct deals, nor a probability, nor the number of winning Blackjack hands.

### Recurrence

Let `c = (c_1, ..., c_10)` be the available rank multiplicities, and let `F(c, s)` count the admissible **nonempty** continuation sequences from subtotal `s`. Writing `e_k` for the unit vector of rank `k`,

```text
F(c, s) = sum over k with c[k] > 0 and s+k <= 21 of
             (1 + (s+k < 21 ? F(c-e[k], s+k) : 0)).
```

The `1` counts the option to stop after drawing rank `k`. The recursive term counts longer sequences. Starting from the full deck `c0`, the count for a dealer upcard of rank `d` is

```text
N[d] = sum over available initial player ranks j of
           F(c0-e[d]-e[j], j).
```

The implementations use direct recursion and, in some cases, variations or cross-language calls. The formulas above specify the intended reference calculation; they do not prescribe an optimization strategy.

## Reference results

The reference C implementation is [`c/outcomes.c`](c/outcomes.c). Its checked-in output is [`c/outcomes.txt`](c/outcomes.txt).

| Dealer's visible rank | Count |
| ---: | ---: |
| 1 (ace) | 417,334 |
| 2 | 560,954 |
| 3 | 658,854 |
| 4 | 679,464 |
| 5 | 680,299 |
| 6 | 680,305 |
| 7 | 680,305 |
| 8 | 680,305 |
| 9 | 680,305 |
| 10 (ten-valued) | 680,305 |
| **Sum over dealer ranks** | **6,398,430** |

Some programs print zero-based rank *indices* (`Dealer showing 0` through `Dealer showing 9`) instead of card values (`1` through `10`). The output labels therefore differ by one, but the reference counts are in the same order. The final sum is over rank **categories**, without weighting by the number of physical dealer upcards.

`outcomes.txt` files may also include wall-clock or CPU timings measured on their original systems. Those timings are historical and should **not** be compared as a controlled language benchmark.

## Quick start

### C (GCC or Clang)

From the repository root:

```bash
cd c
cc -O2 -std=c11 -o outcomes outcomes.c
./outcomes
```

The final line should be:

```text
Total partitions = 6398430
```

### Python 3

```bash
cd python
python3 outcomes3.py
```

Python 2 and Python 3 variants are kept separately where they existed historically; Python 2 is obsolete and is not required for the Python 3 example.

### Historical compiler examples

- [Cyclone](cyclone/): a safer dialect of C; historical `cyclone` toolchain required.
- [ALGOL W](algol-w/): can use the companion [aw2c](https://github.com/octonion/aw2c) translator.
- [SuperPascal](superpascal/): uses the companion [SuperPascal compiler/interpreter](https://github.com/octonion/superpascal).
- [Niecza](niecza/): an implementation targeting the CLR for Perl 6 / Raku.
- [BCPL](bcpl/) and [B](b/): early predecessors in the C family.

These entries illustrate historical toolchains; **their build commands are not certified against current Linux distributions**.

## Language catalog (A-Z)

**121 single-language or runtime-variant directories**, in alphabetical order. The first link opens this repository's implementation; the last link opens the compiler/interpreter project or language documentation. The descriptions summarize each language or variant, **not a tested compiler version**. For exact historical commands, consult the directory's own `README.md` when available.

Some entries are distinct *implementations of the same language* (such as CPython/PyPy/MicroPython/Jython or several Scheme compilers), and others are embedded languages or scripting environments (such as PostgreSQL SQL and shell languages). They are retained as separate implementation directories, not counted as 121 different language specifications.

### A–F

| Language / implementation | Description | Compiler, interpreter or reference |
|---|---|---|
| [Ada](ada/) | Statically typed systems language emphasizing reliability and concurrency | [GNAT / Ada](https://gcc.gnu.org/onlinedocs/gnat_ugn/) |
| [AFNIX](afnix/) | Functional/object-oriented scripting language with its own interpreter | [AFNIX](https://www.afnix.org/) |
| [ALGOL 68](algol68/) | Expression-oriented ALGOL-family language with orthogonal types | [ALGOL 68 Genie](https://jmvdveer.home.xs4all.nl/en.algol-68-genie.html) |
| [ALGOL W](algol-w/) | Wirth's ALGOL-family language; source-to-C translation in this project | [aw2c (companion repository)](https://github.com/octonion/aw2c) |
| [AmbientTalk](ambienttalk/) | Actor-oriented distributed object language | [AmbientTalk](https://soft.vub.ac.be/amop/at/) |
| [Awk](awk/) | Pattern/action text-processing language | [GNU Awk](https://www.gnu.org/software/gawk/) |
| [B](b/) | Early systems language descended from BCPL, preceding C | [Amsterdam Compiler Kit (ACK)](https://tack.sourceforge.net/) |
| [Bash](bash/) | Bourne-family Unix shell and scripting language | [GNU Bash](https://www.gnu.org/software/bash/) |
| [BASIC](basic/) | BASIC implementation built with FreeBASIC (`fbc`) | [FreeBASIC / historical BASIC](https://www.freebasic.net/) |
| [bc](bc/) | Arbitrary-precision command-line calculator language | [GNU bc](https://www.gnu.org/software/bc/) |
| [BCPL](bcpl/) | Richards's Basic Combined Programming Language, predecessor of B | [BCPL compiler (see local notes)](https://www.cl.cam.ac.uk/~mr10/BCPL.html) |
| [Bigloo](bigloo/) | Scheme implementation compiling to C and other backends | [Bigloo](https://www-sop.inria.fr/mimosa/fp/Bigloo/) |
| [Boo](boo/) | Python-like statically typed language targeting .NET/Mono | [Boo](https://github.com/boo-lang/boo) |
| [Boron](boron/) | REBOL-inspired small extensible scripting language | [Boron](https://github.com/0branch/boron) |
| [C](c/) | General-purpose systems language; direct recursive baseline | [GCC / C](https://gcc.gnu.org/) |
| [C#](csharp/) | C-family managed language for .NET | [C# / .NET](https://learn.microsoft.com/en-us/dotnet/csharp/) |
| [C++](cpp/) | C++ systems language with classes and templates | [GCC / C++](https://gcc.gnu.org/) |
| [Ceylon](ceylon/) | Statically typed language originally targeting JVM and JavaScript | [Ceylon (archived)](https://github.com/eclipse-archived/ceylon) |
| [Chapel](chapel/) | Parallel language for scalable scientific computing | [Chapel](https://chapel-lang.org/) |
| [Chez](chez/) | Optimizing implementation of Scheme | [Chez Scheme](https://cisco.github.io/ChezScheme/) |
| [Chicken](chicken/) | Scheme implementation that translates to C | [CHICKEN Scheme](https://www.call-cc.org/) |
| [CLISP](clisp/) | Common Lisp implementation and interpreter/compiler | [CLISP](https://clisp.sourceforge.io/) |
| [Clojure](clojure/) | Functional Lisp dialect on the JVM | [Clojure](https://clojure.org/) |
| [COBOL](cobol/) | Business-oriented language; classic procedural style | [GnuCOBOL](https://gnucobol.sourceforge.io/) |
| [Cobra](cobra/) | Original Chuck Esterbrook .NET/Mono language, influenced by Python and Eiffel | [Historical Cobra reference](https://cobralang.blogspot.com/) |
| [Crystal](crystal/) | Ruby-like statically typed compiled language | [Crystal](https://crystal-lang.org/) |
| [Cyclone](cyclone/) | Research dialect of C with regions and safer pointer types | [Cyclone compiler (historical)](https://cyclone.thelanguage.org/) |
| [Cython](cython/) | Python superset translated to C with optional static types | [Cython](https://cython.org/) |
| [Cython (array)](cython-array/) | Alternative Cython variant emphasizing array representation | [Cython](https://cython.org/) |
| [D](dlang/) | D systems language with C-like syntax | [DMD / LDC](https://dlang.org/) |
| [Dart](dart/) | Object-oriented language used by Flutter | [Dart](https://dart.dev/) |
| [Elixir](elixir/) | Functional concurrent language on the Erlang VM | [Elixir](https://elixir-lang.org/) |
| [Euphoria](euphoria/) | High-level interpreted/compiled imperative language | [OpenEuphoria](https://openeuphoria.org/) |
| [F#](fsharp/) | Functional-first .NET language of the ML family | [F#](https://fsharp.org/) |
| [Fantom](fantom/) | Portable object-oriented language on JVM/.NET | [Fantom](https://fantom.org/) |
| [Felix](felix/) | Functional/systems language targeting native code | [Felix](https://github.com/felix-lang/felix) |
| [Fish](fish/) | User-friendly interactive shell scripting | [fish](https://fishshell.com/) |
| [Forth](forth/) | Stack-based concatenative language | [Gforth](https://gforth.org/) |
| [Fortran](fortran/) | Scientific and numerical programming language | [GNU Fortran](https://gcc.gnu.org/fortran/) |
| [FriCAS](fricas/) | Computer-algebra language and environment; input script in FriCAS | [FriCAS](https://fricas.github.io/) |


### G–L

| Language / implementation | Description | Compiler, interpreter or reference |
|---|---|---|
| [Gambit](gambit/) | Scheme-to-C compiler and runtime | [Gambit Scheme](https://gambitscheme.org/) |
| [Go](golang/) | Concurrent compiled systems language | [Go](https://go.dev/) |
| [Gosu](gosu/) | Statically typed JVM language with Java interoperability | [Gosu](https://gosu-lang.github.io/) |
| [Gravity](gravity/) | Lightweight embeddable scripting language | [Gravity](https://github.com/marcobambini/gravity) |
| [Groovy](groovy/) | Dynamic JVM language with Java interoperability | [Groovy](https://groovy-lang.org/) |
| [Guile](guile/) | GNU Scheme implementation | [GNU Guile](https://www.gnu.org/software/guile/) |
| [Hack](hack/) | Gradually typed PHP-family language | [Hack](https://hacklang.org/) |
| [Haxe](haxe/) | Cross-platform language compiling to multiple targets | [Haxe](https://haxe.org/) |
| [Icon](icon/) | Goal-directed expression-evaluation language | [Icon](https://www2.cs.arizona.edu/icon/) |
| [IDL](idl/) | IDL-like array programming; the README uses the open-source GDL interpreter | [GNU Data Language (GDL)](https://gnudatalanguage.github.io/) |
| [Io](io/) | Prototype-based object language with message syntax | [Io language](https://iolanguage.org/) |
| [Java](java/) | Managed object-oriented JVM language | [OpenJDK](https://openjdk.org/) |
| [JavaScript](javascript/) | ECMAScript scripting language | [JavaScript / Node.js](https://nodejs.org/) |
| [Julia](julia/) | High-performance dynamic numerical language | [Julia](https://julialang.org/) |
| [Jython](jython/) | Python implementation targeting the JVM; version-sensitive | [Jython](https://www.jython.org/) |
| [Kotlin](kotlin/) | Statically typed JVM and multiplatform language | [Kotlin](https://kotlinlang.org/) |
| [Ksh](ksh/) | KornShell, Bourne-shell descendant | [KornShell](https://github.com/ksh93/ksh) |
| [Larceny](larceny/) | R6RS-oriented Scheme implementation | [Larceny](https://larcenists.org/) |
| [Lily](lily/) | Small dynamically typed scripting language | [Lily](https://github.com/FascinatedBox/lily) |
| [Lua](lua/) | Small embeddable scripting language | [Lua](https://www.lua.org/) |


### M–R

| Language / implementation | Description | Compiler, interpreter or reference |
|---|---|---|
| [Maple](maple/) | Symbolic and numerical computing language | [Maple](https://www.maplesoft.com/products/Maple/) |
| [Mathematica](mathematica/) | Wolfram symbolic-computing language | [Wolfram Language](https://www.wolfram.com/language/) |
| [MATLAB](matlab/) | Array-based commercial numerical programming language | [MATLAB](https://www.mathworks.com/products/matlab.html) |
| [MicroPython](micropython/) | Compact Python implementation for microcontrollers | [MicroPython](https://micropython.org/) |
| [MIT Scheme](mit-scheme/) | MIT/GNU implementation of Scheme | [MIT Scheme](https://www.gnu.org/software/mit-scheme/) |
| [Modula-2](modula2/) | Wirth's modular successor to Pascal | [GNU Modula-2](https://gcc.gnu.org/onlinedocs/gm2/) |
| [Modula-3](modula3/) | Modula-family systems language with safe modules and interfaces | [Critical Mass Modula-3](https://github.com/modula3/cm3) |
| [Myrddin](myrddin/) | Small statically typed systems language influenced by C and ML | [Myrddin](https://myrlang.org/) |
| [Nemerle](nemerle/) | Typed .NET language combining OO and metaprogramming | [Nemerle](https://github.com/rsdn/nemerle) |
| [Niecza (Raku/Perl 6)](niecza/) | Perl 6 compiler/implementation targeting the CLR; pre-Raku era | [Niecza (companion fork)](https://github.com/octonion/niecza) |
| [Nim](nim/) | Compiled language with Python-like syntax and metaprogramming | [Nim](https://nim-lang.org/) |
| [Numba](numba/) | Python variant using LLVM-based JIT on numeric kernels | [Numba](https://numba.pydata.org/) |
| [Oberon](oberon/) | Wirth's minimal Pascal/Modula successor | [Oberon](https://projectoberon.net/) |
| [Objeck](objeck/) | Object-oriented VM language | [Objeck](https://www.objeck.org/) |
| [Octave](octave/) | MATLAB-compatible numerical language | [GNU Octave](https://octave.org/) |
| [Odin](odin/) | Data-oriented compiled systems language | [Odin](https://odin-lang.org/) |
| [ParaSail](parasail/) | Pointer-free parallel language descended from Ada design ideas | [ParaSail](https://github.com/parasail-lang/parasail) |
| [Pascal](pascal/) | Structured imperative language; local implementation uses a Pascal compiler | [Free Pascal](https://www.freepascal.org/) |
| [Perl](perl/) | Dynamic text-processing and general scripting language | [Perl 5](https://www.perl.org/) |
| [Perl 6 / Raku](perl6/) | Perl 6 language, now named Raku | [Raku / Rakudo](https://raku.org/) |
| [PHP](php/) | Dynamic language frequently used for web programming | [PHP](https://www.php.net/) |
| [Pike](pike/) | Dynamic object-oriented language with C-family syntax | [Pike](https://pike.lysator.liu.se/) |
| [PL/I](pli/) | IBM PL/I: combined scientific/business programming language | [PL/I](https://www.ibm.com/docs/en/epfz) |
| [Pony](pony/) | Actor-model concurrent language with reference capabilities | [Pony](https://www.ponylang.io/) |
| [PostgreSQL](pgsql/) | SQL with PostgreSQL function/procedure extension, not a standalone compiler | [PostgreSQL](https://www.postgresql.org/docs/) |
| [PowerShell](powershell/) | Object-pipeline shell and automation language | [PowerShell](https://learn.microsoft.com/en-us/powershell/) |
| [PureBasic](purebasic/) | Compiled BASIC-family language | [PureBasic](https://www.purebasic.com/) |
| [PyPy](pypy/) | Python implementation with a tracing JIT | [PyPy](https://pypy.org/) |
| [Python](python/) | Python 2 and Python 3 versions preserved | [Python / CPython](https://www.python.org/) |
| [Qore](qore/) | Dynamic language supporting multithreaded integration | [Qore](https://qore.org/) |
| [R](r/) | Statistical computing and graphics language | [GNU R](https://www.r-project.org/) |
| [Racket](racket/) | Lisp/Scheme descendant emphasizing language-oriented programming | [Racket](https://racket-lang.org/) |
| [REBOL](rebol/) | Data-exchange and dialecting language | [REBOL](https://www.rebol.com/) |
| [Red](red/) | REBOL-inspired language with a native systems component | [Red](https://www.red-lang.org/) |
| [Regent](regent/) | Task-based parallel language embedded in Terra, using Legion | [Regent](https://regent-lang.org/) |
| [REXX](rexx/) | String-oriented scripting language | [Regina REXX](https://regina-rexx.sourceforge.io/) |
| [Ruby](ruby/) | Dynamic object-oriented scripting language | [Ruby](https://www.ruby-lang.org/) |
| [Rust](rust/) | Memory-safe compiled systems language | [Rust](https://www.rust-lang.org/) |


### S–Z

| Language / implementation | Description | Compiler, interpreter or reference |
|---|---|---|
| [Sage](sage/) | Python-based computer-algebra environment | [SageMath](https://www.sagemath.org/) |
| [SBCL](sbcl/) | Optimizing Common Lisp compiler/runtime | [SBCL](https://www.sbcl.org/) |
| [Scala](scala/) | JVM language combining functional and object-oriented programming | [Scala](https://www.scala-lang.org/) |
| [Seed7](seed7/) | Extensible compiled/interpreted general-purpose language | [Seed7](https://seed7.sourceforge.net/) |
| [Simula](simula/) | Historic object-oriented language from the ALGOL family | [GNU Cim / Simula](https://www.gnu.org/software/cim/) |
| [Squirrel](squirrel/) | Small embeddable C-like scripting language | [Squirrel](https://squirrel-lang.org/) |
| [Stalin](stalin/) | Whole-program optimizing implementation of Scheme | [Stalin Scheme compiler](https://github.com/barak/stalin) |
| [SuperCollider](supercollider/) | Real-time audio synthesis and object-oriented language | [SuperCollider](https://supercollider.github.io/) |
| [SuperPascal](superpascal/) | Per Brinch Hansen's parallel extension of Pascal | [SuperPascal (companion port)](https://github.com/octonion/superpascal) |
| [Swift](swift/) | Compiled multiparadigm language with safety features | [Swift](https://swift.org/) |
| [Tcl](tcl/) | Embeddable command language | [Tcl](https://www.tcl-lang.org/) |
| [TypeScript](typescript/) | Typed superset of JavaScript | [TypeScript](https://www.typescriptlang.org/) |
| [Unicon](unicon/) | Object-oriented evolution of the Icon language | [Unicon](https://unicon.org/) |
| [V](v/) | Small compiled Go-inspired systems language | [V](https://vlang.io/) |
| [Vector Pascal](vector-pascal/) | Pascal extended with array/SIMD operations | [Vector Pascal compiler](https://sourceforge.net/projects/vectorpascalcom/) |
| [Vicare](vicare/) | R6RS Scheme implementation | [Vicare Scheme](https://github.com/marcomaggi/vicare) |
| [Visual Basic](vb/) | Visual Basic .NET source compiled with `vbc` and run under Mono | [Visual Basic](https://learn.microsoft.com/en-us/dotnet/visual-basic/) |
| [Wren](wren/) | Compact class-based embeddable scripting language | [Wren](https://wren.io/) |
| [X10](x10/) | Partitioned-global-address-space parallel language | [X10](https://x10-lang.org/) |
| [Yorick](yorick/) | Interpreted array language for scientific computing | [Yorick](https://yorick.sourceforge.net/) |
| [Zig](zig/) | Low-level compiled language with explicit memory management | [Zig](https://ziglang.org/) |
| [Zonnon](zonnon/) | Modula/Oberon-descended language for .NET; active objects | [Zonnon](https://zonnon.org/) |
| [Zsh](zsh/) | Extended Bourne/Korn-style shell | [Zsh](https://www.zsh.org/) |


**Important historical name collisions:** `cobra/` is the older Chuck Esterbrook .NET/Mono language (not later languages also called Cobra). `idl/` uses the GNU Data Language (`gdl`) interpreter, as shown in its README. `niecza/` is a Perl 6 implementation targeting the CLR, not a separate language specification. Likewise, `stalin/`, `chez/`, `chicken/`, `gambit/`, `larceny/`, and `vicare/` are distinct Scheme implementations.

## Cross-language interoperability

The remaining **29 directories** deliberately mix languages or build separate native libraries. They are indexed separately so they do not inflate the number of distinct programming languages. Descriptions below are based on the checked-in README commands and representative source calls; no recent end-to-end build is implied.

| Directory | What it demonstrates | Toolchains / interface references |
|---|---|---|
| [Ada ↔ Zig](ada-zig/) | Ada driver calling a Zig-built native shared library | GNAT + [Zig](https://ziglang.org/) |
| [C ↔ C](c-c/) | C executable loading a C shared library at runtime (`dlopen`) | [GCC](https://gcc.gnu.org/) + POSIX `libdl` |
| [C ↔ Fortran](c-fortran/) | C driver linked with a Fortran recursive function | [GCC](https://gcc.gnu.org/) + [gfortran](https://gcc.gnu.org/fortran/) |
| [Fortran ↔ C](fortran-c/) | Fortran driver calling a C implementation | [gfortran](https://gcc.gnu.org/fortran/) + [GCC](https://gcc.gnu.org/) |
| [Julia ↔ C](julia-c/) | Julia driver using `ccall` to invoke a C shared library | [Julia](https://julialang.org/) + [GCC](https://gcc.gnu.org/) |
| [Julia ↔ Nim](julia-nim/) | Julia `ccall` into a Nim-built shared library | [Julia](https://julialang.org/) + [Nim](https://nim-lang.org/) |
| [Python ↔ Ada](python-ada/) | Python caller and a GNAT-compiled Ada library; README assumes older GNAT development headers | [Python](https://www.python.org/) + [GNAT](https://gcc.gnu.org/onlinedocs/gnat_ugn/) |
| [Python ↔ Basic](python-basic/) | Python caller and FreeBASIC shared library | [Python](https://www.python.org/) + [FreeBASIC](https://www.freebasic.net/) |
| [Python ↔ C](python-c/) | Python `ctypes` calling a C shared library; Python 2/3 variants | [Python](https://www.python.org/) + [GCC](https://gcc.gnu.org/) |
| [Python ↔ C / CFFI](python-c-cffi/) | Python `cffi.FFI().dlopen()` calling a C shared library | [CFFI](https://cffi.readthedocs.io/) + [GCC](https://gcc.gnu.org/) |
| [Python ↔ C++](python-cpp/) | Python caller with C++ compiled as a shared library | [Python](https://www.python.org/) + [G++](https://gcc.gnu.org/) |
| [Python ↔ D](python-d/) | Python calling a D shared library; DMD/LDC build recipes | [D](https://dlang.org/) + [Python](https://www.python.org/) |
| [Python ↔ D / CFFI](python-d-cffi/) | Python CFFI-style interface to a D shared library | [CFFI](https://cffi.readthedocs.io/) + [D](https://dlang.org/) |
| [Python ↔ Fortran](python-fortran/) | Python calling a gfortran-built shared library | [Python](https://www.python.org/) + [gfortran](https://gcc.gnu.org/fortran/) |
| [Python ↔ Fortran / CFFI](python-fortran-cffi/) | Python CFFI-style caller and Fortran shared library | [CFFI](https://cffi.readthedocs.io/) + [gfortran](https://gcc.gnu.org/fortran/) |
| [Python ↔ Go](python-go/) | Python calling a Go `-buildmode=c-shared` library | [Python](https://www.python.org/) + [Go](https://go.dev/) |
| [Python ↔ Nim](python-nim/) | Python calling a Nim `--app:lib` shared library | [Python](https://www.python.org/) + [Nim](https://nim-lang.org/) |
| [Python ↔ Nim / CFFI](python-nim-cffi/) | Python CFFI-style interface to a Nim library | [CFFI](https://cffi.readthedocs.io/) + [Nim](https://nim-lang.org/) |
| [Python ↔ Pascal](python-pascal/) | Python calling a Free Pascal-built library | [Python](https://www.python.org/) + [Free Pascal](https://www.freepascal.org/) |
| [Python ↔ Rust](python-rust/) | Python `ctypes` calling a Cargo-built Rust library | [Python](https://www.python.org/) + [Rust](https://www.rust-lang.org/) |
| [Python ↔ Rust / Slice](python-rust-slice/) | Python 2 `ctypes` example passing pointer and explicit length to Rust | [Python](https://www.python.org/) + [Rust](https://www.rust-lang.org/) |
| [Python ↔ Swift](python-swift/) | Python calling a Swift `-emit-library` shared library | [Python](https://www.python.org/) + [Swift](https://swift.org/) |
| [Python ↔ Zig](python-zig/) | Python calling a Zig native shared library; `zig build-lib` recipe | [Python](https://www.python.org/) + [Zig](https://ziglang.org/) |
| [R ↔ C ↔ C](r-c-c/) | R `.C()` interface to a C shared library built using `R CMD SHLIB` | [R](https://www.r-project.org/) + [C](https://gcc.gnu.org/) |
| [Ruby ↔ C](ruby-c/) | Ruby FFI gem calling a C shared library | [Ruby FFI](https://github.com/ffi/ffi) + [GCC](https://gcc.gnu.org/) |
| [Ruby ↔ D](ruby-d/) | Ruby FFI caller and DMD/LDC-generated library | [Ruby FFI](https://github.com/ffi/ffi) + [D](https://dlang.org/) |
| [Ruby ↔ Fortran](ruby-fortran/) | Ruby FFI caller and Fortran shared library | [Ruby FFI](https://github.com/ffi/ffi) + [gfortran](https://gcc.gnu.org/fortran/) |
| [Ruby ↔ Go](ruby-go/) | Ruby FFI caller and Go `c-shared` library | [Ruby FFI](https://github.com/ffi/ffi) + [Go](https://go.dev/) |
| [Ruby ↔ Nim](ruby-nim/) | Ruby FFI caller and Nim `--app:lib` library | [Ruby FFI](https://github.com/ffi/ffi) + [Nim](https://nim-lang.org/) |

In particular, the repositories illustrate several **different FFI mechanisms**, not just calling a second program: native shared libraries with C-compatible ABIs, dynamic linking (`dlopen`), Python `ctypes`, Python `cffi`, Julia `ccall`, R `.C()`, and Ruby FFI. These APIs have different ownership and ABI assumptions; a successful call is not by itself a portable interface contract.

## Language families and lineages

This is a **conceptual map, not a rigid taxonomy**. Arrows indicate major historical descent or influence; shared runtimes and similar syntax do not imply direct descent. A language may appear in more than one family.

### ALGOL, Pascal, Modula, and Oberon

- **ALGOL line:** ALGOL 60 influenced [ALGOL W](algol-w/) and [ALGOL 68](algol68/) along different branches. [Simula](simula/) extended ALGOL 60 with classes and coroutines and became an important ancestor of object-oriented programming.
- **Wirth line:** ALGOL W and other ALGOL ideas informed [Pascal](pascal/) → [Modula-2](modula2/) → [Oberon](oberon/). [Modula-3](modula3/) developed from Modula-2 ideas; [Zonnon](zonnon/) is a later Pascal/Modula/Oberon-family language.
- **Pascal extensions:** [SuperPascal](superpascal/) extends Pascal with structured concurrency; [Vector Pascal](vector-pascal/) extends it with array and SIMD operations. They are **parallel derivatives**, not sequential revisions of Pascal.

### BCPL, B, C, and C-influenced languages

- **Direct historical chain:** [BCPL](bcpl/) → [B](b/) → [C](c/).
- **C extensions and descendants:** [C++](cpp/) adds major object-oriented and generic features; [Cyclone](cyclone/) retains much of C's syntax while adding safer pointer/region typing. [D](dlang/) is heavily C/C++ influenced, but not a drop-in successor.
- **Other C-syntax relatives:** [Java](java/), [C#](csharp/), [JavaScript](javascript/), [TypeScript](typescript/), [Go](golang/), [Rust](rust/), [Zig](zig/), [Odin](odin/), and [V](v/) share varying C-style syntax or systems-programming goals; **they are not one linear genealogy**.

### Lisp, Scheme, and related functional languages

- **Lisp / Common Lisp:** [CLISP](clisp/) and [SBCL](sbcl/) implement Common Lisp.
- **Scheme:** [MIT Scheme](mit-scheme/), [Chez Scheme](chez/), [CHICKEN](chicken/), [Gambit](gambit/), [Guile](guile/), [Larceny](larceny/), [Vicare](vicare/), [Bigloo](bigloo/), and the [Stalin](stalin/) compiler cover several Scheme implementations and compilation strategies. [Racket](racket/) originated as a Scheme implementation and later expanded into a language-creation platform.
- **Other Lisp descendants:** [Clojure](clojure/) targets the JVM with persistent functional data structures. [F#](fsharp/) belongs principally to the ML/OCaml functional tradition rather than Scheme.

### BASIC, object-oriented, and managed-runtime languages

- **BASIC family:** [BASIC](basic/), [PureBasic](purebasic/), and [Visual Basic](vb/) reflect distinct dialects or descendants of BASIC, and should not be assumed source compatible.
- **JVM languages:** [Java](java/), [Kotlin](kotlin/), [Scala](scala/), [Groovy](groovy/), [Gosu](gosu/), and [Ceylon](ceylon/) share a runtime target, but have differing language origins. [Jython](jython/) is a Python implementation on that runtime.
- **.NET / CLR:** [C#](csharp/), [Visual Basic](vb/), [F#](fsharp/), [Boo](boo/), [Nemerle](nemerle/), the original [Cobra](cobra/), and [Niecza](niecza/) demonstrate different language designs on a common managed platform.
- **BEAM:** [Elixir](elixir/) builds on the Erlang virtual machine and ecosystem; unlike JVM/.NET languages above, its direct ancestor in runtime terms is Erlang (not represented by a standalone directory here).

### Python implementations and compilation routes

- [Python](python/) contains historical Python 2 and Python 3 programs. [PyPy](pypy/) runs Python with a JIT; [Jython](jython/) targets the JVM; [MicroPython](micropython/) targets constrained systems.
- [Cython](cython/) and [Cython (array variant)](cython-array/) compile a Python-derived language into extension code; [Numba](numba/) JIT-compiles selected Python functions. They are **alternative implementations or acceleration strategies**, not independent unrelated languages.

### REBOL, shells, scientific, and parallel language families

- **REBOL lineage:** [REBOL](rebol/) influenced [Boron](boron/) and [Red](red/).
- **Unix shells:** [Bash](bash/), [KornShell](ksh/), and [Zsh](zsh/) are related Bourne-shell descendants; [fish](fish/) is a different shell design. [PowerShell](powershell/) is object-pipeline oriented, not Bourne-shell compatible.
- **Scientific / array languages:** [Fortran](fortran/), [MATLAB](matlab/), [Octave](octave/), [Julia](julia/), [R](r/), [IDL/GDL](idl/), [Yorick](yorick/), [Maple](maple/), [Mathematica](mathematica/), and [SageMath](sage/) form an *application/ecosystem grouping*, not a single historical ancestry. MATLAB and Octave are intentionally related; SageMath uses Python as its interface language.
- **Concurrency / distributed / parallel experiments:** [Chapel](chapel/), [Regent](regent/), [X10](x10/), [ParaSail](parasail/), [Pony](pony/), [AmbientTalk](ambienttalk/), and [SuperPascal](superpascal/) illustrate distinct approaches to parallelism, actors, locality, and type-enforced concurrency.

## Versions and historical toolchains

**A language name is not a compiler version.** Unless a README records a number, a build recipe usually establishes only a toolchain *identity*. Source extensions, language syntax, target runtimes, and flags can narrow the dialect, but cannot by themselves establish a precise compiler release. In particular, the links above are references to upstream documentation, **not claims that their latest versions compile this code**.

Some identifiable cases worth retaining in future per-directory READMEs:

| Directory | Evidence in repository | What can responsibly be concluded |
|---|---|---|
| [`basic/`](basic/) | `fbc -O 3 outcomes.bas` | FreeBASIC compiler; exact release unknown |
| [`b/`](b/) | `ack -mlinux386` | Amsterdam Compiler Kit targeting a 32-bit Linux platform; exact ACK release unknown |
| [`algol-w/`](algol-w/) | `./aw2c` and generated `outcomes.c` | Companion ALGOL W → C compiler; exact build/version not recorded |
| [`cobra/`](cobra/) | `cobra ... -turbo:yes` and `.cobra` | Historical Chuck Esterbrook Cobra compiler, not one of the newer homonymous languages |
| [`cyclone/`](cyclone/) | `.cyc` and `cyclone outcomes.cyc` | Original Cyclone C dialect; compiler version and 64-bit support not established |
| [`idl/`](idl/) | `gdl -q run.idl` | GNU Data Language is the *implementation used*, rather than proprietary IDL |
| [`vb/`](vb/) | `vbc /optimize+ outcomes.vb` and `mono outcomes.exe` | Historical Visual Basic .NET compiler targeting the Mono CLR |
| [`niecza/`](niecza/) | `Niecza.exe outcomes.p` | CLR-targeted Perl 6 implementation; precise Niecza build unknown |
| [`python/`](python/) | `outcomes2.py`, `outcomes3.py` | Separate Python 2 / Python 3 source variants; Python 2 is end-of-life |
| [`python-ada/`](python-ada/) | Old `libgnatvsn7-dev`/GCC 7 library paths | Historical GNAT installation assumptions; adaptation likely needed on new systems |
| [`python-rust-slice/`](python-rust-slice/) | `xrange` in Python driver | Python 2 code even though the native library uses Rust |
| [`superpascal/`](superpascal/) | Separate compilation then `./interpret` | Per Brinch Hansen SuperPascal; see the companion Free Pascal port |

**Proposed per-language README convention** (to implement gradually): language and dialect; compiler/interpreter and exact tested version (or **unknown**); canonical upstream source/docs; prerequisites; build and run commands; observed results; portability notes; and date/platform of last *actual* verification. Historical commands should be preserved without silently replacing them.

## Directory conventions and historical artifacts

Most directories contain an `outcomes.*` driver and often a `partitions.*` helper, a short `README.md`, and an `outcomes.txt` transcript. Some tools emit C as an intermediate artifact; some scripts require a shared library, external runtime, or source files from a companion repository.

This repository expands the related [`octonion/puzzles/blackjack`](https://github.com/octonion/puzzles/tree/master/blackjack) collection. `recursion` covers **150** implementation directories, compared with **136** under `puzzles/blackjack`. All 136 directory names occur here, but a few files exist only in the earlier tree (including a compiled SuperPascal artifact and an optimized SBCL variant). Review those differences before consolidating.

## Build status and reproducibility

**Do not assume every example still builds.** Many READMEs preserve commands used at the time of development; there is currently no repository-wide CI matrix that verifies all 150 directories on modern toolchains.

For reproducible comparisons, record:

- Operating system and architecture, plus compiler/interpreter and version.
- Exact build and execution commands (including optimization flags).
- Whether the program completes and matches **all ten reference counts** and the total.
- Any patches needed for compatibility, and whether they change the algorithm.
- Timing methodology, if performance is being reported (including warmup, repetitions, and hardware).

A successful build is not necessarily a successful execution; and matching a total alone is weaker evidence than matching all ten counts. Historical `outcomes.txt` files serve as reference artifacts, **not evidence that a current toolchain has been tested**.

## Contributing

Contributions that recover older toolchains, document build dependencies, add missing language READMEs, repair portability problems, or expand regression tests are welcome. In particular:

1. Keep the original language implementation and historical notes intact where feasible; isolate modern compatibility changes.
2. Document the compiler/runtime version and a command that runs from the relevant language directory.
3. Report whether the output matches the ten reference counts above; distinguish untested code from a verified build.
4. Avoid calling measurements a cross-language benchmark unless algorithms, compilation settings, and measurement conditions are controlled.

A useful longer-term goal is an automated test matrix for readily available compilers, plus an optional, separately documented suite for historical and unsupported environments.

## License

[MIT](LICENSE). Copyright © 2018 Christopher D. Long.
