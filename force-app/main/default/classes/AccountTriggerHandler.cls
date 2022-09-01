public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler(List<Account> accList) {
        
        //Counting number of Contacts
        Integer contactTotal = 0;

        Set<Id> accIds = new Set<Id>();
    
        for(Account a : accList) {accIds.add(a.Id);}
        
        for(AggregateResult AggRe:
        [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount
        FROM Contact
        WHERE Account.Id
        IN: accIds 
        GROUP BY AccountId]) {
            contactTotal +=(Integer)ar.get('ContactsPerAccount');
        }
    
        if(contactTotal <= 200) {System.debug('<= 200');
        } else if (contactTotal <= 1000) {System.debug('<=1k');
        } else {System.debug('>1k');}
    }
}
