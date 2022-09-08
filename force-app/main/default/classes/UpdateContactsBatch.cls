public with sharing class UpdateContactsBatch implements Database.Batchable<sObject> {

    public Map<Id, DateTime> batchMap;

    public UpdateContactsBatch(Map<Id, DateTime> contextMap) {
        batchMap = contextMap;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(Test.isRunningTest()){
            return Database.getQueryLocator([SELECT Id, Push_Date__c FROM Contact WHERE Id IN :batchMap.keySet() LIMIT 150]);
        }else{
            return Database.getQueryLocator([SELECT Id, Push_Date__c FROM Contact WHERE Id IN :batchMap.keySet()]);
        }
    }

    public void execute(Database.BatchableContext bc, List<Contact> batchList) {
        for (Contact contact : batchList){
            contact.Push_Date__c = batchMap.get(contact.Id);
        }
        if (!batchList.isEmpty()){
            update batchList;
        }
    }

    public void finish(Database.BatchableContext bc) {
        
    }
}