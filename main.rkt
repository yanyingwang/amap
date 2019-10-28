#lang racket/base

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

(require request
         json
         racket/format
         racket/string
         racket/dict
         #;net/uri-codec)

(provide place/text
         geocode/regeo
         geocode/geo
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
  (and city (set! parameters (dict-set parameters 'city city)))
  (amap-request "geocode/geo" parameters))

(define (geocode/regeo location
                       #:poitype [poitype #f]
                       #:radius [radius 100]
                       #:extensions [extensions "base"]
                       #:batch [batch "false"]
                       #:roadlevel [roadlevel #f]
                       #:output [output "json"]
                       #:homeorcorp [homeorcorp 0])
  (define parameters (hash 'location location
                           'radius radius
                           'extensions extensions
                           'homeorcorp homeorcorp
                           'batch batch
                           'output output))
  (and poitype (set! parameters (dict-set parameters 'poitype poitype)))
  (and roadlevel (set! parameters (dict-set parameters 'roadlevel roadlevel)))
  (amap-request "geocode/regeo" parameters))

(define (ip ip)
  (amap-request "ip" (hash 'ip ip)))


(define (place/text #:keywords [keywords #f]
                    #:types [types #f]
                    #:city [city #f]
                    #:citylimit [citylimit "false"]
                    #:children [children 0]
                    #:offset [offset 20]
                    #:page [page 1]
                    #:extensions [extensions "base"]
                    #:output [output "json"])
  (define parameters (hash 'citylimit citylimit
                           'children children
                           'offset offset
                           'page page
                           'extensions extensions
                           'output output))
  (and keywords (set! parameters (dict-set parameters 'keywords keywords)))
  (and types (set! parameters (dict-set parameters 'types types)))
  (and city (set! parameters (dict-set parameters 'city city)))
  (amap-request "place/text" parameters))





;;;;;;;;;;;;;;;;;;;;;;;;
;; ====== test ====== ;;
;;;;;;;;;;;;;;;;;;;;;;;;


(module+ test
  ;; Any code in this `test` submodule runs when this file is run using DrRacket
  ;; or with `raco test`. The code here does not run when this file is
  ;; required by another module.
  (current-amap-key (getenv "KEY"))
  (check-equal? (current-amap-key) (getenv "KEY"))

  (check-equal? 200
                (http-response-code (amap-request "geocode/geo" (hash 'address "上海市黄浦区外滩18号"))))

  (check-true (jsexpr?
               (http-response-body/json (amap-request "geocode/geo" (hash 'address "上海市黄浦区外滩18号")))))

  (check-equal? 200
                (http-response-code (geocode/geo "上海市黄浦区外滩18号")))

  (check-equal? 200
                (http-response-code (geocode/geo "万国博览建筑群"
                                                 #:city "shanghai"
                                                 #:output "xml")))
  (check-equal? 200
                (http-response-code (geocode/regeo "121.489822,31.238416")))

  (check-equal? 200
                (http-response-code (ip "61.151.166.146")))


  )

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
