@isTest
public class TestDataGenerator {

    public static List<Product2> makeNewEquipment(Integer numNew) {
        // new equipment not already existing in callout inventory
        List<Product2> equipment = new List<Product2>();
        for (Integer i=0; i < numNew; i++) {
            Product2 p = new Product2(
                Warehouse_SKU__c = String.valueOf(200000 + i),
                Replacement_Part__c = true,
                Current_Inventory__c = 100,
                Cost__c = 100 * i,
                Maintenance_Cycle__c = 10 * i,
                Lifespan_Months__c = 2 + i,
                Name = 'Part' + String.valueOf(i)
            );
            equipment.add(p);
        }
        return equipment;
    }

    public static List<Product2> makeEquipmentFromInventory(Integer numExisting) {
        // callout inventory contains 22 records (sku 100001 - 100022) 
        //from "https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.220267359.694211834.1644259922-527157570.1638226418"
        List<Product2> equipment = new List<Product2>();
        for (Integer i=0; i < numExisting; i++) {
            Product2 p = new Product2(
                Warehouse_SKU__c = String.valueOf(100000 + i),
                Replacement_Part__c = true,
                Current_Inventory__c = 100,
                Cost__c = 100 * i,
                Maintenance_Cycle__c = 10 * i,
                Lifespan_Months__c = 2 + i,
                Name = 'Part' + String.valueOf(i)
            );
            equipment.add(p);
        }
        return equipment;
    }

    public static void makeTriggerSingleData() {
        Product2 eq = new Product2(
            Name = 'Test Part',
            Maintenance_Cycle__c = 15,
            Replacement_Part__c = true
        );
        insert eq;

        Vehicle__c v = new Vehicle__c(
            Name = 'TestRV'
        );
        insert v;
        
        Case c = new Case(
            Type = 'Repair',
            Subject = 'Test Subject',
            Status = 'New',
            Vehicle__c = v.Id
        );
        insert c;

        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c(
            Equipment__c = eq.Id,
            Maintenance_Request__c = c.Id
        );
        insert emi;
    }

    public static void makeTriggerBulkData(Integer numCaseRecords) {
        // creates multiple MR records using same related Equipment and Vehicle records
        Product2 eq = new Product2(
            Name = 'Test Part',
            Maintenance_Cycle__c = 15,
            Replacement_Part__c = true
        );
        insert eq;

        Vehicle__c v = new Vehicle__c(
            Name = 'TestRV'
        );
        insert v;

        List<Case> cases = new List<Case>();
        List<Equipment_Maintenance_Item__c> emis = new List<Equipment_Maintenance_Item__c>();
        for (Integer i=0; i < numCaseRecords; i++) {
            Case c = new Case(
                Type = 'Repair',
                Subject = 'TestSubject' + String.valueOf(i),
                Status = 'New',
                Vehicle__c = v.Id
            );
            cases.add(c);
        }
        insert cases;

        for (Case c : cases) {
            Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c(
                Equipment__c = eq.Id,
                Maintenance_Request__c = c.Id
            );
            emis.add(emi);
        }
        insert emis;
    }
}
