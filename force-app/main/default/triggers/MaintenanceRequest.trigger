trigger MaintenanceRequest on Case (after insert, after update) {

    if (Trigger.isInsert) {

        //auto schedule MR based on install date (CreatedDate)?
    }

    if (Trigger.isUpdate) {
        Map<Id,Integer> cycleMap = MaintenanceRequestHelper.cycleMapQuery(Trigger.newMap.keySet());
        List<Case> newMRs = new List<Case>();

        for (Case mr : Trigger.new) {
            // MR must be type ("repair" or "routine maintenance") and EMI must exist
            if ( (mr.Type == 'Repair' || mr.Type == 'Routine Maintenance') && cycleMap.get(mr.Id) ) {

                // MR must have subject and is closed
                if (mr.Subject && mr.isClosed) {
                    Case newMR = new Case(
                        Subject = 'New Routine Maintenance',
                        Type = 'Routine Maintenance',
                        Date_Reported__c = Date.today(),
                        Date_Due__c = Date.today().addDays( cycleMap.get(mr.Id).Equipment__r.Maintenance_Cycle__c )
                    );
                    newMRs.add(newMR);
                }
            }
        }

        insert newMRs;
    }

}