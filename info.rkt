#lang info
(define collection "amap")
(define deps '("base" "request" "at-exp-lib"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/amap.scrbl" ())))
(define pkg-desc "Gaode Amap web service API")
(define version "0.1")
(define pkg-authors '(Yanying Wang))
