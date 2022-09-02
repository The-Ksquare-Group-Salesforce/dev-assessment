public with sharing class ContactBatch implements Database.Batchable<SObject> {
    sObject[] source;

    public ContactBatch(sObject[] records){
        source=records;
    }

    public sObject[] start(Database.BatchableContext context){
        return source;
    }

    public void execute(Database.BatchableContext context, sObject[] scope){
        update scope;
    }

    public void finish(Database.BatchableContext context){
        System.debug('Finished Batch Job');
    }
}