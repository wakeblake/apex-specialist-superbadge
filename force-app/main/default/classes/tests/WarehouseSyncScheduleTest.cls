@isTest
private class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 1 * * ?';   // sec min hr day_of_mo mo_of_yr day_of_wk

    @isTest
    static void testScheduledQueueableJob() {
        // Set up mock resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('inventory');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        String jobId = System.schedule( 
            'WarehouseSyncScheduleJob',
            CRON_EXP,
            new WarehouseSyncSchedule()
        );
        Test.stopTest();

        CronTrigger[] cts = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE Id=:jobId];
        System.assertEquals(1, cts.size(), 'Scheduled job does not exist');
        for (CronTrigger ct : cts) {
            System.assertEquals('WarehouseSyncScheduleJob', ct.CronJobDetail.Name, 'Scheduled job does not exist');
        }

        // Can't check DML op upsert because async callout class within async schedulable class won't execute in test context
    }
}