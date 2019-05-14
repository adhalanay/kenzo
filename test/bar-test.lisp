;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test)

(in-suite :kenzo)

(test abar
      (cat:abar )
      (cat:abar '(2 a 3 b))
      (cat:abar 2 'a 3 'b)
      (signals simple-error (cat:abar 2 'a 3)))

(test bar-cmpr
      (let ((r (cat:bar-cmpr #'cat:s-cmpr)))
        (is (equal :equal (funcall r (cat:abar) (cat:abar))))
        (is (equal :greater (funcall r (cat:abar 3 'a) (cat:abar))))
        (is (equal :less (funcall r (cat:abar 3 'a) (cat:abar 2 'a 1 'b))))
        (is (equal :less (funcall r (cat:abar 3 'a) (cat:abar 3 'b))))
        (is (equal :equal (funcall r (cat:abar 3 'a) (cat:abar 3 'a))))))

(test bar-basis-length
      (let ((basis #'(lambda (degr) (list degr))))
        (cat:bar-basis-length basis 2 1)
        (cat:bar-basis-length basis 2 2)
        (cat:bar-basis-length basis 3 1)
        (cat:bar-basis-length basis 3 2)
        (cat:bar-basis-length basis 4 1)
        (cat:bar-basis-length basis 4 2)
        (cat:bar-basis-length basis 4 3)
        (cat:bar-basis-length basis 4 4)
        (cat:bar-basis-length basis 8 1)
        (cat:bar-basis-length basis 8 2)
        (cat:bar-basis-length basis 8 3)
        (cat:bar-basis-length basis 8 4)
        (cat:bar-basis-length basis 8 5)
        (cat:bar-basis-length basis 8 6)
        (cat:bar-basis-length basis 8 11)))


(test bar-basis
      (let* ((basis #'(lambda (degr) (list degr)))
             (r (cat:bar-basis basis)))
        (funcall r 0)
        (funcall r 1)
        (funcall r 2)
        (dotimes (i 7)
          (print (funcall r i)))
        (cat:bar-basis :locally-effective)))


(test bar-intr-vrtc-dffr
      (let* ((d (cat:soft-delta-infinity))
             (r (cat:bar-intr-vrtc-dffr (cat:dffr d))))
        (funcall r 0 (cat:abar))
        (funcall r 3 (cat:abar 3 (cat:d 7)))
        (funcall r 5 (cat:abar 3 (cat:d 7) 2 (cat:d 3)))
        (funcall r 5 (cat:abar 2 (cat:d 3) 3 (cat:d 7)))))


(defun random-abar1 (length)
  (let ((rslt nil))
    (dotimes (i length)
      (let* ((gmsm (random (cat:mask 6)))
             (dmns (1- (logcount gmsm))))
        (when (plusp dmns)
          (push (cat:brgn (1+ dmns) gmsm) rslt))))
    (cat:make-abar :list rslt)))


(test vrtc-bar
      (progn
        (cat:cat-init)
        (let ((v (cat:vrtc-bar (cat:delta-infinity))))
          (dotimes (i 10)
            (print (random-abar1 5)))
          (dotimes (i 10)
            (let ((abar (random-abar1 3)))
              (print abar)
              (print (cat:? v (apply #'+ (mapcar #'car (cat:abar-list abar)))
                            abar))
              (print (cat:? v (cat:? v (apply #'+ (mapcar #'car
                                                          (cat:abar-list abar)))
                                     abar))))))))


(test bar-intr-hrzn-dffr
      (let* ((k (cat:k-z-1))
             (r (cat:bar-intr-hrzn-dffr (cat:aprd k))))
        (funcall r 0 (cat:abar ))
        (funcall r 3 (cat:abar 3 '(2 3)))
        (funcall r 6 (cat:abar 3 '(2 3) 3 '(-2 -3)))
        (funcall r 9 (cat:abar 3 '(2 3) 3 '(-2 -3) 3 '(2 3)))
        (funcall r 11 (cat:abar 3 '(2 3) 3 '(-2 -3) 2 '(-2) 3 '(-2 -3)))))


(test bar-hrzn-dffr
      (progn
        (cat:cat-init)
        (let ((h (cat:bar-hrzn-dffr (cat:k-z-1)))
              (abar))
          (dotimes (i 10)
            (print (random-abar 10 5)))
          (setf abar (random-abar 10 5))
          (cat:? h (apply #'+ (mapcar #'car (cat:abar-list abar))) abar)
          (cat:? h (cat:? h (apply #'+ (mapcar #'car
                                               (cat:abar-list abar))) abar))
          (dotimes (i 10)
            (setf abar (random-abar 10 3))
            (print abar)
            (print (cat:? h (apply #'+ (mapcar #'car (cat:abar-list abar)))
                          abar))
            (print (cat:? h (cat:? h (apply #'+ (mapcar #'car
                                                        (cat:abar-list abar)))
                                   abar)))))))


(test bar
      (progn
        (cat:cat-init)
        (let ((b (cat:bar (cat:k-z-1)))
              (abar (random-abar 10 3)))
          (cat:? b (apply #'+ (mapcar #'car (cat:abar-list abar))) abar)
          (cat:? b (cat:? b (apply #'+ (mapcar #'car (cat:abar-list abar)))
                          abar))
          (dotimes (i 10)
            (let ((abar (random-abar 10 3)))
              (print abar)
              (print (cat:? b (apply #'+ (mapcar #'car (cat:abar-list abar)))
                            abar))
              (print (cat:? b
                            (cat:? b
                                   (apply #'+ (mapcar #'car
                                                      (cat:abar-list abar)))
                                   abar))))))))


(test ncmbn-bar
      (cat:ncmbn-bar nil)
      (cat:ncmbn-bar (list (cat:cmbn 3 2 'a 3 'b)))
      (cat:ncmbn-bar (list (cat:cmbn 1 2 'a 3 'b) (cat:cmbn 2 4 'c 5 'd)))
      (cat:ncmbn-bar (list (cat:cmbn 1 2 'a 3 'b) (cat:cmbn 1 4 'c 5 'd)
                           (cat:cmbn 1 6 'e 7 'f))))


(test mrph-vrtc-bar-intr
      (let* ((cc (cat:build-chcm :cmpr #'cat:f-cmpr
                                 :basis :locally-effective
                                 :intr-dffr #'cat:zero-mrph
                                 :strt :cmbn))
             (m (cat:build-mrph :sorc cc :trgt cc :degr 0 :intr
                                #'(lambda (degr gnrt)
                                    (cat:cmbn degr 2 gnrt 3 (1+ gnrt)))
                                :strt :gnrt :orgn '(test)))
             (r (cat:mrph-vrtc-bar-intr m)))
        (funcall r 4 (cat:abar 2 3 2 4))))


(if (string= (package-name (find-package 'cat)) "CAT-7")
  (test vrtc-bar
        (progn
          (cat:cat-init)
          (let* ((f (cat:aw (cat:soft-delta-infinity)
                            (cat:soft-delta-infinity)))
                 (cf (cat:vrtc-bar f)))
            (cat:? cf 6 (cat:abar 3 (cat:crpr 0 (cat:d 7) 0 (cat:d 7)) 3
                                  (cat:crpr 0 (cat:d 56) 0 (cat:d 56)))))))
  (test vrtc-bar
        (progn
          (cat:cat-init)
          (let* ((f (cat:aw (cat:soft-delta-infinity)
                            (cat:soft-delta-infinity)))
                 (cf (cat:vrtc-bar f)))
            (cat:? cf 6 (cat:abar 3 (cat:crpr 0 (cat::make-delta :cdr 7)
                                              0 (cat::make-delta :cdr 7))
                                  3
                                  (cat:crpr 0 (cat::make-delta :cdr 56)
                                            0 (cat::make-delta :cdr 56))))))))


(test hmtp-vrtc-bar-intr
      (progn
        (cat:cat-init)
        (let* ((ez (cat:ez (cat:delta-infinity) (cat:delta-infinity)))
               (h (cat:h ez))
               (gf (cat:cmps (cat:g ez) (cat:f ez)))
               (r (cat:hmtp-vrtc-bar-intr h gf)))
          (funcall r 3 (cat:abar 3 (cat:crpr 0 7 0 7)))
          (funcall r 9 (cat:abar 3 (cat:crpr 0 7 0 7) 3 (cat:crpr 0 14 0 14)
                                 3 (cat:crpr 0 14 0 14))))))


#|
(test vrtc-bar1
      (progn
        (cat:cat-init)

        (let* ((tcc (cat:build-chcm
                     :cmpr #'cat:s-cmpr
                     :basis #'(lambda (degr) '(a b c d))
                     :bsgn 'd
                     :intr-dffr #'(lambda (degr gnrt)
                                    (ecase gnrt
                                      (a (cat:cmbn (1- degr) 1 'b 1 'd))
                                      ((b d) (cat:cmbn (1- degr)))
                                      (c (cat:cmbn (1- degr) 1 'd))))
                     :strt :gnrt
                     :orgn '(tcc)))
               (bcc (cat:build-chcm
                     :cmpr #'cat:s-cmpr
                     :basis #'(lambda (degr) '(c d))
                     :bsgn 'd
                     :intr-dffr #'(lambda (degr gnrt)
                                    (ecase gnrt
                                      (d (cat:cmbn (1- degr)))
                                      (c (cat:cmbn (1- degr) 1 'd))))
                     :strt :gnrt
                     :orgn '(bcc)))
               (f (cat:build-mrph :sorc tcc :trgt bcc :degr 0
                                  :intr #'(lambda (degr gnrt)
                                            (ecase gnrt
                                              (a (cat:cmbn degr 1 'c 1 'd))
                                              (b (cat:cmbn degr))
                                              ((c d) (cat:cmbn degr 1 gnrt))))
                                  :strt :gnrt :orgn '(f)))
               (g (cat:build-mrph :sorc bcc :trgt tcc :degr 0
                                  :intr #'identity :strt :cmbn :orgn '(g)))
               (h (cat:build-mrph :sorc tcc :trgt tcc :degr +1
                                  :intr #'(lambda (degr gnrt)
                                            (ecase gnrt
                                              ((a b) (cat:cmbn
                                                      (1+ degr)
                                                      1 'a -1 'b -1 'c -1 'd))
                                              ((c d) (cat:cmbn (1+ degr)))))
                                  :strt :gnrt :orgn '(h)))
               (rdct (cat:build-rdct :f f :g g :h h :orgn '(rdct)))
               (bar))
          (cat:tcc rdct 3 'a)
          (cat:g rdct (cat:f rdct 3 'a))
          (cat:h rdct 3 'a)
          (setf bar (cat:vrtc-bar rdct))
          (cat:pre-check-rdct bar)
          (aleat-tc)
          (aleat-bc)
          ;;(loop (c))
          (dotimes (i 10) (c))))) ;; degrees >= 15 is possible => error.
|#

(test homology
      (progn
        (cat:cat-init)
        (let* ((h (cat:efhm (cat:k-z-1)))
               (b (cat:bar h)))
          (cat:homology (cat:rbcc b) 0 11))))
