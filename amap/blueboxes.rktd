312
((3) 0 () 1 ((q lib "amap/main.rkt")) () (h ! (equal) ((c def c (c (? . 0) q geocode/geo)) q (281 . 9)) ((c def c (c (? . 0) q current-amap-key)) q (0 . 3)) ((c def c (c (? . 0) q http-response-body/json)) q (194 . 3)) ((c def c (c (? . 0) q amap-request)) q (67 . 4)) ((c def c (c (? . 0) q ip)) q (589 . 3))))
procedure
(current-amap-key key) -> string?
  key : string?
procedure
(amap-request path parameters) -> http-response?
  path : string?
  parameters : (listof hash? alist?)
procedure
(http-response-body/json struct) -> jsexpr?
  struct : http-response?
procedure
(geocode/geo  address               
              #:city city           
             [#:batch batch         
              #:output output]) -> http-response?
  address : string?
  city : string?
  batch : string? = "false"
  output : string? = "json"
procedure
(ip ip-str) -> http-response?
  ip-str : string?
