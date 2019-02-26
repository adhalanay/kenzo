;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

;;;  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS
;;;  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS
;;;  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS  MACROS

(IN-PACKAGE #:cat)

(PROVIDE "macros")


;;;
;;; UTILITIES


(defmacro def (name value)
  (declare (type symbol name))
  "-----------------------------------------------------------------[macro-doc]
DEF
Args: (name value)
Defines a dynamic variable NAME in the CL-USER package, assigns it VALUE,
and returns VALUE.
------------------------------------------------------------------------------"
  `(progn
     (intern (symbol-name ',name))
     (defparameter ,name nil)
     (setq ,name ,value)))


;;;
;;;  VARIOUS
;;;

(DEFMACRO -1-EXPT-N (n)
  `(the fixnum (if (evenp (the fixnum ,n)) 1 -1)))


(DEFMACRO -1-EXPT-N+1 (n)
  `(the fixnum (if (evenp (the fixnum ,n)) -1 1)))


(DEFMACRO -1-EXPT-N-1 (n)
  `(-1-expt-n+1 ,n))


(DEFMACRO 2-EXP (n)
  `(aref +2-exp+ ,n))


(DEFMACRO MASK (n)
  `(aref +mask+ ,n))


(DEFMACRO BINOMIAL-P-Q (p q)
  `(binomial-n-p (+ ,p ,q) ,p))

;;;
;;;  COMBINATIONS
;;;

(DEFMACRO LEXICO (&rest rest)
  (unless (cdr rest)
    (return-from lexico (first rest)))
  (let ((vrslt (gensym)))
    `(let ((,vrslt ,(first rest)))
       (declare (type cmpr ,vrslt))
       (if (eq ,vrslt :equal)
           (lexico ,@(rest rest))
           ,vrslt))))


(DEFMACRO TERM (cffc gnrt)
  `(cons ,cffc ,gnrt))


(DEFMACRO -TERM (mark)
  `(car ,mark))


(DEFMACRO CFFC (term)
  "-----------------------------------------------------------------[macro-doc]
CFFC
Args: (term)
Returns the the coefficient (integer) of a term.
------------------------------------------------------------------------------"
  `(car ,term))


(DEFMACRO -CFFC (mark)
  `(caar ,mark))


(DEFMACRO GNRT (term)
  "-----------------------------------------------------------------[macro-doc]
GNRT
Args: (term)
Returns the the generator of a term.
------------------------------------------------------------------------------"
  `(cdr ,term))


(DEFMACRO -GNRT (mark)
  `(cdar ,mark))


