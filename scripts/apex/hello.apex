
// This gets all required fields for object
Map<String, Schema.SObjectField> eqMap = Schema.SObjectType.Case.fields.getMap();
for (String key : eqMap.keySet()) {
    Schema.SObjectField field = eqMap.get(key);
        if (!field.getDescribe().isNillable() && !field.getDescribe().isDefaultedOnCreate()) {
            system.debug(field);
        }
}

