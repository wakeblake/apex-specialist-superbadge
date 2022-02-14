/*
// This gets all required fields for object
Map<String, Schema.SObjectField> eqMap = Schema.SObjectType.Vehicle__c.fields.getMap();
for (String key : eqMap.keySet()) {
    Schema.SObjectField field = eqMap.get(key);
        if (!field.getDescribe().isNillable() && !field.getDescribe().isDefaultedOnCreate()) {
            system.debug(field);
        }
}
*/

String jobId = System.schedule('WarehouseSyncScheduleJob', '0 0 1 * * ?', new WarehouseSyncSchedule());
system.debug(jobId);

        