(DEFMACRO WITH-TERM ((cffc gnrt) term . body)
  `(let (,@(if cffc `((,cffc (cffc ,term))) nil)
         ,@(if gnrt `((,gnrt (gnrt ,term))) nil))
     (declare
      (fixnum ,@(if cffc `(,cffc) nil))
      (type gnrt ,@(if gnrt `(,gnrt) nil)))
     ,@body))


(DEFMACRO WITH--TERM ((cffc gnrt) mark . body)
  `(let ((,cffc (-cffc ,mark))
         (,gnrt (-gnrt ,mark)))
     (declare
      (fixnum ,cffc)
      (type gnrt ,gnrt))
     ,@body))


(DEFMACRO WITH-CMBN ((degr list) cmbn . body)
  `(let ((,degr (cmbn-degr ,cmbn))
         (,list (cmbn-list ,cmbn)))
     (declare
      (fixnum ,degr)
      (list ,list))
     ,@body))


(DEFMACRO TERM-CMBN (degr cffc gnrt)
  "-----------------------------------------------------------------[macro-doc]
TERM-CMBN
Args: (degr cffc gnrt)
Returns the combination of degree DEGR with the only term CFFC*GNRT.
------------------------------------------------------------------------------"
  `(make-cmbn :degr ,degr
              :list (list (term ,cffc ,gnrt))))


(DEFMACRO CMBN-NON-ZERO-P (cmbn)
  "-----------------------------------------------------------------[macro-doc]
CMBN-NON-ZERO-P
Args: (cmbn)
Tests if the combination CMBN is a non-null combination of any degree.
------------------------------------------------------------------------------"
  `(not (null (cmbn-list ,cmbn))))


(DEFMACRO CMBN-ZERO-P (cmbn)
  "-----------------------------------------------------------------[macro-doc]
CMBN-ZERO-P
Args: (cmbn)
Tests if the combination CMBN is the null combination of any degree.
------------------------------------------------------------------------------"
  `(null (cmbn-list ,cmbn)))


(DEFMACRO CONTROL (cmpr cmbn)
  (if *cmbn-control*
      `(do-control ,cmpr ,cmbn)
      cmbn))


(DEFMACRO CONTROLN (cmpr cmbn)
  (if *cmbn-control*
      `(do-control ,cmpr ,cmbn)
      nil))


(DEFVAR *WRONG-CMBN*)


;;;
;;;  CHAIN-COMPLEXES
;;;

(DEFMACRO CMPR (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
CMPR
Args: (&rest rest)
Args: (chcm gnrt1 gnrt2)
Typically invoked with a chain complex CHCM and two generators GNRT1 and GNRT2.
Applies the comparison function associated with CHCM to GNRT1 and GNRT2, and
return the result.
------------------------------------------------------------------------------"
  (ecase (length rest)
    (1 `(cmpr1 ,@rest))
    (3 `(cmpr3 ,@rest))))


(DEFMACRO CMPR3 (object item1 item2)
  `(funcall (cmpr1 ,object) ,item1 ,item2))


(DEFMACRO BASIS (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
BASIS
Args: (&rest rest)
Args: (chcm)
Args: (chcm n)
Args: (chcm n :dgnr)
When invoked with only one argument, returns the function attached to the slot
BASIS of the chain complex.
When invoked with two arguments, returns the basis of the group of degree N of
 the chain complex.
When invoked with three arguments, the keyword :DGNR, it also returns the
degenerate elements of the basis in degree N.
This function returns an error if the chain complex is locally effective.
------------------------------------------------------------------------------"
  (ecase (length rest)
    (1 `(basis1 ,@rest))
    (2 `(basis2 ,@rest))
    (3 `(basis3 ,@rest))))


(DEFMACRO BASIS3 (smst dmns keyword)
  (declare (ignore keyword))
  `(a-basis2 (basis ,smst) ,dmns))


(DEFMACRO DFFR (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
DFFR
Args: (&rest rest)
Args: (chcm cmbn)
Args: (chcm degr gnrt)
Applies the differential morphism of the chain complex CHCM to a combination
CMBN or a generator GNRT of a degree DEGR.
See also the macro ?.
------------------------------------------------------------------------------"
  (ecase (length rest)
    (1 `(dffr1 ,@rest))
    ((2 3) `(? (dffr1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO ? (&rest rest)
  (ecase (length rest)
    (2 `(?2 ,@rest))
    (3 `(?3 ,@rest))))

;;;
;;;  CHCM-ELEMENTARY-OP
;;;

(DEFMACRO I-CMPS (mrph1 &rest rest)
  (if rest
      `(cmps ,mrph1 (i-cmps ,@rest))
      mrph1))


