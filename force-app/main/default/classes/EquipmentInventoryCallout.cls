public class EquipmentInventoryCallout {

    // future void method so that we can call from schedulable apex
    @future(callout=true)
    public static void makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.220267359.694211834.1644259922-527157570.1638226418');                         // HERE
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            System.debug('Callout successful: returned status code 200');
            // If the request is successful, parse the JSON response into product records and upsert
            List<Product2> equipment = EquipmentInventoryCalloutHelper.prepareData(response);
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
