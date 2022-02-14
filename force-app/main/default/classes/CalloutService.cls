public class CalloutService {

    @future(callout=true)
    public static HttpResponse makeGetCallout(String calloutURL) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(calloutURL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;
    }
}
