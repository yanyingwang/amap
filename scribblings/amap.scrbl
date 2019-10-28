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
Set Amap's key, which key you can get it from amap webside after you sign in as a developer. And this key will be used for requesting data from it's website.
If call the procedure without @italic{key}, it'll return current value.
}



@defproc[(amap-request [path string?]
                       [parameters (listof hash? alist?)])
          http-response?]{
execute the requesting to amap api.
}

@defproc[(http-response-body/json [struct http-response?])
          jsexpr?]{
parsing the result of http requesting and retrun a racket hash data.
}



@defproc[(geocode/geo [address string?]
                       [#:city city string?]
                       [#:batch batch string? "false"]
                       [#:output output string? "json"])
          http-response?]{
return the geocode of the @italic{address}, you can also check @hyperlink["https://lbs.amap.com/api/webservice/guide/api/georegeo" "original amap doc"] for more details.
}

@defproc[(ip [ip-str string?])
          http-response?]{
return information of an IP.
}


@section{Example}

@codeblock[#:keep-lang-line? #f]|{
(require amap)

(current-amap-key "your amap key here")

(current-amap-key) ;=> show your amap key that you've just set.


> (geocode/geo "万国博览建筑群" #:city "shanghai" #:output "json")
(http-response
 200
 '#hash(("Access-Control-Allow-Origin" . "*")
        ("gsid" . "011025247218157224538140600020601890766")
        ("Date" . "Mon, 28 Oct 2019 06:49:41 GMT")
        ("Access-Control-Allow-Headers"
         .
         "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,key,x-biz,x-info,platinfo,encr,enginever,gzipped,poiid")
        ("Content-Type" . "application/json;charset=UTF-8")
        ("Access-Control-Allow-Methods" . "*")
        ("sc" . "0.011")
        ("Connection" . "close")
        ("X-Powered-By" . "ring/1.0.0")
        ("Content-Length" . "415"))
 "{\"status\":\"1\",\"info\":\"OK\",\"infocode\":\"10000\",\"count\":\"1\",\"geocodes\":[{\"formatted_address\":\"上海市黄浦区万国博览建筑群\",\"country\":\"中国\",\"province\":\"上海市\",\"citycode\":\"021\",\"city\":\"上海市\",\"district\":\"黄浦区\",\"township\":[],\"neighborhood\":{\"name\":[],\"type\":[]},\"building\":{\"name\":[],\"type\":[]},\"adcode\":\"310101\",\"street\":[],\"number\":[],\"location\":\"121.489026,31.239125\",\"level\":\"兴趣点\"}]}")



> (http-response-body/json (geocode/geo "东方明珠" #:city "shanghai" #:output "json"))
'#hasheq((count . "1")
         (geocodes
          .
          (#hasheq((adcode . "310115")
                   (building . #hasheq((name . ()) (type . ())))
                   (city . "上海市")
                   (citycode . "021")
                   (country . "中国")
                   (district . "浦东新区")
                   (formatted_address . "上海市浦东新区东方明珠")
                   (level . "兴趣点")
                   (location . "121.499740,31.239853")
                   (neighborhood . #hasheq((name . ()) (type . ())))
                   (number . ())
                   (province . "上海市")
                   (street . ())
                   (township . ()))))
         (info . "OK")
         (infocode . "10000")
         (status . "1"))



> (http-response-body/json (ip "61.151.166.146"))
'#hasheq((adcode . "310000")
         (city . "上海市")
         (info . "OK")
         (infocode . "10000")
         (province . "上海市")
         (rectangle . "120.8397067,30.77980118;122.1137989,31.66889673")
         (status . "1"))

}|
