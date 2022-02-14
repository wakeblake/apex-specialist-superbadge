public class MaintenanceRequestHelper {
    public static Map<Id,List<Id>> relatedEquipmentQuery(Set<Id> triggerIds) {
        Map<Id,List<Id>> relatedEquipment = new Map<Id,List<Id>>();
        for (Case mr : 
            [SELECT Id, (SELECT Equipment__c FROM Equipment_Maintenance_Items__r) 
            FROM Case 
            WHERE Id IN :triggerIds]) {
            
            List<Id> products = new List<Id>();
            for (Equipment_Maintenance_Item__c emi : mr.Equipment_Maintenance_Items__r) {
                products.add(emi.Equipment__c);
            }
            relatedEquipment.put(mr.Id, products);
        }      
        return relatedEquipment;
    }

    public static Map<Id,Decimal> cycleMapQuery(Set<Id> triggerIds) {
        Map<Id,Decimal> cycleMap = new Map<Id,Decimal>();
        for (Equipment_Maintenance_Item__c item : 

            // get MR and Equipment objects from EMI junction
            [SELECT Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c 
                FROM Equipment_Maintenance_Item__c 
                WHERE Maintenance_Request__c IN :triggerIds]) {
    
            // add to map if not in map or if shortest mainentance cycle for item in MR
            if (!cycleMap.containsKey(item.Maintenance_Request__c)) {
                cycleMap.put(item.Maintenance_Request__c, item.Equipment__r.Maintenance_Cycle__c);

            } else {
                Decimal mappedCycleDays = cycleMap.get(item.Maintenance_Request__c);
                Decimal itemCycleDays = item.Equipment__r.Maintenance_Cycle__c;
                if (itemCycleDays < mappedCycleDays) {
                    cycleMap.put(item.Maintenance_Request__c, item.Equipment__r.Maintenance_Cycle__c);
                } 
            }
        }
        
        return cycleMap;
    }

}
