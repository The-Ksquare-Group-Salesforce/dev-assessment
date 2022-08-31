public with sharing class AccountHandler {
    public static void updateContacts(List<Account> acclist){

        List<Contact> consToUpdate = [Select Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE AccountId in :acclist];
        
        for(Contact con: consToUpdate){
            if(con.Account.PushToVendor__c == 'Yes'){
                con.Push_Date__c = Date.today();
            }
            else if(con.Account.PushToVendor__c == 'No'){
                con.Push_Date__c = null;
            }
        }

        if(consToUpdate.size() <= 200 && consToUpdate.size() > 0){
           
            update consToUpdate;

        } else if (consToUpdate.size()<= 1000){
            ID jobID = System.enqueueJob(new AccountQueuebleClass(consToUpdate));
        }
        
        else if(consToUpdate.size()> 1000){   
            ID batch = Database.executeBatch(new AccountBatchClass(consToUpdate), 150);
        }


    }

}