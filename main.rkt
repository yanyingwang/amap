#lang at-exp racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included a LICENSE.txt file, which links to
;; the GNU Lesser General Public License.
;; If you would prefer to use a different license, replace LICENSE.txt with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

;; Code here


(require request
         json
         racket/format
         racket/string
         racket/dict
         net/uri-codec)

(provide geocode/geo
         ip

         http-response-body/json
         http-response-body
         http-response-headers
         http-response-code
         amap-request

         current-amap-key)

(define current-amap-key (make-parameter ""))


(define (amap-request path parameters)
  (set! parameters (dict-set parameters 'key (current-amap-key)))
  (define parameters-str (string-join (for/list ([(k v) (in-dict parameters)])
                                        (format "~a=~a" k v))
                                      "&"))
  (get (make-domain-requester "restapi.amap.com" http-requester)
       (format "/v3/~a?~a" path parameters-str)))

(define (http-response-body/json response)
  (string->jsexpr (http-response-body response)))




(define (geocode/geo address
                     #:city [city #f]
                     #:batch [batch "false"]
                     #:output [output "json"])

  (define parameters (hash 'address address
                           'batch batch
                           'output output))
  (and city
       (set! parameters (dict-set parameters 'city city)))

  (amap-request "geocode/geo" parameters))


(define (ip ip)
  (amap-request "ip" (hash 'ip ip)))



(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.

  (check-equal? (+ 2 2) 4))

(module+ main
  ;; (Optional) main submodule. Put code here if you need it to be executed when
  ;; this file is run using DrRacket or the `racket` executable.  The code here
  ;; does not run when this file is required by another module. Documentation:
  ;; http://docs.racket-lang.org/guide/Module_Syntax.html#%28part._main-and-test%29

  (require racket/cmdline)
  (define who (box "world"))
  (command-line
    #:program "my-program"
    #:once-each
    [("-n" "--name") name "Who to say hello to" (set-box! who name)]
    #:args ()
    (printf "hello ~a~n" (unbox who))))







;; (define (fribble interesting-arg option-1 option-2 option-3)
;;   (displayln interesting-arg)
;;   (displayln option-1)
;;   (displayln option-2)
;;   (displayln option-3)
;;   )

;; (define current-fribble-option-1 (make-parameter "a"))
;; (define current-fribble-option-2 (make-parameter "b"))
;; (define current-fribble-option-3 (make-parameter "c"))

;; (define (fribble interesting-arg)
;;   (displayln interesting-arg)
;;   (displayln (current-fribble-option-1))
;;   (displayln (current-fribble-option-2))
;;   (displayln (current-fribble-option-3))
;;   )
