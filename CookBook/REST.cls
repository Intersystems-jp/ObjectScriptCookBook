Class CookBook.REST Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Call="Test" Method="POST" />
</Routes>
}

ClassMethod Test() As %Status
{
    set ^tameshi=%request.Content.Read()
    set a={}
    set a.Message="OK"
    do a.%ToJSON()
    return $$$OK
}

}