(DEFMACRO I-ADD (mrph1 &rest rest)
  (if rest
      `(add ,mrph1 (i-add ,@rest))
      mrph1))


(DEFMACRO I-SBTR (mrph1 mrph2 &rest rest)
  `(sbtr ,mrph1 (i-add ,mrph2 ,@rest)))


;;;
;;;  EFFECTIVE HOMOLOGY
;;;

(DEFMACRO BCC (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
BCC
Args: (&rest rest)
Args: (rdct)
Args: (rdct cmbn)
Args: (rdct degr gnrt)
With only one argument, a reduction RDCT, this macro returns the bottom
chain complex of the reduction. Otherwise, it applies the differential of
the bottom chain complex of RDCT to a combination provided in additional
arguments such as CMBN or DEGR GNRT.
------------------------------------------------------------------------------"
  (case (length rest)
    (1 `(bcc1 ,@rest))
    (otherwise
     `(? (bcc1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO TCC (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
TCC
Args: (&rest rest)
Args: (rdct)
Args: (rdct cmbn)
Args: (rdct degr gnrt)
With only one argument, a reduction RDCT, this macro returns the top
chain complex of the reduction. Otherwise, it applies the differential of
the top chain complex of RDCT to a combination provided in additional
arguments such as CMBN or DEGR GNRT.
------------------------------------------------------------------------------"
  (case (length rest)
    (1 `(tcc1 ,@rest))
    (otherwise
     `(? (tcc1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO F (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
F
Args: (&rest rest)
Args: (rdct)
Args: (rdct cmbn)
Args: (rdct degr gnrt)
With only one argument, a reduction RDCT, this macro returns the morphism f
of the reduction. Otherwise, it applies f to a combination provided in
additional arguments such as CMBN or DEGR GNRT.
------------------------------------------------------------------------------"
  (case (length rest)
    (1 `(f1 ,@rest))
    (otherwise
     `(? (f1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO G (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
G
Args: (&rest rest)
Args: (rdct)
Args: (rdct cmbn)
Args: (rdct degr gnrt)
With only one argument, a reduction RDCT, this macro returns the morphism g
of the reduction. Otherwise, it applies g to a combination provided in
additional arguments such as CMBN or DEGR GNRT.
------------------------------------------------------------------------------"
  (case (length rest)
    (1 `(g1 ,@rest))
    (otherwise
     `(? (g1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO H (&rest rest)
  "-----------------------------------------------------------------[macro-doc]
H
Args: (&rest rest)
Args: (rdct)
Args: (rdct cmbn)
Args: (rdct degr gnrt)
With only one argument, a reduction RDCT, this macro returns the morphism h
of the reduction. Otherwise, it applies h to a combination provided in
additional arguments such as CMBN or DEGR GNRT.
------------------------------------------------------------------------------"
  (case (length rest)
    (1 `(h1 ,@rest))
    (otherwise
     `(? (h1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO LBCC (&rest rest)
  (case (length rest)
    (1 `(lbcc1 ,@rest))
    (otherwise
     `(? (lbcc1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO RBCC (&rest rest)
  (case (length rest)
    (1 `(rbcc1 ,@rest))
    (otherwise
     `(? (rbcc1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO LF (&rest rest)
  (case (length rest)
    (1 `(lf1 ,@rest))
    (otherwise
     `(? (lf1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO LG (&rest rest)
  (case (length rest)
    (1 `(lg1 ,@rest))
    (otherwise
     `(? (lg1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO LH (&rest rest)
  (case (length rest)
    (1 `(lh1 ,@rest))
    (otherwise
     `(? (lh1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO RF (&rest rest)
  (case (length rest)
    (1 `(rf1 ,@rest))
    (otherwise
     `(? (rf1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO RG (&rest rest)
  (case (length rest)
    (1 `(rg1 ,@rest))
    (otherwise
     `(? (rg1 ,(first rest)) ,@(rest rest)))))


(DEFMACRO RH (&rest rest)
  (case (length rest)
    (1 `(rh1 ,@rest))
    (otherwise
     `(? (rh1 ,(first rest)) ,@(rest rest)))))

;;;
;;;  HOMOLOGY-GROUPS
;;;

(DEFMACRO BASELIG (mat n)
  `(aref (leftcol ,mat) ,n))


(DEFMACRO BASECOL (mat n)
  `(aref (uplig ,mat) ,n))

;;;
;;;  CONES
;;;

(DEFMACRO CON0 (gnrt)
  `(make-cone :conx 0 :icon ,gnrt))


(DEFMACRO CON1 (gnrt)
  `(make-cone :conx 1 :icon ,gnrt))


(DEFMACRO WITH-CONE ((conx icon) cone . body)
  (let ((scone (gensym)))
    (declare (symbol scone))
    `(let ((,scone ,cone))
       (declare (type cone ,scone))
       (let ((,conx (conx ,scone))
             (,icon (icon ,scone)))
         (declare (type (member 0 1) ,conx) (type gnrt ,icon))
         ,@body))))


(DEFMACRO BCNB (gnrt)
  "(BCNB GNRT) returns the representation of the generator GNRT belonging to
the chain complex B."
  `(make-bicn :bcnx :bcnb :ibicn ,gnrt))


(DEFMACRO BCNC (gnrt)
  "(BCNC GNRT) returns the representation of the generator GNRT belonging to
the chain complex C."
  `(make-bicn :bcnx :bcnc :ibicn ,gnrt))


(DEFMACRO BCND (gnrt)
  "(BCND GNRT) returns the representation of the generator GNRT belonging to
the chain complex D."
  `(make-bicn :bcnx :bcnd :ibicn ,gnrt))


(DEFMACRO WITH-BICN ((bcnx ibicn) bicn . body)
  `(let ((,bcnx (bcnx ,bicn))
         (,ibicn (ibicn ,bicn)))
     (declare
      (type (member :bcnb :bcnc :bcnd) ,bcnx)
      (type gnrt ,ibicn))
     ,@body))

;;;
;;;  TENSOR PRODUCTS
;;;

#|
(DEFMACRO TNPR (degr1 gnrt1 degr2 gnrt2)
  `(cons :tnpr (cons (cons ,degr1 ,gnrt1) (cons ,degr2 ,gnrt2))))

(DEFMACRO DEGR1 (tnpr)
  `(caadr ,tnpr))

(DEFMACRO GNRT1 (tnpr)
  `(cdadr ,tnpr))

(DEFMACRO DEGR2 (tnpr)
  `(caddr ,tnpr))

(DEFMACRO GNRT2 (tnpr)
  `(cdddr ,tnpr))
|#
(DEFMACRO TNPR (degr1 gnrt1 degr2 gnrt2)
  `(make-tnpr :degr1 ,degr1 :gnrt1 ,gnrt1
              :degr2 ,degr2 :gnrt2 ,gnrt2))


(DEFMACRO WITH-TNPR ((degr1 gnrt1 degr2 gnrt2) tnpr . body)
  `(let (,@(if degr1 `((,degr1 (degr1 ,tnpr))) nil)
         ,@(if gnrt1 `((,gnrt1 (gnrt1 ,tnpr))) nil)
           ,@(if degr2 `((,degr2 (degr2 ,tnpr))) nil)
           ,@(if gnrt2 `((,gnrt2 (gnrt2 ,tnpr))) nil))
     (declare
      (fixnum ,@(if degr1 `(,degr1) nil) ,@(if degr2 `(,degr2) nil))
      (type gnrt ,@(if gnrt1 `(,gnrt1) nil) ,@(if gnrt2 `(,gnrt2) nil)))
     ,@body))

;;;
;;;  COALGEBRAS
;;;

(DEFMACRO CPRD (&rest rest)
  (case (length rest)
    (1 `(cprd1 ,@rest))
    ((2 3) `(? (cprd1 ,(first rest)) ,@(rest rest)))))

;;;
;;;  COBAR
;;;

(DEFMACRO CBGN (degr gnrt)
  `(cons ,degr ,gnrt))


(DEFMACRO CDEGR (cbgn)
  `(car ,cbgn))


(DEFMACRO CGNRT (cbgn)
  `(cdr ,cbgn))


(DEFMACRO -CDEGR (cbgn)
  `(caar ,cbgn))


(DEFMACRO -CGNRT (cbgn)
  `(cdar ,cbgn))


(DEFMACRO WITH-CBGN ((cdegr cgnrt) cbgn . body)
  `(let ((,cdegr (cdegr ,cbgn))
         (,cgnrt (cgnrt ,cbgn)))
     (declare
      (fixnum ,cdegr)
      (type gnrt ,cgnrt))
     ,@body))


(DEFMACRO WITH--CBGN ((cdegr cgnrt) cbgn . body)
  `(let ((,cdegr (-cdegr ,cbgn))
         (,cgnrt (-cgnrt ,cbgn)))
     (declare
      (fixnum ,cdegr)
      (type gnrt ,cgnrt))
     ,@body))


(DEFMACRO WITH-ALLP ((list) allp . body)
  `(let ((,list (allp-list ,allp)))
     (declare (list ,list))
     ,@body))


(DEFMACRO GNRT-ALLP-TNPR (degr gnrt allp)
  `(make-allp :list (cons (cbgn (1- ,degr) ,gnrt) ,allp)))


;;;
;;;  ALGEBRAS
;;;

(DEFMACRO APRD (&rest rest)
  (case (length rest)
    (1 `(aprd1 ,@rest))
    ((2 3) `(? (aprd1 ,(first rest)) ,@(rest rest)))))

;;;
;;;  BAR
;;;

(DEFMACRO BRGN (degr gnrt)
  `(cons ,degr ,gnrt))


(DEFMACRO BDEGR (brgn)
  `(car ,brgn))


(DEFMACRO BGNRT (brgn)
  `(cdr ,brgn))


(DEFMACRO -BDEGR (brgn)
  `(caar ,brgn))


(DEFMACRO -BGNRT (brgn)
  `(cdar ,brgn))


(DEFMACRO WITH-BRGN ((bdegr bgnrt) brgn . body)
  `(let ((,bdegr (bdegr ,brgn))
         (,bgnrt (bgnrt ,brgn)))
     (declare
      (fixnum ,bdegr)
      (type gnrt ,bgnrt))
     ,@body))


(DEFMACRO WITH--BRGN ((bdegr bgnrt) brgn . body)
  `(let ((,bdegr (-bdegr ,brgn))
         (,bgnrt (-bgnrt ,brgn)))
     (declare
      (fixnum ,bdegr)
      (type gnrt ,bgnrt))
     ,@body))


#|
(DEFMACRO MAKE-ABAR (&key list)
  `(cons :abar ,list))

(DEFMACRO ABAR-LIST (abar)
  `(cdr ,abar))
|#

(DEFMACRO WITH-ABAR ((list) abar . body)
  `(let ((,list (abar-list ,abar)))
     (declare (list ,list))
     ,@body))


#|
(DEFMACRO MAKE-GBAR (&key dmns list)
  `(cons :gbar (cons ,dmns ,list)))

(DEFMACRO GBAR-DMNS (gbar)
  `(cadr ,gbar))

(DEFMACRO GBAR-LIST (gbar)
  `(cddr ,gbar))
|#


(DEFMACRO WITH-GBAR ((dmns list) gbar . body)
  `(let ((,dmns (gbar-dmns ,gbar))
         (,list (gbar-list ,gbar)))
     (declare
      (fixnum ,dmns)
      (list ,list))
     ,@body))

#|
(DEFMACRO GNRT-GBAR-TNPR (degr gnrt gbar)
  `(make-gbar :list (cons (brgn (1- ,degr) ,gnrt) ,gbar)))
|#


;;;
;;;  SIMPLICIAL SETS
;;;


#|
(DEFMACRO ABSM (dgop gmsm)
  `(cons :absm (cons ,dgop ,gmsm)))

(DEFMACRO DGOP (absm)
  `(cadr ,absm))

(DEFMACRO GMSM (absm)
  `(cddr ,absm))
|#

(DEFMACRO ABSM (dgop gmsm)
  `(make-absm :dgop ,dgop :gmsm ,gmsm))


(DEFMACRO WITH-ABSM ((dgop-var gmsm-var) absm . body)
  (let ((sabsm (gensym)))
    `(let ((,sabsm ,absm))
       (declare (type absm ,sabsm))
       (let ((,dgop-var (dgop ,sabsm))
             (,gmsm-var (gmsm ,sabsm)))
         (declare
          (fixnum ,dgop-var)
          (type gmsm ,gmsm-var))
         ,@body))))


(DEFMACRO DEGENERATE-P (absm)
  `(plusp (dgop ,absm)))


(DEFMACRO NON-DEGENERATE-P (absm)
  `(zerop (dgop ,absm)))


(DEFMACRO BSPN (smst)
  `(bsgn ,smst))


(DEFMACRO BNDR (&rest rest)
  `(dffr ,@rest))


(DEFMACRO DGNL (&rest rest)
  `(cprd ,@rest))


(DEFMACRO FACE (&rest rest)
  (ecase (length rest)
    (1 `(face1 ,@rest))
    (4 `(face4 ,@rest))))

;;;
;;;  DELTA
;;;

(DEFMACRO D (igmsm)
  `(cons :delt ,igmsm))

;;;
;;;  SPECIAL-SMSTS
;;;

;;; GMSM-FACES-INFO = (gmsm (simple-vector absm) . bndr)
;;;                         faces

(DEFMACRO MAKE-GMSM-FACES-INFO (&key gmsm faces bndr)
  `(cons ,gmsm (cons ,faces ,bndr)))


(DEFMACRO INFO-GMSM (gmsm-faces-info)
  `(car ,gmsm-faces-info))


(DEFMACRO INFO-FACES (gmsm-faces-info)
  `(cadr ,gmsm-faces-info))


(DEFMACRO INFO-FACE-I (gmsm-faces-info i)
  `(svref (cadr ,gmsm-faces-info) ,i))


(DEFMACRO INFO-BNDR (gmsm-faces-info)
  `(cddr ,gmsm-faces-info))

;;;
;;;  CARTESIAN PRODUCTS
;;;

#|
(DEFMACRO CRPR (&rest rest)
  (ecase (length rest)
    (2 `(cons :crpr (cons (cdr ,(first rest)) (cdr ,(second rest)))))
    (4 `(cons :crpr (cons
                     (cons ,(first rest) ,(second rest))
                     (cons ,(third rest) ,(fourth rest)))))))
|#
(DEFMACRO CRPR (&rest rest)
  (ecase (length rest)
    (2 `(crpr2 ,@rest))
    (4 `(crpr4 ,@rest))))


(DEFMACRO CRPR2 (absm1 absm2)
  `(crpr4 (dgop ,absm1) (gmsm ,absm1) (dgop ,absm2) (gmsm ,absm2)))


(DEFMACRO CRPR4 (dgop1 gmsm1 dgop2 gmsm2)
  `(make-crpr :dgop1 ,dgop1 :gmsm1 ,gmsm1
              :dgop2 ,dgop2 :gmsm2 ,gmsm2))


#|
(DEFMACRO DGOP1 (crpr)
  `(caadr ,crpr))

(DEFMACRO GMSM1 (crpr)
  `(cdadr ,crpr))

(DEFMACRO DGOP2 (crpr)
  `(caddr ,crpr))

(DEFMACRO GMSM2 (crpr)
  `(cdddr ,crpr))

(DEFMACRO ABSM1 (crpr)
  `(cons :absm (cadr ,crpr)))

(DEFMACRO ABSM2 (crpr)
  `(cons :absm (cddr ,crpr)))
|#
(DEFMACRO ABSM1 (crpr)
  `(absm (dgop1 ,crpr) (gmsm1 ,crpr)))


(DEFMACRO ABSM2 (crpr)
  `(absm (dgop2 ,crpr) (gmsm2 ,crpr)))


(DEFMACRO WITH-CRPR (&rest rest)
  (ecase (length (first rest))
    (2 `(with-crpr-2 ,@rest))
    (4 `(with-crpr-4 ,@rest))))


#|
(DEFMACRO WITH-CRPR-2 ((absm1 absm2) crpr . body)
  `(let ((,absm1 (cons :absm (cadr ,crpr)))
         (,absm2 (cons :absm (cddr ,crpr))))
     (declare (type absm ,absm1 ,absm2))
     ,@body))
|#

(DEFMACRO WITH-CRPR-2 ((absm1 absm2) crpr . body)
  `(let ((,absm1 (absm (dgop1 ,crpr) (gmsm1 ,crpr)))
         (,absm2 (absm (dgop2 ,crpr) (gmsm2 ,crpr))))
     (declare (type absm ,absm1 ,absm2))
     ,@body))


(DEFMACRO WITH-CRPR-4 ((dgop1 gmsm1 dgop2 gmsm2) crpr . body)
  `(let ((,dgop1 (dgop1 ,crpr))
         (,gmsm1 (gmsm1 ,crpr))
         (,dgop2 (dgop2 ,crpr))
         (,gmsm2 (gmsm2 ,crpr)))
     (declare
      (fixnum ,dgop1 ,dgop2)
      (type gmsm ,gmsm1 ,gmsm2))
     ,@body))

;;;
;;;  EILENBERG-ZILBER
;;;

(DEFMACRO EILENBERG-ZILBER (&rest rest)
  `(ez ,@rest))

;;;
;;;  KAN
;;;

(DEFMACRO KFLL (&rest rest)
  (ecase (length rest)
    (1 `(kfll1 ,@rest))
    (4 `(kfll4 ,@rest))))

(DEFMACRO KFLL4 (kan indx dmns hat)
  `(funcall (kfll1 ,kan) ,indx ,dmns ,hat))


;;;
;;;  SIMPLICIAL-GROUP
;;;

(DEFMACRO GRML (smgr &rest rest)
  (ecase (length rest)
    (0 `(grml1 ,smgr))
    ((1 2) `(? (grml1 ,smgr) ,@rest))))


(DEFMACRO GRIN (smgr &rest rest)
  (case (length rest)
    (0 `(grin1 ,smgr))
    (otherwise `(? (grin1 ,smgr) ,@rest))))


(DEFMACRO BUILD-AB-SMGR (&rest rest)
  `(change-class (build-smgr ,@rest) 'ab-simplicial-group))

;;;
;;;  LOOP SPACES
;;;

(DEFMACRO POWR (gmsm expn)
  `(cons ,gmsm ,expn))


(DEFMACRO PGMSM (powr)
  `(car ,powr))


(DEFMACRO EXPN (powr)
  `(cdr ,powr))


(DEFMACRO WITH-POWR ((gmsm expn) powr . body)
  `(let ((,gmsm (car ,powr))
         (,expn (cdr ,powr)))
     (declare
      (type gmsm ,gmsm)
      (fixnum expn))
     ,@body))


(DEFMACRO WITH-APOWR ((dgop gmsm expn) apowr . body)
  `(let ((,dgop (apdgop ,apowr))
         (,gmsm (cadr ,apowr))
         (,expn (cddr ,apowr)))
     (declare
      (fixnum ,dgop ,expn)
      (type gmsm ,gmsm))
     ,@body))


(DEFMACRO APOWR (dgop gmsm expn)
  `(cons ,dgop (cons ,gmsm ,expn)))


(DEFMACRO APDGOP (apowr)
  `(car ,apowr))


(DEFMACRO APGMSM (apowr)
  `(cadr ,apowr))


(DEFMACRO APEXPN (apowr)
  `(cddr ,apowr))

;;;
;;;  SMITH
;;;

(DEFMACRO LINE-NUMBER (mtrx)
  `(first (array-dimensions ,mtrx)))


(DEFMACRO COLUMN-NUMBER (mtrx)
  `(second (array-dimensions ,mtrx)))


(DEFMACRO LINE-OP-5 (mtrx-list begin lambda line1 line2)
  (let ((slambda (gensym)))
    `(let ((,slambda ,lambda))
       (column-op (first ,mtrx-list) 0 (- ,slambda) ,line2 ,line1)
       (line-op (second ,mtrx-list) 0 ,slambda ,line1 ,line2)
       (line-op (third ,mtrx-list) ,begin ,slambda ,line1 ,line2))))


(DEFMACRO COLUMN-OP-5 (mtrx-list begin lambda column1 column2)
  (let ((slambda (gensym)))
    `(let ((,slambda ,lambda))
       (column-op (third ,mtrx-list) ,begin ,slambda ,column1 ,column2)
       (column-op (fourth ,mtrx-list) 0 ,slambda ,column1 ,column2)
       (line-op (fifth ,mtrx-list) 0 (- ,slambda) ,column2 ,column1))))


(DEFMACRO LINE-SWAP-5 (mtrx-list begin line1 line2)
  `(progn
     (column-swap (first ,mtrx-list) 0 ,line1 ,line2)
     (line-swap (second ,mtrx-list) 0 ,line1 ,line2)
     (line-swap (third ,mtrx-list) ,begin ,line1 ,line2)))


(DEFMACRO COLUMN-SWAP-5 (mtrx-list begin column1 column2)
  `(progn
     (column-swap (third ,mtrx-list) ,begin ,column1 ,column2)
     (column-swap (fourth ,mtrx-list) 0 ,column1 ,column2)
     (line-swap (fifth ,mtrx-list) 0 ,column1 ,column2)))


(DEFMACRO LINE-MINUS-5 (mtrx-list begin line)
  `(progn
     (column-minus (first ,mtrx-list) 0 ,line)
     (line-minus (second ,mtrx-list) 0 ,line)
     (line-minus (third ,mtrx-list) ,begin ,line)))


(DEFMACRO COLUMN-MINUS-5 (mtrx-list begin column)
  `(progn
     (column-minus (third ,mtrx-list) ,begin ,column)
     (column-minus (fourth ,mtrx-list) 0 ,column)
     (line-minus (fifth ,mtrx-list) 0 ,column)))


(DEFMACRO GNRT-NAME (i)
  `(intern (format nil "GN-~D" ,i) +gnrts-pckg+))
