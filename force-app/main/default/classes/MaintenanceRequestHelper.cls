public class MaintenanceRequestHelper {
    public static Map<Id,Decimal> cycleMapQuery(List<Id> triggerIds) {
        Map<Id,Decimal> cycleMap = new Map<Id,Decimal>();

        for (Equipment_Maintenance_Item__c item : 

            // get MR and Prod2 objects from EMI junction
            [SELECT Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c 
                FROM Equipment_Maintenance_Item__c 
                WHERE Maintenance_Request__c IN :triggerIds]) {
    
            // add to map if not in map or if shortest mainentance cycle for item in MR
            if (cycleMap.get(item.Maintenance_Request__c) == null) {
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
