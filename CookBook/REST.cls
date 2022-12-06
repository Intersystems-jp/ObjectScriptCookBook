Class CookBook.REST Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter CONVERTINPUTSTREAM = 1;

/// 
/// The UrlMap determines how a Url should map to a HTTP Method and a Target ClassMethod
/// indicated by the 'Call' attribute. The call attribute is either the name of a method
/// or the name of a class and method seperated by a ':'. Parameters within the URL preceded
/// by a ':' will be extracted from the supplied URL and passed as arguments to the named method.
/// 
/// In this Route Entry GET requests to /class/namespace/classname will call the GetClass method
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass"/>
/// 
/// In this Route Entry both POST and PUT requests are dispatched to the same method.
/// Called methods can determine which verb was used by checking the value of %request.Method
/// 
/// <Route Url="/class/:namespace/:classname" Method="POST,PUT" Call="PutClass"/>
/// 
/// To influence CORS processing you can set the "Cors" attribute to "true", default is "false".
/// The "Cors" attribute is only considered if the PARAMETER 'HandleCorsRequest' is left unspecified.
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass" Cors="true"/>
/// 
/// Use a Map Entry to forward ALL requests made to a particular URL prefix. For example. If your 
/// web application has a base url route of /api/v1 and you want to map all requests to 
/// /api/v1/docserver (including all sub-urls) enter a Map entry like this:
/// 
/// <Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
/// 
/// This will result in calls such as /api/v1/docserver/class/Samples/Sample.Person being redirected
/// to the class %API.v1.DocServer ( another subclass of %CSP.REST )for futher processing. 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Call="Test" Method="POST" />
</Routes>
}

ClassMethod Test() As %Status
{
    set ^iijima=%request.Content.Read()
    set a={}
    set a.Message="OK"
    do a.%ToJSON()
    return $$$OK
}

}
