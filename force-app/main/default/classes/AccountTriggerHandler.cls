public with sharing class AccountTriggerHandler {
    public static void AccountTriggerHandlerMethod(List<Account> accList) {
        
        //Declaring local variables
        Integer contactTotal = 0;
        List<Contact> conList = new List<Contact>();

        //Counting number of Contacts
        Set<Id> accIds = new Set<Id>();

        System.debug('acclist:' + accList.size());
    
        for(Account a : accList) {accIds.add(a.Id);}
        
        for(AggregateResult AggRe:
        [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount
        FROM Contact
        WHERE Account.Id
        IN: accIds 
        GROUP BY AccountId]) {
            contactTotal +=(Integer)AggRe.get('ContactsPerAccount');
        }

        System.debug('contactTotal');
        System.debug(contactTotal);

        //Deciding what to approach to take
        if(contactTotal <= 200) {UpdateAccContactsSync.UpdateAccContactsSyncMethod(accIds);
        } else if (contactTotal > 200 && contactTotal <= 1000) {
            System.debug('async');
            UpdateAccContactsAsync async = new UpdateAccContactsAsync(accIds);
            Id contactQueue = System.enqueueJob(async);
        } else if (contactTotal > 1000) {
            System.debug('batch');
            UpdateAccContactsBatch batch = new UpdateAccContactsBatch(accIds);
            Id contactBatch = Database.executeBatch(batch, 150);
        }
    }
}