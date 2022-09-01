public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler(List<Account> accList) {
        
        //Counting number of Contacts
        Integer contactTotal = 0;
        List<Contact> = new List<Contact>();

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
        if(contactTotal <= 200) {UpdateAccContactsSync(accList);
        } else if (contactTotal <= 1000) {UpdateAccContactsAsync(accList);
        } else {UpdateAccContactsBatch(accList);}

        //Update Sync
        for(Contact c : [SELECT Id, Account.PushToVendor__C FROM Contact WHERE Id IN (AggRe)])
    }
}
