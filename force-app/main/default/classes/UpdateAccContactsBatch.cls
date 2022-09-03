public with sharing class UpdateAccContactsBatch implements Database.Batchable<Contact> {

    Set<Id> accIds = new Set<Id>();

    public UpdateAccContactsBatch(Set<Id> accIdsParam)
    {
        accIds = accIdsParam;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Push_Date__c, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :accIds';
    }

    public void execute(Database.BatchableContext BC, List<Contact> scope){
        
    }

    public void finish(Database.BatchableContext BC){

    }
}
