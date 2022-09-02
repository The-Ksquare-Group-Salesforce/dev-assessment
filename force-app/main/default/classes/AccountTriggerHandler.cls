public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler(List<Account> accList) {
        
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
        if(contactTotal <= 200) {UpdateAccContactsSync.UpdateAccContactsSync(accList); //Done
        } else if (contactTotal <= 1000) {UpdateAccContactsAsync.UpdateAccContactsAsync(accIds);
        } else {UpdateAccContactsBatch(accList);}

        //Update Sync
        for(Contact c : [SELECT Id, Push_Date__c, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :AccIds]){
            if(c.Account.PushToVendor__c = 'Yes') {c.Push_Date__c = datetime.get();}
            if(c.Account.PushToVendor__c = 'No') {c.Push_Date__c = null;}

            conList.add(c);

            //Updating Syncronusly
            Database.update(conList,false);
        }

        //Update Async
        UpdateAccContactsAsync.UpdateAccContactsAsync(accIds);
    }
}
