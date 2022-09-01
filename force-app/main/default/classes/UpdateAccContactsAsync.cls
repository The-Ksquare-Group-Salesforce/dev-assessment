public with sharing class UpdateAccContactsAsync {
    @future
    public static void UpdateAccContactsAsync(Set<Id> accIds) {

        List<Contact> conList = new List<Contact>();

        for(Contact c : [SELECT Id, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :AccIds]){
            if(c.Account.PushToVendor__c == 'Yes') {c.Push_Date__c = now();}
            if(c.Account.PushToVender__c == 'No') {c.Push_Date__c = null;}

            conList.add(c);
        }

        //Update Async
        Database.update(conList,false);
    }
}
