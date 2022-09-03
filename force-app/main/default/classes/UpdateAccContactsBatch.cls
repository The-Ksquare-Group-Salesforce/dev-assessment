public with sharing class UpdateAccContactsBatch implements Database.Batchable<Contact> {

    Set<Id> accIds = new Set<Id>();

    public UpdateAccContactsBatch(Set<Id> accIdsParam)
    {
        accIds = accIdsParam;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE Account.Id IN :accIds';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Contact> scope){

        List<Contact> conList = new List<Contact>();

        for(Contact c: scope){
            if(c.Account.PushToVendor__c == 'Yes') {c.Push_Date__c = System.now();}
            if(c.Account.PushToVendor__c == 'No') {c.Push_Date__c = null;}

            conList.add(c);
        }
        Database.update(conList,false);
    }

    public void finish(Database.BatchableContext BC){

    }
}
