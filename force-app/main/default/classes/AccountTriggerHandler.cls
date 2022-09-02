public with sharing class AccountTriggerHandler {
    public AccountTriggerHandlerMethod(List<Account> accList) {
        
        //Declaring local variables
        Integer contactTotal = 0;
        List<Contact> conList = new List<Contact>();

        //Counting number of Contacts
        Set<Id> accIds = new Set<Id>();
    
        for(Account a : accList) {accIds.add(a.Id);}
        
        for(AggregateResult AggRe:
        [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount
        FROM Contact
        WHERE Account.Id
        IN: accIds 
        GROUP BY AccountId]) {
            contactTotal +=(Integer)AggRe.get('ContactsPerAccount');
        }
    

        //Deciding what to approach to take
        if(contactTotal <= 200) {UpdateAccContactsSync.UpdateAccContactsSyncMethod(accIds);
        } else if (contactTotal <= 1000) {UpdateAccContactsAsync.UpdateAccContactsAsyncMethod(accIds);
        } else {System.debug('Batchable');}
    }
}
