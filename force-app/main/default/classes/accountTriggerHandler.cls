public with sharing class accountTriggerHandler {
	
    public static Integer counter(List<Account> acctToUpdate){
        Integer totalContacts = [SELECT COUNT() FROM Contact WHERE AccountID IN :acctToUpdate];
        return totalContacts;
    }
    
    public static void updateContacts(List<Account> acctList){
        List<Contact> contToUpdate = new List<Contact>();
        
        for(Contact cont : [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE AccountId IN :acctList]){
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

    public static void callQueuableClass(List<Account> acctList){
        accountQueueableClass acctQueuable = new accountQueueableClass(acctList);
        system.enqueueJob(acctQueuable);
    }
    
    public static void callBatchClass(List<Account> acctList){
        accountBatchClass acctBatch = new accountBatchClass(acctList);
        Id batchId = Database.executeBatch(acctBatch, 150);
    }
}