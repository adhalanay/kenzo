;;;  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR
;;;  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR
;;;  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR  BAR

;;;
;;;  MAC-LANE signs (p. 306)
;;;

(IN-PACKAGE "COMMON-LISP-USER")

(PROVIDE "bar")

(DEFUN ABAR (&rest list)
  (when (= 1 (length list))
    (setf list (first list)))
  (unless (evenp (length list))
    (error "In ABAR, the length list should be even."))
  (the abar
    (let ((rslt +empty-list+))
      (declare (list rslt))
      (do ((mark list (cddr mark)))
          ((endp mark))
        (declare (list mark))
        (push (brgn (car mark) (cadr mark)) rslt))
        (make-abar :list (nreverse rslt)))))
#|
()
(abar )
(abar '(2 a 3 b))
(abar 2 'a 3 'b)
(abar 2 'a 3))  ;; error
|#

(DEFINE-CONSTANT +NULL-ABAR+ (make-abar :list +empty-list+))


(DEFUN BAR-CMPR (cmpr)
  (declare (type cmprf cmpr))
  (flet ((rslt (abar1 abar2)
               (declare (type abar abar1 abar2))
               (the cmpr
                 (let ((list1 (abar-list abar1))
                       (list2 (abar-list abar2)))
                   (declare (list list1 list2))
                   (lexico
                    (f-cmpr (length list1) (length list2))
                    (maplexico
                     #'(lambda (brgn1 brgn2)
                         (lexico
                          (f-cmpr (bdegr brgn1) (bdegr brgn2))
                          (funcall cmpr (bgnrt brgn1) (bgnrt brgn2))))
                     list1 list2))))))
    (the cmprf #'rslt)))

#|
  (setf r (bar-cmpr #'s-cmpr))
  (funcall r (abar) (abar))
  (funcall r (abar 3 'a) (abar))
  (funcall r (abar 3 'a) (abar 2 'a 1 'b))
  (funcall r (abar 3 'a) (abar 3 'b))
  (funcall r (abar 3 'a) (abar 3 'a)))
|#

(DEFUN BAR-BASIS-LENGTH (basis degr length)
  (declare
   (type basis basis)
   (type fixnum degr length))
  (the list
    (progn
      (when (= 1 length)
        (return-from bar-basis-length
          (mapcar
              #'(lambda (item)
                  (declare (type gnrt item))
                  (list (brgn degr item)))
            (funcall basis (1- degr)))))
      (when (< degr 4)
        (return-from bar-basis-length +empty-list+))
      (mapcan
          #'(lambda (degr1)
              (declare (type fixnum degr1))
              (let ((list1 (funcall basis (1- degr1)))
                    (list2 (bar-basis-length
                            basis (- degr degr1) (1- length))))
                (declare (list list1 list2))
                (mapcan
                    #'(lambda (item1)
                        (declare (type gnrt item1))
                        (mapcar
                            #'(lambda (item2)
                                (declare (type iabar item2))
                                (cons (brgn degr1 item1) item2))
                          list2))
                  list1)))
        (>a-b< 1 (1- degr))))))

#|
()
(setf basis #'(lambda (degr)
                (list degr)))
(bar-basis-length basis 2 1)
(bar-basis-length basis 2 2)
(bar-basis-length basis 3 1)
(bar-basis-length basis 3 2)
(bar-basis-length basis 4 1)
(bar-basis-length basis 4 2)
(bar-basis-length basis 4 3)
(bar-basis-length basis 4 4)
(bar-basis-length basis 8 1)
(bar-basis-length basis 8 2)
(bar-basis-length basis 8 3)
(bar-basis-length basis 8 4)
(bar-basis-length basis 8 5)
(bar-basis-length basis 8 6)
(bar-basis-length basis 8 11))
|#

(DEFUN BAR-BASIS (basis)
  (declare (type basis basis))
  (the basis
    (progn
      (when (eq :locally-effective basis)
        (return-from bar-basis :locally-effective))
      (flet
          ((rslt (degr)
                 (declare (type fixnum degr))
                 (cond ((zerop degr) (list +null-abar+))
                       ((< degr 2) +empty-list+)
                       (t
                        (mapcan
                            #'(lambda (length)
                                (declare (type fixnum length))
                                (mapcar
                                    #'(lambda (iabar)
                                        (declare (type iabar iabar))
                                        (make-abar :list iabar))
                                  (bar-basis-length basis degr length)))
                          (>a-b> 0 (floor degr 2)))))))
        #'rslt))))

#|
()
(setf basis #'(lambda (degr)
                (list degr)))
(setf r (bar-basis basis))
(funcall r 0)
(funcall r 1)
(funcall r 2)
(dotimes (i 7)
  (print (funcall r i)))
(bar-basis :locally-effective))
|#

(DEFUN BAR-INTR-VRTC-DFFR (dffr)
  (declare (type morphism dffr))
  (labels
      ((rslt 
        (degr iabar)
        ;; the argument iabar is an internal algebraic bar,
        ;;     without the keyword :abar
        ;; rslt returns an internal combination
        ;;     without the keyword :cmbn, without degree
        (declare
         (type fixnum degr)
         (type iabar iabar))
        (progn
          (unless iabar
            (return-from rslt +empty-list+))
          (let ((brgn1 (first iabar))
                (rest2 (rest iabar)))
            (declare
             (type brgn brgn1)
             (type iabar rest2))
            (with-brgn (degr1 gnrt1) brgn1
              (let ((d-gnrt1 (cmbn-list (gnrt-? dffr (1- degr1) gnrt1)))
                    (d-rest2 (rslt (- degr degr1) rest2))
                    (degr1-1 (1- degr1))
                    (rest-sign (-1-expt-n degr1)))
                (declare
                 (type icmbn d-gnrt1 d-rest2)
                 (type fixnum degr1-1 rest-sign))
                (nconc
                 (mapcar
                     #'(lambda (term)
                         (declare (type term term))
                         (with-term (cffc gnrt) term
                           ;;; MAC-LANE sign problem
                           ;;; (term (- cffc)
                           (term cffc
                                 (cons (brgn degr1-1 gnrt) rest2))))
                   d-gnrt1)
                 (mapcar
                     #'(lambda (term)
                         (with-term (cffc gnrt) term
                           (term (* rest-sign cffc)
                                 (cons brgn1 gnrt))))
                   d-rest2))))))))
    (the intr-mrph
      #'(lambda (degr abar)
          (declare
           (type fixnum degr)
           (type abar abar))
          (make-cmbn
           :degr (1- degr)
           :list (mapcar
                     #'(lambda (term)
                         (with-term (cffc iabar) term
                           (term cffc (make-abar :list iabar))))
                   (rslt degr (abar-list abar))))))))

