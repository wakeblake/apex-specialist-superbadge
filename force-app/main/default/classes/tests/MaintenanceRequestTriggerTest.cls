@isTest
private class MaintenanceRequestTriggerTest {

    //trigger fires
    @isTest
    static void testMRisRepairSubjectClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        update c;

        Case newmr = [SELECT Subject, Date_Reported__c, Date_Due__c, Vehicle__r.Name, ProductId.Name FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(1, newmr.size());
        System.assertEquals(Date.today(), newmr.Date_Reported__c);
        System.assertEquals(Date.today().addDays(15), newmr.Date_Due__c);
        System.assertEquals('Teardrop Camper', newmr.Vehicle__r.Name);
        System.assertEquals('Test Part', newmr.ProductId.Name);
    }

    static void testMRisRMSubjectClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Type FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Type = 'Routine Maintenance';
        update c;

        Case newmr = [SELECT Subject, Date_Reported__c, Date_Due__c, Vehicle__r.Name, ProductId.Name FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(1, newmr.size());
        System.assertEquals(Date.today(), newmr.Date_Reported__c);
        System.assertEquals(Date.today().addDays(15), newmr.Date_Due__c);
        System.assertEquals('Teardrop Camper', newmr.Vehicle__r.Name);
        System.assertEquals('Test Part', newmr.ProductId.Name);
    }

    //trigger does not fire
    @isTest
    static void testMRisRepairClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Subject = '';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRMClosed() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Status, Type, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        mr.Type = 'Routine Maintenance';
        mr.Subject = '';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRepairSubject() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Subject FROM Case WHERE Subject='Test Subject'];
        mr.Subject = 'Test Subject Test';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRisRMSubject() {
        TestDataGenerator.makeTriggerSingleData();
        Case mr = [SELECT Type, Subject FROM Case WHERE Subject='Test Subject'];
        mr.Type = 'Routine Maintenance';
        mr.Subject = 'Test Subject Test';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testMRnoEMI() {
        TestDataGenerator.makeTriggerSingleData();
        Equipment_Maintenance_Item__c emi = [SELECT Id FROM Equipment_Maintenance_Item__c];
        delete emi;

        Case mr = [SELECT Status FROM Case WHERE Subject='Test Subject'];
        mr.Status = 'Closed';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(0, newmr.size());
    }

    @isTest
    static void testBulkUpdate() {
        TestDataGenerator.makeTriggerBulkData(300);
        Case mr = [SELECT Status FROM Case WHERE Subject LIKE 'TestSubject%'];
        mr.Status = 'Closed';
        update c;

        Case newmr = [SELECT Id FROM Case WHERE Subject='New Routine Maintenance'];
        System.assertEquals(300, newmr.size());
    }
    // need to create test for helper?
}
