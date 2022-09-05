public with sharing class PushContactBatch implements Database.Batchable<SObject>, Database.Stateful{
    private PushContactBatch(){}
    private List<Id> accountsId;
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id,Account.PushToVendor__c From Contact Where AccountId In :accountsId');
    }
    public void execute(Database.BatchableContext BC, List<Contact> scope){
        PushContactHelper.updateContacts(scope);
    }
    public void finish(Database.BatchableContext BC){}
    public static Id execute(List<Id> accountsId){
        if(accountsId == null || accountsId.isEmpty())
            throw new PushContactBatchException('Empty accountsId');
        PushContactBatch b = new PushContactBatch();
        b.accountsId = accountsId;
        return Database.executeBatch(b,Constants.PUSH_CONTACT_BATCH_CHUNK);
    }
    public class PushContactBatchException extends Exception{}
}