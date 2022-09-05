public class ContactUpdateBatch implements Database.Batchable<sObject> {

    public Map<Id, String> batchMap;

    public ContactUpdateBatch(Map<Id, String> contextMap) {
        batchMap = contextMap;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {


        return Database.getQueryLocator([SELECT Id, Push_Date__c FROM Contact WHERE Id IN :batchMap.keySet()]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> batchList) {
        for (Contact contact : batchList){
            if(batchMap.get(contact.Id) == 'Yes'){
                contact.Push_Date__c = System.now();
            }
            else {
                contact.Push_Date__c = null;
            }
        }
        if (!batchList.isEmpty()){
            update batchList;

        }

    }

    public void finish(Database.BatchableContext bc) {
    }

} 
        