#|
  (setf d (soft-delta-infinity))
  (setf r (bar-intr-vrtc-dffr (dffr d)))
  (funcall r 0 (abar))
  (funcall r 3 (abar 3 (d 7)))
  (funcall r 5 (abar 3 (d 7) 2 (d 3)))
  (funcall r 5 (abar 2 (d 3) 3 (d 7))))
|#

(DEFGENERIC VRTC-BAR (chcm-or-mrph-or-rdct-or-eqvl))

(DEFMETHOD VRTC-BAR ((chcm chain-complex))
   (the chain-complex
      (with-slots (cmpr basis dffr) chcm
         (declare
            (type cmprf cmpr)
            (type basis basis)
            (type morphism dffr))
         (build-chcm
            :cmpr (bar-cmpr cmpr)
            :basis (bar-basis basis)
            :bsgn +null-abar+
            :intr-dffr (bar-intr-vrtc-dffr dffr)
            :strt :gnrt
            :orgn `(vrtc-bar ,chcm)))))

#|
  (cat-init)
  (setf v (vrtc-bar (soft-delta-infinity)))
  (defun random-abar (length)
     (let ((rslt nil))
        (dotimes (i length)
           (let* ((gmsm (random (mask 7)))
                  (dmns (1- (logcount gmsm))))
              (when (plusp dmns)
                 (push (brgn (1+ dmns) (d gmsm)) rslt))))
        (make-abar :list rslt)))
  (dotimes (i 10) (print (random-abar 5)))
  (dotimes (i 10)
     (let ((abar (random-abar 3)))
        (print abar)
        (print (? v (apply #'+ (mapcar #'car (abar-list abar))) abar))
        (print (? v (? v (apply #'+ (mapcar #'car (abar-list abar))) abar)))))
|#

;;; ((LABELS RSLT :IN BAR-INTR-HRZN-DFFR) 4 ((2 . S1) (2 . S1)))

(DEFUN BAR-INTR-HRZN-DFFR (aprd)
  (declare (type morphism aprd))
  (labels
      ((rslt
        (degr iabar)
        (declare
         (type fixnum degr)
         (type iabar iabar))
        (the icmbn
          (progn
            (unless (cdr iabar)
              (return-from rslt +empty-list+))
            (let ((brgn1 (first iabar))
                  (brgn2 (second iabar))
                  (rest1 (rest iabar))
                  (rest2 (cddr iabar)))
              (declare
               (type brgn brgn1 brgn2)
               (type iabar rest1 rest2))
              (with-brgn (degr1 gnrt1) brgn1
              (with-brgn (degr2 gnrt2) brgn2
                (let ((sign (-1-expt-n degr1))
                      (aprd-brgn1-brgn2 (gnrt-? aprd (+ degr1 degr2 -2)
                                                (tnpr (1- degr1) gnrt1
                                                      (1- degr2) gnrt2)))
                      (aprd-rest1 (rslt (- degr degr1) rest1)))				  
                  (declare
                   (type icmbn aprd-rest1)
                   (type cmbn  aprd-brgn1-brgn2))
                  (with-cmbn (degr12 icmbn12) aprd-brgn1-brgn2
                    (incf degr12)
                    (nconc
                     (mapcar
                         #'(lambda (term2)
                             (declare (type term term2))
                             (with-term (cffc2 iabar2) term2
                               (term (* sign cffc2) (cons brgn1 iabar2))))
                       aprd-rest1)
                     (mapcar
                         #'(lambda (term1)
                             (declare (type term term1))
                             (with-term (cffc1 gnrt12) term1
                               (term (* sign cffc1) (cons (brgn degr12 gnrt12) rest2))))
                       icmbn12)))))))))))
    (the intr-mrph
      #'(lambda (degr abar)
          (declare
           (type fixnum degr)
           (type abar abar))
          (the cmbn
            (make-cmbn :degr (1- degr)
                       :list (mapcar #'(lambda (term)
                                         (declare (type term term))
                                         (with-term (cffc iabar) term
                                           (term cffc (make-abar :list iabar))))
                               (rslt degr (abar-list abar)))))))))

#|
(setf k (k-z-1))
(setf r (bar-intr-hrzn-dffr (aprd k)))
(funcall r 0 (abar ))
(funcall r 3 (abar 3 '(2 3)))
(funcall r 6 (abar 3 '(2 3) 3 '(-2 -3)))
(funcall r 9 (abar 3 '(2 3) 3 '(-2 -3) 3 '(2 3)))
(funcall r 11 (abar 3 '(2 3) 3 '(-2 -3) 2 '(-2) 3 '(-2 -3)))
|#

(DEFUN BAR-HRZN-DFFR (algb)
   (declare (type algebra algb))
   (the morphism
      (with-slots (aprd) algb
         (declare (type morphism aprd))
         (build-mrph
            :sorc (vrtc-bar algb) :trgt (vrtc-bar algb) :degr -1
            :intr (bar-intr-hrzn-dffr aprd) :strt :gnrt
            :orgn `(bar-hrzn-dffr ,algb)))))

