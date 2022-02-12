@isTest
private class DailyEquipmentProcessorTest {
    public static String CRON_EXP = '0 0 1 * * ?';   // sec min hr day_of_mo mo_of_yr day_of_wk

    /* Don't need this -- see below 
    @TestSetup
    static void makeData() {
        List<Product2> equipmentNew = TestDataGenerator.makeNewEquipment(280);
        List<Product2> equipmentInventory = TestDataGenerator.makeEquipmentFromInventory(2); // max 22 records based on callout endpoint "https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.220267359.694211834.1644259922-527157570.1638226418"
        insert equipmentNew;
        insert equipmentInventory;
    }
    */

    @isTest
    static void testScheduledJob() {
        // Set up mock resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('inventory');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
  
        Product2[] equipmentBefore = [SELECT Id FROM Product2];
        
        Test.startTest();
        String jobId = System.schedule(
            'Import Warehouse Inventory',
            CRON_EXP,
            new DailyEquipmentProcessor()
        );
        //System.assertEquals(282, equipmentBefore.size(), 'TestDataGenerator did not insert 280 dummy records and 2 inventory records');
        Test.stopTest();

        CronTrigger[] ct = [SELECT Id FROM CronTrigger WHERE Id=:jobId];
        System.assertEquals(1, ct.size(), 'Schedulable apex not queued');

        /* Can't check DML ops because async callout class within async schedulable class won't execute in test context

        Product2[] equipmentAfter = [SELECT Id FROM Product2]; // 20 new callout inventory records will be created (20 new + 2 existing)
        System.assertEquals(302, equipmentAfter.size(), 'Schedulable apex did not create 20 new inventory records');

        Product2[] inventory = [SELECT Id FROM Product2 WHERE Name LIKE 'Part%'];
        System.assertEquals(280, inventory.size(), 'Schedulable apex did not update 2 existing inventory records');
        */
    }
}
