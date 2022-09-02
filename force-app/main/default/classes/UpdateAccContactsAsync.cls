public with sharing class UpdateAccContactsAsync {
    @future
    public static void UpdateAccContactsAsyncMethod(Set<Id> accIds) {

        List<Contact> conList = new List<Contact>();

        for(Contact c : [SELECT Id, Push_Date__c, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :accIds]){
            if(c.Account.PushToVendor__c == 'Yes') {c.Push_Date__c = System.now();}
            if(c.Account.PushToVendor__c == 'No') {c.Push_Date__c = null;}

            conList.add(c);
        }

        //Update Async
        Database.update(conList,false);
    }
}
