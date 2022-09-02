public with sharing class UpdateAccContactsSync {
    public UpdateAccContactsSync(List<Account> accList) {
        //Update Sync
        for(Contact c : [SELECT Id, Push_Date__c, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :AccIds]){
            if(c.Account.PushToVendor__c = 'Yes') {c.Push_Date__c = datetime.get();}
            if(c.Account.PushToVendor__c = 'No') {c.Push_Date__c = null;}
        
            conList.add(c);
        
            //Updating Syncronusly
            Database.update(conList,false);
        }
    }
}
