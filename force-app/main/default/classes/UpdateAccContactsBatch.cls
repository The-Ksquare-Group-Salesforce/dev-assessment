public with sharing class UpdateAccContactsBatch implements Database.Batchable<Contact> {

    List<Contact> toUpdate = new List<Contact>();

    public Database.QueryLocator start(Database.BatchableContext BC){

    }

    public void execute(Database.BatchableContext BC, List<Contact> scope){

    }

    public void finish(Database.BatchableContext BC){
        
    }
}
