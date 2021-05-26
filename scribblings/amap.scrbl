#lang scribble/manual
@require[@for-label[amap
                    racket/base]
         scribble-rainbow-delimiters]

@script/rainbow-delimiters*

@title{amap}
@author[(author+email "Yanying Wang" "yanyingwang1@gmail.com")]
@defmodule[amap]

Gaode Amap web service API, Check out @hyperlink["https://lbs.amap.com/api/webservice/summary/" "official api page"] as well.

@table-of-contents[]




@section{Examples}

@racketinput[(current-amap-key "put your amap key here")]

@#reader scribble/comment-reader
(racketinput
(current-amap-key) ; show your amap key that you've just setted
)

@racketinput[
(geocode/geo "万国博览建筑群" #:city "shanghai" #:output "xml")
(http-response
 200
 '#hash(("Access-Control-Allow-Origin" . "*")
        ("Date" . "Mon, 28 Oct 2019 07:20:58 GMT")
        ("sc" . "0.009")
        ("Transfer-Encoding" . "chunked")
        ("Vary" . "Accept-Encoding")
        ("Access-Control-Allow-Headers"
         .
         "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,key,x-biz,x-info,platinfo,encr,enginever,gzipped,poiid")
        ("Content-Type" . "application/xml;charset=UTF-8")
        ("gsid" . "011025230097157224725840000020375504374")
        ("Connection" . "close")
        ("Access-Control-Allow-Methods" . "*")
        ("X-Powered-By" . "ring/1.0.0"))
 "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response><status>1</status><info>OK</info><infocode>10000</infocode><count>1</count><geocodes type=\"list\"><geocode><formatted_address>上海市黄浦区万国博览建筑群</formatted_address><country>中国</country><province>上海市</province><citycode>021</citycode><city>上海市</city><district>黄浦区</district><township></township><neighborhood><name></name><type></type></neighborhood><building><name></name><type></type></building><adcode>310101</adcode><street></street><number></number><location>121.489026,31.239125</location><level>兴趣点</level></geocode></geocodes></response>")
]
@racketinput[
(http-response-body/json
  (geocode/geo "东方明珠" #:city "shanghai"))
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
]

@racketinput[
(http-response-body/json (ip "61.151.166.146"))
'#hasheq((adcode . "310000")
         (city . "上海市")
         (info . "OK")
         (infocode . "10000")
         (province . "上海市")
         (rectangle . "120.8397067,30.77980118;122.1137989,31.66889673")
         (status . "1"))
]


@section{API}
@defproc[(current-amap-key [key string?]) string?]{
Set Amap's API key, which key you can get it from the Amap webside after you sign in as a developer. And this key will be used for requesting data from it's website.
@linebreak[]
If calling the procedure without @italic{key}, it'll show the current value.
}

@defproc[(amap-request [path string?]
                       [parameters (listof hash? alist?)])
          http-response?]{
Execute the requesting to amap API.
}

@defproc[(http-response-body/json [struct http-response?])
          jsexpr?]{
Parsing the result of http requesting and retrun a racket hash data.
}



@defproc[(geocode/geo [address string?]
                       [#:city city string?]
                       [#:batch batch string? "false"]
                       [#:output output string? "json"])
          http-response?]{
Returns the geocode of the @italic{address}, you can also check @hyperlink["https://lbs.amap.com/api/webservice/guide/api/georegeo" "original amap doc"] for more details.
}

@defproc[(ip [ip-str string?])
          http-response?]{
Returns information of an IP.
}
