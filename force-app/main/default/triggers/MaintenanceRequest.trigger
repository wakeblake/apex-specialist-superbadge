trigger MaintenanceRequest on Case (after insert, after update) {

    if (Trigger.isInsert) {

        //auto schedule MR based on install date (CreatedDate)?
    }

    if (Trigger.isUpdate) {
        Map<Id,Decimal> cycleMap = MaintenanceRequestHelper.cycleMapQuery(Trigger.newMap.keySet());
        Map<Id,List<Id>> relEquipMap = MaintenanceRequestHelper.relatedEquipmentQuery(Trigger.newMap.keySet());
        Map<Case,List<Equipment_Maintenance_Item__c>> newEquipMap = new Map<Case,List<Equipment_Maintenance_Item__c>>();
        List<Case> newMRs = new List<Case>();

        for (Case mr : Trigger.new) {
            // MR must be type ("repair" or "routine maintenance") and EMI must exist
            if ( (mr.Type == 'Repair' || mr.Type == 'Routine Maintenance') && cycleMap.containsKey(mr.Id) ) {

                // MR must have subject and is closed
                if (!String.isEmpty(mr.Subject) && mr.isClosed) {
                    // create new MR
                    Case newMR = new Case(
                        Subject = 'New Routine Maintenance',
                        Type = 'Routine Maintenance',
                        Date_Reported__c = Date.today(),
                        Date_Due__c = Date.today().addDays( (Integer) cycleMap.get(mr.Id) ),
                        Vehicle__c = mr.Vehicle__c
                    );
                    newMRs.add(newMR);

                    // create new EMIs for new MRs that preserve related equipment records
                    List<Equipment_Maintenance_Item__c> newEMIs = new List<Equipment_Maintenance_Item__c>();
                    if (relEquipMap.containsKey(mr.Id)) {
                        List<Id> relatedEquipment = relEquipMap.get(mr.Id);
                        for (Id eqId : relatedEquipment) {
                            Equipment_Maintenance_Item__c newEMI = new Equipment_Maintenance_Item__c(   
                                Equipment__c = eqId
                            );
                            newEMIs.add(newEMI);
                            newEquipMap.put(newMR, newEMIs);
                        }
                    }
                }
            }
        }
        insert newMRs;

        // Add new MR ids to new EMIs and insert
        List<Equipment_Maintenance_Item__c> newEMIsAll = new List<Equipment_Maintenance_Item__c>();
        for (Case newMR : newEquipMap.keySet()) {  // did insert populate ids on Case objects?
            for (Equipment_Maintenance_Item__c emi : newEquipMap.get(newMR)) {
                emi.Maintenance_Request__c = newMR.Id;
                newEMIsAll.add(emi);
            }
        }
        insert newEMIsAll;
    }
}