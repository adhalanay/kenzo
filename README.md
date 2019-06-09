# Welcome to Kenzo

[![GPLv3 Logo](http://www.gnu.org/graphics/gplv3-127x51.png)](http://www.gnu.org/licenses/gpl-3.0.en.html)
[![Travis Status](https://travis-ci.org/gheber/kenzo.svg?branch=master)](https://travis-ci.org/gheber/kenzo)

According to the title of its
[handbook](https://github.com/gheber/kenzo/blob/master/doc/Kenzo-Doc.pdf),
Kenzo is a "Symbolic Software for Effective Homology Computation" and
its main audience might be students and researchers in algebraic topology.
Have a look at the [overview](https://lisp.style/) to get a
sense for what's there for you to discover.

This repository contains a repackaged version of the Kenzo program by Francis
Sergeraert and collaborators. The original version of the program can be found
at http://www-fourier.ujf-grenoble.fr/~sergerar/Kenzo/ .
This version aims to update its infrastructure by providing the following:

1. A simple regression test suite based on [FiveAM](http://common-lisp.net/project/fiveam/)
2. Support for the great freely available Lisp compilers out there, including [CCL](http://ccl.clozure.com/), [ECL] (https://common-lisp.net/project/ecl/), [SBCL](http://www.sbcl.org/), etc.
3. Installation via the [Quicklisp](http://www.quicklisp.org/beta/) library manager
4. Updated documentation and examples runnable from [cl-jupyter](https://github.com/fredokun/cl-jupyter)

This work is well underway, but there are several outstanding [issues](https://github.com/gheber/kenzo/issues).

## Getting up and running

There are several methods to get going:

1. [Just play with it a little! (Live)](https://lisp.style/)
2. [Just give me a Docker container!](https://hub.docker.com/r/hapax/kenzo/)
3. Local installation via [Quicklisp](http://www.quicklisp.org/beta/) or ASDF

### Plain ASDF

To load Kenzo as provided by this repo, make sure ASDF knowns where to find
the source, e.g. by creating a link to this directory at

      ~/.local/share/common-lisp/source/

Then in your Lisp (e.g., in ECL) type
```lisp
(require :asdf)
(require :kenzo)
```

### Quicklisp

Assuming you have [Quicklisp](http://www.quicklisp.org/beta/), there isn't
really much to say here:

```
* (ql:quickload :kenzo)
To load "kenzo":
  Install 1 Quicklisp release:
    kenzo
; Fetching #<URL "http://beta.quicklisp.org/archive/kenzo/2015-08-04/kenzo-20150804-git.tgz">
; 1835.57KB
==================================================
1,879,625 bytes in 1.48 seconds (1236.91KB/sec)
; Loading "kenzo"
[package cat].....................................
..................................................
..............................
(:KENZO)
*
```

Similarly, you'd load Kenzo via `(ql:quickload :kenzo)`.

### Three Kenzo versions for the price of one (free!)

This release contains three Kenzo versions `1.1.[7,8,9]`. For backward
compatibility, the default version is still `1.1.7`. There are separate
packages `cat-[7,8,9]` for the different versions and `cat` and `kenzo`
are package nicknames for `cat-7`:

```
* (ql:quickload :kenzo)
To load "kenzo":
  Load 1 ASDF system:
    kenzo
; Loading "kenzo"

(:KENZO)
* (in-package :cat)
#<PACKAGE "CAT-7">
* (kenzo-version)

*** Kenzo-Version 1.1.7 ***

* (in-package :kenzo)
#<PACKAGE "CAT-7">
* (kenzo-version)

*** Kenzo-Version 1.1.7 ***
*
```

You can change that, for example, by `RENAME-PACKAGE` or `USE-PACKAGE`:

```
* (ql:quickload :kenzo)
To load "kenzo":
  Load 1 ASDF system:
    kenzo
; Loading "kenzo"

(:KENZO)
* (rename-package 'cat-7 'cat-old)
#<PACKAGE "CAT-OLD">
* (rename-package 'cat-9 'cat-new '(cat kenzo))
#<PACKAGE "CAT-NEW">
* (cat:kenzo-version)

*** Kenzo-Version 9 ***
*
```
