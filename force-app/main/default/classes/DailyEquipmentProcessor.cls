public class DailyEquipmentProcessor implements Schedulable {
    // TODO at 1am daily
    public void execute(SchedulableContext ctx) {
        EquipmentInventoryCallout.makeGetCallout();
    }
}
