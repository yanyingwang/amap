#lang scribble/manual
@require[@for-label[amap
                    racket/base]]

@title{amap}
@author[(author+email "Yanying Wang" "yanyingwang1@gmail.com")]
@defmodule[amap]

Gaode Amap web service API, please check @hyperlink["https://lbs.amap.com/api/webservice/summary/" "offical api page"].

@hyperlink["https://gitlab.com/yanyingwang/amap" "source code"]

@[table-of-contents]

@section{Procedure Reference}


@defproc[(current-amap-key [key string?]) string?]{
set Amap's key, which key you can get it from amap webside after you sign in as a developer. And this key will be used by request data from it's website.
}



@defproc[(ip-location [ip string?]) hash?]{
return information about this ip.
}


@section{Example}

@codeblock[#:keep-lang-line? #f]|{
(require amap)

(current-amap-key "your amap key here")

(current-amap-key) ;=> show your amap key that you've just set.

(ip-location "58.33.7.162")
;=> '#hasheq((adcode . "310000")
;            (city . "上海市")
;            (info . "OK")
;            (infocode . "10000")
;            (province . "上海市")
;            (rectangle . "120.8397067,30.77980118;122.1137989,31.66889673")
;            (status . "1"))

}|