#|
(cat-init)
(setf h (bar-hrzn-dffr (k-z-1)))
(defun random-abar (tot-degr~ max-degr)
  (do ((rslt nil)
       (cum-degr 0 (+ cum-degr degr 1))
       (degr))
      ((>= cum-degr tot-degr~) (make-abar :list rslt))
    (setf degr (1+ (random max-degr)))
    (push (brgn (1+ degr)
                (let ((list (make-list degr)))
                  (mapl
                      #'(lambda (sublist)
                          (setf (car sublist) (- (random 21) 10)))
                    list)
                  list))
          rslt)))
(dotimes (i 10) (print (random-abar 10 5)))
(setf abar (random-abar 10 5))
(? h (apply #'+ (mapcar #'car (abar-list abar))) abar)
(? h (? h (apply #'+ (mapcar #'car (abar-list abar))) abar))
(dotimes (i 10)
  (let ((abar (random-abar 10 3)))
    (print abar)
    (print (? h (apply #'+ (mapcar #'car (abar-list abar))) abar))
    (print (? h (? h (apply #'+ (mapcar #'car (abar-list abar))) abar)))))
|#

(DEFUN BAR-INTR-DFFR (vrtc-dffr hrzn-dffr)
   (declare (type morphism vrtc-dffr hrzn-dffr))
   (flet ((rslt (degr abar)
             (declare
                (type fixnum degr)
                (type abar abar))
             (make-cmbn :degr (1- degr)
                :list (append       ;;; and not nconc, otherwise a terrible bug, when the
                                    ;;;   first result is stored in memory...
                         (cmbn-list (gnrt-? hrzn-dffr degr abar))
                         (cmbn-list (gnrt-? vrtc-dffr degr abar))))))
      (the intr-mrph #'rslt)))

(DEFGENERIC BAR (algb-or-ab-algb-or-mrph-or-rdct-or-eqvl))

(DEFMETHOD BAR ((algebra algebra))
  (let ((vrtc-bar (vrtc-bar algebra))
        (bar-hrzn-dffr (bar-hrzn-dffr algebra)))
    (declare (type chain-complex vrtc-bar)
             (type morphism bar-hrzn-dffr))
    (the chain-complex
      (let ((rslt (build-chcm
                   :cmpr (cmpr vrtc-bar)
                   :basis (basis vrtc-bar)
                   :bsgn +null-abar+
                   :intr-dffr (bar-intr-dffr (dffr vrtc-bar) bar-hrzn-dffr)
                   :strt :gnrt
                   :orgn `(add ,vrtc-bar ,bar-hrzn-dffr))))
        (declare (type chain-complex rslt))
        (setf (slot-value rslt 'grmd) (grmd vrtc-bar))
        rslt))))

#|
(cat-init)
(setf b (bar (k-z-1)))   
(defun random-abar (tot-degr~ max-degr)
  (do ((rslt nil)
       (cum-degr 0 (+ cum-degr degr 1))
       (degr))
      ((>= cum-degr tot-degr~) (make-abar :list rslt))
    (setf degr (1+ (random max-degr)))
    (push (brgn (1+ degr)
                (let ((list (make-list degr)))
                  (mapl
                      #'(lambda (sublist)
                          (setf (car sublist) (- (random 21) 10)))
                    list)
                  list))
          rslt)))
(setf abar (random-abar 10 3))
(? b (apply #'+ (mapcar #'car (abar-list abar))) abar)
(? b (? b (apply #'+ (mapcar #'car (abar-list abar))) abar))
(dotimes (i 10)
  (let ((abar (random-abar 10 3)))
    (print abar)
    (print (? b (apply #'+ (mapcar #'car (abar-list abar))) abar))
    (print (? b (? b (apply #'+ (mapcar #'car (abar-list abar))) abar)))))
|#

(DEFUN CMBN-ABAR-CMBN-TNPR (cmbn abar-cmbn)
   (declare (type cmbn cmbn abar-cmbn))
   (the cmbn
      (with-cmbn (degr1 list1) cmbn
         (incf degr1)     ;; because abar organization
      (with-cmbn (degrr listr) abar-cmbn
         (make-cmbn
            :degr (+ degr1 degrr)
            :list
            (mapcan
               #'(lambda (term1)
                    (declare (type term term1))
                    (with-term (cffc1 gnrt1) term1
                       (let ((brgn1 (brgn degr1 gnrt1)))
                          (declare (type brgn brgn1))
                          (mapcar
                             #'(lambda (termr)
                                  (declare (type term termr))
                                  (with-term (cffcr abarr) termr
                                     (term (* cffc1 cffcr)
                                        (make-abar
                                           :list (cons brgn1 (abar-list abarr))))))
                             listr))))
               list1))))))

(DEFUN NCMBN-BAR (cmbn-list)
   (declare (list cmbn-list))
   (the cmbn
      (progn
         (unless cmbn-list
            (return-from ncmbn-bar (cmbn 0 1 +null-abar+)))
         (cmbn-abar-cmbn-tnpr
            (first cmbn-list)
            (ncmbn-bar (rest cmbn-list))))))
#|
  (ncmbn-bar nil)
  (ncmbn-bar (list (cmbn 3 2 'a 3 'b)))
  (ncmbn-bar (list (cmbn 1 2 'a 3 'b) (cmbn 2 4 'c 5 'd)))
  (ncmbn-bar (list (cmbn 1 2 'a 3 'b) (cmbn 1 4 'c 5 'd) (cmbn 1 6 'e 7 'f))))
|#

(DEFUN MRPH-VRTC-BAR-INTR (mrph)
   (declare (type morphism mrph))
   (flet ((rslt (degr abar)
             (declare
                (ignore degr)
                (type abar abar))
             (the cmbn
                (ncmbn-bar
                   (mapcar #'(lambda (brgn)
                                (declare (type brgn brgn))
                                (with-brgn (degr gnrt) brgn
                                   (gnrt-? mrph (1- degr) gnrt)))
                      (abar-list abar))))))
      (the intr-mrph #'rslt)))

#|
  (setf cc (build-chcm :cmpr #'f-cmpr :strt :cmbn))
  (setf m (build-mrph :sorc cc :trgt cc :degr 0 :intr
            #'(lambda (degr gnrt) (cmbn degr 2 gnrt 3 (1+ gnrt)))
            :strt :gnrt :orgn '(test)))
  (setf r (mrph-vrtc-bar-intr m))
  (funcall r 4 (abar 2 3 2 4))
|#

(DEFMETHOD VRTC-BAR ((mrph morphism))
   (the morphism
      (if (eq (first (orgn mrph)) 'idnt-mrph)
         (idnt-mrph (vrtc-bar (sorc mrph)))
         (build-mrph
            :sorc (vrtc-bar (sorc mrph))
            :trgt (vrtc-bar (trgt mrph))
            :degr 0
            :intr (mrph-vrtc-bar-intr mrph)
            :strt :gnrt
            :orgn `(vrtc-bar ,mrph)))))

#|
  (cat-init)
  (setf f (aw (soft-delta-infinity) (soft-delta-infinity)))
  (setf cf (vrtc-bar f))
  (? cf 6 (abar 3 (crpr 0 (d 7) 0 (d 7)) 3 (crpr 0 (d 56) 0 (d 56))))
|#

(DEFUN HMTP-VRTC-BAR-INTR (h gf)
  (declare (type morphism h gf))
  (labels
      ((rslt
        (degr iabar)
        (declare (type fixnum degr) (type iabar iabar))
        (unless iabar
          (return-from rslt +empty-list+))
        (let ((brgn1 (first iabar))
              (rest2 (rest iabar)))
          (declare (type brgn brgn1) (list rest2))
          (with-brgn (degr1 gnrt1) brgn1
            (let ((h-gnrt1 (cmbn-list (gnrt-? h (1- degr1) gnrt1)))
                  (h-rest2 (rslt (- degr degr1) rest2))
                  (degr1+1 (1+ degr1))
                  (rest-sign (-1-expt-n degr1))
                  (gf-gnrt1 (cmbn-list (gnrt-? gf (1- degr1) gnrt1))))
              (declare
               (type fixnum degr1+1 rest-sign)
               (type icmbn h-gnrt1 h-rest2 gf-gnrt1))
              (nconc
               (mapcan
                   #'(lambda (term1)
                       (declare (type term term1))
                       (with-term (cffc1 gnrt11) term1
                         (mapcar
                             #'(lambda (term2)
                                 (declare (type term term2))
                                 (with-term (cffc2 iabar2) term2
                                   (term (* rest-sign cffc1 cffc2)
                                         (cons (brgn degr1 gnrt11) iabar2))))
                           h-rest2)))
                 gf-gnrt1)
               (mapcar
                   #'(lambda (term1)
                       (declare (type term term1))
                       (with-term (cffc1 gnrt11) term1
                         (term cffc1
                               (cons (brgn degr1+1 gnrt11) rest2))))
                 h-gnrt1)))))))
    (the intr-mrph
      #'(lambda (degr abar)
          (declare
           (type fixnum degr)
           (type abar abar))
          (make-cmbn
           :degr (1+ degr)
           :list (mapcar
                     #'(lambda (term)
                         (declare (type term term))
                         (with-term (cffc iabar) term
                           (declare
                            (type fixnum cffc)
                            (type iabar iabar))
                           (term cffc (make-abar :list iabar))))
                   (rslt degr (abar-list abar))))))))

#|
  (cat-init)
  (setf ez (ez (delta-infinity) (delta-infinity)))
  (setf h (h ez) gf (cmps (g ez) (f ez)))
  (setf r (hmtp-vrtc-bar-intr h gf))
  (funcall r 3 (abar 3 (crpr 0 7 0 7)))
  (funcall r 9 (abar 3 (crpr 0 7 0 7) 3 (crpr 0 14 0 14) 3 (crpr 0 14 0 14)))
|#

(DEFUN HMTP-VRTC-BAR (h gf)
   (declare (type morphism h gf))
   (unless (and (= +1 (degr h))
                (= +0 (degr gf)))
      (error "In HMTP-VRTC-BAR, the morphism degrees are not the right ones."))
   (unless (and (eq (sorc h) (trgt h))
                (eq (trgt h) (sorc gf))
                (eq (sorc gf) (trgt gf)))
      (error "In HMTP-VRTC-BAR, fg-h sources and targets are not the same."))
   (the morphism
      (if (eq (first (orgn h)) 'zero-mrph)
         (zero-mrph (vrtc-bar (sorc h)))
         (build-mrph
            :sorc (vrtc-bar (sorc h)) :trgt (vrtc-bar (sorc h)) :degr +1
            :intr (hmtp-vrtc-bar-intr h gf)
            :strt :gnrt
            :orgn `(hmtp-vrtc-bar ,h ,gf)))))

(DEFMETHOD VRTC-BAR ((rdct reduction))
   (the reduction
      (if (eq (first (orgn rdct)) 'trivial-rdct)
         (trivial-rdct (vrtc-bar (bcc rdct)))
         (with-slots (f g h) rdct
            (build-rdct
               :f (vrtc-bar f)
               :g (vrtc-bar g)
               :h (hmtp-vrtc-bar h (cmps g f))
               :orgn `(vrtc-bar ,rdct))))))

#|
  (cat-init)
  (setf tcc (build-chcm
               :cmpr #'s-cmpr
               :basis #'(lambda (degr) '(a b c d))
               :bsgn 'd
               :intr-dffr #'(lambda (degr gnrt)
                               (ecase gnrt
                                  (a (cmbn (1- degr) 1 'b 1 'd))
                                  ((b d) (cmbn (1- degr)))
                                  (c (cmbn (1- degr) 1 'd))))
               :strt :gnrt
               :orgn '(tcc)))
  (setf bcc (build-chcm
               :cmpr #'s-cmpr
               :basis #'(lambda (degr) '(c d))
               :bsgn 'd
               :intr-dffr #'(lambda (degr gnrt)
                               (ecase gnrt
                                  (d (cmbn (1- degr)))
                                  (c (cmbn (1- degr) 1 'd))))
               :strt :gnrt
               :orgn '(bcc)))
  (setf f (build-mrph :sorc tcc :trgt bcc :degr 0
             :intr #'(lambda (degr gnrt)
                        (ecase gnrt
                           (a (cmbn degr 1 'c 1 'd))
                           (b (cmbn degr))
                           ((c d) (cmbn degr 1 gnrt))))
             :strt :gnrt :orgn '(f)))
  (setf g (build-mrph :sorc bcc :trgt tcc :degr 0
             :intr #'identity :strt :cmbn :orgn '(g)))
  (setf h (build-mrph :sorc tcc :trgt tcc :degr +1
             :intr #'(lambda (degr gnrt)
                        (ecase gnrt
                           ((a b) (cmbn (1+ degr) 1 'a -1 'b -1 'c -1 'd))
                           ((c d) (cmbn (1+ degr)))))
             :strt :gnrt :orgn '(h)))
  (setf rdct (build-rdct :f f :g g :h h :orgn '(rdct)))
  (tcc rdct 3 'a)
  (g rdct (f rdct 3 'a))
  (h rdct 3 'a)
  (setf bar (vrtc-bar rdct))
  (pre-check-rdct bar)
  (defun aleat-tc ()
     (do ((tdegr 0 (+ tdegr degr))
          (degr (+ 2 (random 3)) (+ 2 (random 3)))
          (gnrt (intern (coerce (vector (code-char (+ 65 (random 4)))) 'string))
                (intern (coerce (vector (code-char (+ 65 (random 4)))) 'string)))
          (rslt nil (cons (brgn degr gnrt) rslt)))
         ((> tdegr 10) (setf *tc* (cmbn tdegr 1 (make-abar :list rslt))))))
  (aleat-tc)
  (defun aleat-bc ()
     (do ((tdegr 0 (+ tdegr degr))
          (degr (+ 2 (random 3)) (+ 2 (random 3)))
          (gnrt (intern (coerce (vector (code-char (+ 67 (random 2)))) 'string))
                (intern (coerce (vector (code-char (+ 67 (random 2)))) 'string)))
          (rslt nil (cons (brgn degr gnrt) rslt)))
         ((> tdegr 10) (setf *bc* (cmbn tdegr 1 (make-abar :list rslt))))))
  (aleat-bc)
  (defun c ()
     (aleat-tc)
     (aleat-bc)
     (check-rdct))
  (loop (c))  ;; degrees >= 15 is possible => error.
|#

(DEFMETHOD VRTC-BAR ((hmeq equivalence))
   (the equivalence
      (if (eq (first (orgn hmeq)) 'trivial-hmeq)
         (trivial-hmeq (vrtc-bar (lbcc hmeq)))
         (with-slots (lrdct rrdct) hmeq
            (build-hmeq 
               :lrdct (vrtc-bar lrdct)
               :rrdct (vrtc-bar rrdct)
               :orgn `(vrtc-bar ,hmeq))))))

(DEFMETHOD BAR ((hmeq equivalence))
   (unless (typep (lbcc hmeq) 'algebra)
      (error "In (BAR HMEQ), the LBCC should be a algebra."))
   (the equivalence
      (if (eq (first (orgn hmeq)) 'trivial-hmeq)
         (trivial-hmeq (bar (lbcc hmeq)))
         (add (vrtc-bar hmeq) (bar-hrzn-dffr (lbcc hmeq))))))

#|
  (cat-init)
  (setf h (efhm (k-z-1)))
  (setf b (bar h))
  (inspect b)
  (homology (rbcc b) 0 11)
|#

(DEFUN ELEM-EXT-ALGEBRA-CMPR (gnrt1 gnrt2)
  (declare (ignore gnrt1 gnrt2))
  (the cmpr :equal))

(DEFUN ELEM-EXT-ALGEBRA-GNRT (degr)
  (intern (format nil "E~D" degr) :keyword))

(DEFUN ELEM-EXT-ALGEBRA-BASIS (degr &aux
                                    (gnrt (elem-ext-algebra-gnrt degr)))
  (declare (type fixnum degr) (type gnrt gnrt))
  (the function
    #'(lambda (degr2)
        (declare (type fixnum degr2))
        (the list
          (cond ((zerop degr2) '(:z-gnrt))
                ((= degr2 degr) (list gnrt)) 
                (t +empty-list+))))))

(DEFUN ELEM-EXT-ALGEBRA-INTR-DFFR (cmbn)
  (declare (type cmbn cmbn))
  (the cmbn (zero-cmbn (1- (cmbn-degr cmbn)))))
  
(DEFUN ELEM-EXT-ALGEBRA-INTR-APRD (degr &aux
                                        (gnrt (elem-ext-algebra-gnrt degr)))
  (declare (type fixnum degr) (type gnrt gnrt))
  (the function
    #'(lambda (degr tnpr)
        (declare (type fixnum degr) (type tnpr tnpr))
        (the cmbn
          (with-tnpr (degr1 nil degr2 nil) tnpr
            (if (zerop degr1)
                (if (zerop degr2)
                    (cmbn 0 1 :z-gnrt)
                  (cmbn degr 1 gnrt))
              (if (zerop degr2)
                  (cmbn 0 1 gnrt)
                (zero-cmbn (+ degr degr)))))))))


(DEFUN ELEM-EXT-ALGEBRA (degr)
  (declare (type fixnum degr))
  (assert (and (plusp degr) (oddp degr)))
  (the algebra
    (change-class
     (build-algb
      :cmpr #'elem-ext-algebra-cmpr
      :basis (elem-ext-algebra-basis degr)
      :bsgn :z-gnrt
      :intr-dffr #'elem-ext-algebra-intr-dffr
      :dffr-strt :cmbn
      :intr-aprd (elem-ext-algebra-intr-aprd degr)
      :aprd-strt :gnrt
      :orgn `(elem-ext-algebra ,degr))
     'ab-algebra)))

(DEFUN IABAR-CMPR (cmpr)
  (declare (type cmprf cmpr))
  (the function
    (flet
        ((rslt
          (iabar1 iabar2)
          (declare (type iabar iabar1 iabar2))
          (the cmpr
            (lexico
             (f-cmpr (length iabar1) (length iabar2))
             (maplexico
              #'(lambda (brgn1 brgn2)
                  (lexico
                   (f-cmpr (bdegr brgn1) (bdegr brgn2))
                   (funcall cmpr (bgnrt brgn1) (bgnrt brgn2))))
              iabar1 iabar2)))))
      #'rslt)))

#|
(setf r (iabar-cmpr #'s-cmpr))
(funcall r nil nil)
(funcall r (list (cons 3 'a)) nil)
(funcall r (list (cons 3 'a)) (list (cons 2 'a) (cons 1 'b)))
(funcall r (list (cons 3 'a)) (list (cons 3 'b)))
(funcall r (list (cons 3 'a)) (list (cons 3 'a)))
|#


(DEFUN BAR-APRD-IMPL (algb-cmpr &aux (iabar-cmpr (iabar-cmpr algb-cmpr)))
  (declare (type cmprf algb-cmpr iabar-cmpr))
  (the function
    (labels
        ((rslt1
          (degr1 iabar1 degr2 iabar2)
          (declare (type fixnum degr1 degr2) (type iabar iabar1 iabar2))
          (the cmbn
            (progn
              (unless (plusp degr1)
                (return-from rslt1 (cmbn degr2 1 iabar2)))
              (unless (plusp degr2)
                (return-from rslt1 (cmbn degr2 1 iabar1)))
              ;; Notations EML-I (7.7)
              (let ((a (first iabar1))
                    (u (rest iabar1))
                    (sign (-1-expt-n (* (caar iabar2) degr1)))
                    (b (first iabar2))
                    (v (rest iabar2)))
                (declare (type gnrt a b)
                         (type iabar u v)
                         (type fixnum sign))
                (let ((ubv (rslt1 (- degr1 (caar iabar1)) u degr2 iabar2))
                      (auv (rslt1 degr1 iabar1 (- degr2 (caar iabar2)) v)))
                  (declare (type cmbn ubv auv))
                  (setf ubv
                    (make-cmbn
                     :degr (+ degr1 degr2)
                     :list (mapcar
                               #'(lambda (term)
                                   (declare (type term term))
                                   (the term
                                     (with-term (cffc iabar) term
                                       (term cffc (cons a iabar)))))
                             (cmbn-list ubv))))
                  (setf auv
                    (make-cmbn
                     :degr (+ degr1 degr2)
                     :list (mapcar
                               #'(lambda (term)
                                   (declare (type term term))
                                   (the term
                                     (with-term (cffc iabar) term
                                       (term cffc (cons b iabar)))))
                             (cmbn-list auv))))
                  (when (minusp sign)
                    (setf auv (cmbn-opps auv)))
                  (2cmbn-add iabar-cmpr ubv auv)))))))
      (declare (ftype (function (type fixnum iabar fixnum iabar) cmbn) rslt1))
      (flet
          ((rslt2
            (degr tnpr)
            (declare (type fixnum degr) (type tnpr tnpr))
            (the cmbn
              (with-tnpr (degr1 abar1 degr2 abar2) tnpr
                (let ((rslt3 (rslt1 degr1 (abar-list abar1) degr2 (abar-list abar2))))
                  (declare (type cmbn rslt3))
                  (make-cmbn
                   :degr degr
                   :list (mapcar
                             #'(lambda (term)
                                 (declare (type term term))
                                 (the term
                                   (with-term (cffc iabar) term
                                     (term cffc (make-abar :list iabar)))))
                           (cmbn-list rslt3))))))))
        (declare (ftype (function (type fixnum tnpr) cmbn) rslt2))
        #'rslt2))))

#|
(setf aprd (bar-aprd-impl #'s-cmpr))
(funcall aprd 0 (tnpr 0 (abar) 0 (abar)))
(funcall aprd 1 (tnpr 1 (abar 1 'a) 0 (abar)))
(funcall aprd 1 (tnpr 0 (abar) 1 (abar 1 'a)))
(funcall aprd 2 (tnpr 1 (abar 1 'a) 1 (abar 1 'b)))
(funcall aprd 4 (tnpr 2 (abar 1 'a 1 'b) 2 (abar 1'c 1'd)))
(funcall aprd 5 (tnpr 3 (abar 1 'a 2 'b) 2 (abar 1'c 1'd)))
|#

(DEFMETHOD BAR((ab-algebra ab-algebra))
  (declare (type ab-algebra ab-algebra))
  (the ab-algebra
    (let ((rslt (change-class (call-next-method) 'ab-algebra)))
      (declare (type ab-algebra rslt))
      (setf (slot-value rslt 'aprd)
        (build-mrph
         :sorc (tnsr-prdc rslt rslt)
         :trgt rslt
         :degr 0
         :intr (bar-aprd-impl (cmpr ab-algebra))
         :strt :gnrt
         :orgn `(bar-aprd ,ab-algebra)))
      rslt)))
#|
(setf k (k-z-1))
(setf k2 (bar k))
|#

(DEFMETHOD BAR ((mrph morphism) &aux (orgn `(bar ,mrph)))
  (declare (type list orgn))
  (the morphism
    (progn
      (let ((already (find orgn *mrph-list* :key #'orgn :test #'equal)))
        (declare (type (or null algebra) already))
        (when already
          (return-from bar already)))
      (let ((sorc (sorc mrph))
            (trgt (trgt mrph)))
        (declare (type ab-algebra sorc trgt))
        (assert (typep sorc 'ab-algebra))
        (assert (typep trgt 'ab-algebra))
        (let ((rslt (vrtc-bar mrph)))
          (declare (type morphism rslt))
          (setf (slot-value rslt 'sorc) (bar sorc))
          (setf (slot-value rslt 'trgt) (bar trgt))
          (setf (slot-value rslt 'orgn) orgn)
          rslt)))))
       
#|
(cat-init)
(setf k (k-z-1))
(setf r (rrdct (efhm k)))
(setf f (f r))
(setf (slot-value f 'trgt) (elem-ext-algebra 1))
(setf bf (bar f))
(setf bf (bar f))
|#

(DEFMETHOD BAR ((rdct reduction) &aux (orgn `(bar ,rdct)))
  (declare (type list orgn))
  (the reduction
    (progn
      (let ((already (find orgn *rdct-list* :key #'orgn :test #'equal)))
        (declare (type (or null reduction) already))
        (when already (return-from bar already)))
      (with-slots (tcc bcc f g h) rdct
        (declare (type ab-algebra tcc bcc) (type morphism f g h))
        (assert (typep tcc 'ab-algebra))
        (assert (typep bcc 'ab-algebra))
        (let ((bartcc (bar tcc))
              (barbcc (bar bcc))
              (barf (bar f))
              (barg (bar g))
              (vrtc-barh (hmtp-vrtc-bar h (cmps g f)))
              (perturbation (bar-hrzn-dffr tcc)))
          (declare
           (type ab-algebra bartcc barbcc)
           (type morphism barf barg vrtc-barh perturbation)
           (ignore barbcc))
          (let* ((sigma (bpl-*-sigma vrtc-barh perturbation))
                 (barh (cmps sigma vrtc-barh)))
            (declare (type morphism sigma barh))
            (setf (slot-value barh 'sorc) bartcc)
            (setf (slot-value barh 'trgt) bartcc)
            (build-rdct :f barf :g barg :h barh
                        :orgn `(bar ,rdct))))))))
        
#|
(cat-init)
(setf k (k-z-1))
(setf r (rrdct (efhm k)))
(setf br (bar r))
(setf br (bar r))
(setf *tc* (cmbn 7 1 (abar 3 '(4 6) 4 '(1 2 3))))
(setf *bc* (cmbn 4 1 (abar 2 's1 2 's1)))
(pre-check-rdct br)
(check-rdct)
|#

           