;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test-7)

(in-suite :kenzo-7)


(test smgr-fibration
      (cat-7:cat-init)
      (let* ((k1 (cat-7:k-z-1))
             (tw (cat-7:smgr-fibration k1))
             (k2 (cat-7:sorc tw))
             (tt (cat-7:fibration-total tw))
             (gmsm (cat-7:crpr 0 (cat-7:gbar 4 0 '(10 11 12) 0 '(20 21)
                                             0 '(30) 0 '())
                               0 '(2 4 6 8)))
             (br (cat-7:brown-reduction tw))
             (tw-pr (cat-7:bcc br)))
        (dotimes (i 5)
          (print (cat-7:face tt i 4 gmsm)))
        (cat-7:? tw-pr 4 (cat-7:tnpr 4 (cat-7:gbar 4 0 '(1 10 100) 0 '(1000 10000)
                                                   0 '(100000) 0 '())
                                     0 '()))))

(test smgr-crts-contraction
      (cat-7:cat-init)
      (let* ((chi (cat-7:smgr-crts-contraction (cat-7:k-z-1)))
             (rdct (cat-7:build-rdct :f (cat-7:zero-mrph (cat-7:sorc chi)
                                                         (cat-7:z-chcm))
                                     :g (cat-7:zero-mrph (cat-7:z-chcm)
                                                         (cat-7:sorc chi))
                                     :h chi)))
        (cat-7:pre-check-rdct rdct)
        (setf cat-7:*tc* (cat-7:cmbn 0 1 (cat-7:crpr 0 cat-7:+null-gbar+ 0 '())))
        (setf cat-7:*bc* (cat-7:cmbn 0 1 :z-gnrt))
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 1 1 (cat-7:crpr 1 cat-7:+null-gbar+ 0 '(1))))
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 4 1 (cat-7:crpr 0 (cat-7:gbar 4 0 '(10 11 12)
                                                                   0 '(20 21)
                                                                   0 '(30) 0 '())
                                                     0 '(2 4 6 8))))
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 3 1 (cat-7:crpr 0 (cat-7:gbar 3 0 '(10 11)
                                                                   0 '(20) 0 '())
                                                     0 '(2 4 6))))
        (check-rdct)))

(test smgr-tnpr-contraction
      (cat-7:cat-init)
      (let* ((chi (cat-7:smgr-tnpr-contraction (cat-7:k-z-1)))
             (rdct (cat-7:build-rdct :f (cat-7:zero-mrph (cat-7:sorc chi)
                                                         (cat-7:z-chcm))
                                     :g (cat-7:zero-mrph (cat-7:z-chcm)
                                                         (cat-7:sorc chi))
                                     :h chi)))
        (cat-7:pre-check-rdct rdct)
        (setf cat-7:*tc* (cat-7:cmbn 0 1 (cat-7:tnpr 0 cat-7:+null-gbar+ 0 '())))
        (setf cat-7:*bc* (cat-7:cmbn 0 1 :z-gnrt))
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 1 1 (cat-7:tnpr 0 cat-7:+null-gbar+ 1 '(1))))
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 3 1 (cat-7:tnpr 0 cat-7:+null-gbar+
                                                     3 '(1 10 100))))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 3 1 (cat-7:tnpr 2 (cat-7:gbar 2 0 '(1) 0 '())
                                                     1 '(10))))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 3 1 (cat-7:tnpr 3 (cat-7:gbar 3 0 '(1 10)
                                                                   0 '(100) 0 '())
                                                     0 '())))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 4 1 (cat-7:tnpr 0 cat-7:+null-gbar+
                                                     4 '(1 10 100 1000))))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 4 1 (cat-7:tnpr 2 (cat-7:gbar 2 0 '(1) 0 '())
                                                     2 '(10 100))))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 4 1 (cat-7:tnpr 3 (cat-7:gbar 3 0 '(1 10)
                                                                   0 '(100) 0 '())
                                                     1 '(1000))))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)
        (setf cat-7:*tc* (cat-7:cmbn 4 1 (cat-7:tnpr 4 (cat-7:gbar 4 0 '(1 10 100)
                                                                   0 '(1000 10000)
                                                                   0 '(100000)
                                                                   0 '())
                                                     0 '())))
        (cat-7:? chi cat-7:*tc*)
        (check-rdct)))
