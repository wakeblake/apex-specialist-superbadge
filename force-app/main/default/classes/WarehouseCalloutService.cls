public class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public static void execute (QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            System.debug('Callout successful: returned status code 200');
            // If the request is successful, parse the JSON response into product records and upsert
            List<Product2> equipment = WarehouseCalloutServiceHelper.prepareData(response);
            if (!equipment.isEmpty()) {
                upsert equipment Product2.Warehouse_SKU__c;

            } else {
                // TODO custom event
            }

        } else {
            //TODO custom event
            System.debug('Callout failed: returned status code ' + response.getStatusCode());
        }
    }
}