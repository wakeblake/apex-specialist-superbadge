public class WarehouseCalloutServiceHelper {
    public static List<Product2> prepareData(HttpResponse response) {
        // Deserializes the JSON string into collections of primitive data types.
        List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<Product2> equipment = new List<Product2>();

        for (Object item: results) {
            Map<String,Object> i = (Map<String,Object>) item;
            Product2 p = new Product2(
                Warehouse_SKU__c = (String) i.get('sku'),
                Replacement_Part__c = true,
                Current_Inventory__c = (Integer) i.get('quantity'),
                Cost__c = (Decimal) i.get('cost'),
                Maintenance_Cycle__c = (Integer) i.get('maintenanceperiod'),
                Lifespan_Months__c = (Integer) i.get('lifespan'),  // Might need to convert this to months?
                Name = (String) i.get('name')
            );
            equipment.add(p);
        }
        return equipment;
    }
}
