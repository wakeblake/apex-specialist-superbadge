public class WarehouseSyncSchedule implements Schedulable {
    // TODO at 1am daily -- '0 0 1 * * ?'
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }}