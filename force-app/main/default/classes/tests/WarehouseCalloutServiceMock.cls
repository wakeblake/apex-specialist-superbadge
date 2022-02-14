public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {

        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name='inventory']; //created static resource "inventory"... for some reason hypo won't let me use StaticResourceMock
        String body = EncodingUtil.base64Encode(sr.Body);

        HttpResponse res = new HttpResponse();
        res.setBody(body);  
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json;charset=UTF-8');
        return res;
    }
}