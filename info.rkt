#lang info
(define collection "amap")
(define deps '("base" "request"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib" "scribble-rainbow-delimiters"))
(define scribblings '(("scribblings/amap.scrbl" ())))
(define pkg-desc "Gaode Amap web service API")
(define version "0.1")
(define pkg-authors '(yanyingwang))
