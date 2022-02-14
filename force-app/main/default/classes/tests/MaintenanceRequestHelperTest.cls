@isTest
private class MaintenanceRequestHelperTest {

    //trigger fires
    @isTest
    static void testMRisRepairSubjectClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        update mr;

        Case[] mrs = [SELECT Subject, Date_Reported__c, Date_Due__c, Vehicle__r.Name, 
            (SELECT Equipment__r.Name FROM Equipment_Maintenance_Items__r) 
            FROM Case WHERE Subject='New Routine Maintenance'];

        System.assertEquals(1, mrs.size());

        for (Case newmr : mrs) {
            System.assertEquals(Date.today(), newmr.Date_Reported__c);
            System.assertEquals(Date.today().addDays(15), newmr.Date_Due__c);
            System.assertEquals('TestRV', newmr.Vehicle__r.Name);
    
            for (Equipment_Maintenance_Item__c emi : newmr.Equipment_Maintenance_Items__r) {
                System.assertEquals('Test Part', emi.Equipment__r.Name);
            }
        }
    }

    @isTest
    static void testMRisRMSubjectClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Type FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Type = 'Routine Maintenance';
        update mr;

        Case[] mrs = [SELECT Subject, Date_Reported__c, Date_Due__c, Vehicle__r.Name, 
            (SELECT Equipment__r.Name FROM Equipment_Maintenance_Items__r) 
            FROM Case WHERE Subject='New Routine Maintenance'];

        System.assertEquals(1, mrs.size());

        for (Case newmr : mrs) {
            System.assertEquals(Date.today(), newmr.Date_Reported__c);
            System.assertEquals(Date.today().addDays(15), newmr.Date_Due__c);
            System.assertEquals('TestRV', newmr.Vehicle__r.Name);

            for (Equipment_Maintenance_Item__c emi : newmr.Equipment_Maintenance_Items__r) {
                System.assertEquals('Test Part', emi.Equipment__r.Name);
            }
        }
    }

    //trigger does not fire
    @isTest
    static void testMRisRepairClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Subject = '';
        update mr;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRMClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Type, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Type = 'Routine Maintenance';
        mr.Subject = '';
        update mr;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRepairSubject() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Subject FROM Case WHERE Subject='Test Subject'];
        mr.Subject = 'Test Subject Test';
        update mr;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRMSubject() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Type, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Type = 'Routine Maintenance';
        mr.Subject = 'Test Subject Test';
        update mr;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRnoEMI() {
        TestDataGenerator.makeTriggerSingleData();
        Equipment_Maintenance_Item__c emi = [SELECT Id FROM Equipment_Maintenance_Item__c];
        delete emi;

        Case mr = [SELECT Status FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        update mr;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testBulkUpdate() {
        TestDataGenerator.makeTriggerBulkData(300);
        Case[] mrs = [SELECT Status FROM Case WHERE Subject LIKE 'TestSubject%'];
        for (Case mr : mrs) {
            mr.Status = 'Closed';
        }
        update mrs;

        Case[] newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(300, newmr.size());
    }

    @isTest
    static void testMR2relatedEquipment() {
        TestDataGenerator.makeTriggerSingleData();

        // query trigger single data
        Vehicle__c v = [SELECT Id FROM Vehicle__c WHERE Name='TestRV'];
        Case mr = [SELECT Id, Status FROM Case WHERE Subject='Test Subject'];

        // make new related equipment and junction
        Product2 eq = new Product2(
            Name = 'Test Part 2',
            Maintenance_Cycle__c = 10,
            Replacement_Part__c = true
        );
        insert eq;

        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c(
            Equipment__c = eq.Id,
            Maintenance_Request__c = mr.Id
        );
        insert emi;

        // update MR to fire trigger
        mr.Status = 'Closed';
        update mr;

        // query for 1 new MR created with 2 new EMI records and due date based on related equipment with least maintenance cycle
        Case[] mrs = [SELECT Date_Due__c, (SELECT Id FROM Equipment_Maintenance_Items__r) FROM Case WHERE Subject='New Routine Maintenance'];

        System.assertEquals(1, mrs.size());

        for (Case newmr : mrs) {
            System.assertEquals(Date.today().addDays(10), newmr.Date_Due__c);
            System.assertEquals(2, newmr.Equipment_Maintenance_Items__r.size());
        }

        

    }
}
