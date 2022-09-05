public with sharing class BatchContactUpdate implements Database.Batchable<sObject> {
    Set<Id> accIdsUpdated = new Set<Id>();
    public BatchContactUpdate(SET<Id> accIdsToUpdate) {
        accIdsUpdated = accIdsToUpdate;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('accIdsUpdated----'+accIdsUpdated);
        return Database.getQueryLocator([SELECT Id, Push_Date__c, Account.PushToVendor__c, AccountId FROM Contact WHERE AccountId IN: accIdsUpdated]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope){
        for(Contact con: scope){
            con.Push_Date__c = con.Account.PushToVendor__c == 'Yes' ? System.today() : null;
        }

        if(!scope.isEmpty() && Schema.sObjectType.Contact.isUpdateable()){
            update scope;
        }
    }

    public void finish(Database.BatchableContext bc){
    }
}