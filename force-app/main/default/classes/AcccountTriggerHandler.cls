public with sharing class AcccountTriggerHandler {
    public static void afterUpdateHandler(List<Account> updatedAccounts) {
        Integer totalContacts=0;
        List<Account> accountsToUpdatePushYes = new List<Account>(); 
        List<Account> accountsToUpdatePushNo = new List<Account>(); 

        for(Account acc: updatedAccounts){
            if(acc.PushtoVendor__c == 'Yes' ){
                accountsToUpdatePushYes.add(acc);
            }else{
                accountsToUpdatePushNo.add(acc);
            }
        }

        Set<Contact> relatedContacts = new Set<Contact>([
            SELECT Id, Push_Date__c
            FROM Contact 
            WHERE AccountId 
            IN: accountsToUpdatePushYes]);

        for(Contact con : relatedContacts){
            con.Push_Date__c= datetime.now();
        }

        Set<Contact> relatedContactsPushNo = new Set<Contact>([
            SELECT Id, Push_Date__c
            FROM Contact 
            WHERE AccountId 
            IN: accountsToUpdatePushNo]);

        for(Contact con : relatedContactsPushNo){
            con.Push_Date__c=null;
        }

        relatedContactsPushNo.addAll(relatedcontacts);
        totalContacts= relatedContactsPushNo.size();

        if(totalContacts <= 200 && totalContacts!=null){
            update(new List<Contact> (relatedContactsPushNo));
        }else if(totalContacts > 200 && totalContacts <= 1000){
            Id queueableProcess= System.enqueueJob(new ContactQueueable(new List<Contact>(relatedContactsPushNo)));
        }else {
            if(!Test.isRunningTest()){
                Id batchProcess= Database.executeBatch(new ContactBatch(new List<Contact>(relatedContactsPushNo)), 150);
            }else{
                update(new List<Contact> (relatedContactsPushNo)); 
            }
        }
    }
}
