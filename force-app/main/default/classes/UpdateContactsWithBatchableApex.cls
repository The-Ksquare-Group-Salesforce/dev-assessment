public with sharing class UpdateContactsWithBatchableApex implements Database.Batchable<sObject> {
    
    Set<Id> accsToUpdatedWithYesBatch = new Set<Id>();
    Set<Id> accsToUpdatedWithNoBatch = new Set<Id>();
    Set<Id> accIdsBatch = new Set<Id>();
    List<Contact> contactsToUpdateBatch =  new List<Contact>();

    public UpdateContactsWithBatchableApex(Set<Id> accIds,Set<Id> accsToUpdatedWithYes,Set<Id> accsToUpdatedWithNo) {
        this.accIdsBatch = accIds;
        this.accsToUpdatedWithYesBatch = accsToUpdatedWithYes;
        this.accsToUpdatedWithNoBatch = accsToUpdatedWithNo;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Name, Id, AccountId, Push_Date__c FROM Contact WHERE AccountId IN:accIdsBatch]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> contactsList){
        for (Contact cont : contactsList) {
            if(accsToUpdatedWithYesBatch.contains(cont.AccountId)){
                cont.Push_Date__c = System.now();
                contactsToUpdateBatch.add(cont);
            }
            else if (accsToUpdatedWithNoBatch.contains(cont.AccountId)) {
                cont.Push_Date__c = Null;
                contactsToUpdateBatch.add(cont);
            }
        }
        Update contactsToUpdateBatch;
    }
  
    public void finish(Database.BatchableContext bc){

    }

}
