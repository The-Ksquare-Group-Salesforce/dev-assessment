public with sharing class accountBatchClass implements Database.Batchable<SObject>{
    
     List<Account> accounts;
    
    public accountBatchClass(List<Account> acctList){
       	accounts = acctList;
    }
    
    public Database.QueryLocator start(Database.BatchableContext param1){
        String query = 'SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE AccountId IN :accounts';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext param1, List<Contact> contList){
        List<Contact> contToUpdate = new List<Contact>();
        
        for(Contact cont : contList){
            if(cont.Account.PushToVendor__c == 'Yes'){
                cont.Push_Date__c = Datetime.now();
            	contToUpdate.add(cont);
            }
            else if(cont.Account.PushToVendor__c == 'No'){
                cont.Push_Date__c = null;
            	contToUpdate.add(cont);
            } 
        }
        update contToUpdate;
    }

    public void finish(Database.BatchableContext param1){}
}