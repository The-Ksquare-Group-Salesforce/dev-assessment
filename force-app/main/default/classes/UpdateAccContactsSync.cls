public  with sharing class UpdateAccContactsSync {
    public static void UpdateAccContactsSyncMethod(Set<Id> accIds) {

        List<Contact> conList = new List<Contact>();
        
        for(Contact c : [SELECT Id, Push_Date__c, Account.PushToVendor__c FROM Contact WHERE Account.Id IN :accIds]){
            if(c.Account.PushToVendor__c == 'Yes') {c.Push_Date__c = System.now();}
            if(c.Account.PushToVendor__c == 'No') {c.Push_Date__c = null;}
        
            conList.add(c);
        }

        //Updating Syncronusly
        Database.update(conList,false);
        return;
    }
}
