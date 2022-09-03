public with sharing class UpdateAccContactsAsync  implements Queueable{

    Set<Id> accIds = new Set<Id>();

    public UpdateAccContactsAsync(Set<Id> accIdsParam){
        accIds = accIdsParam;
    }

    public void execute(QueueableContext context) {

        List<Contact> conList = new List<Contact>();

        for(Contact c : [SELECT Id, Push_Date__c, Account.PushToVendor__C FROM Contact WHERE Account.Id IN :accIds]){
            if(c.Account.PushToVendor__c == 'Yes') {c.Push_Date__c = System.now();}
            if(c.Account.PushToVendor__c == 'No') {c.Push_Date__c = null;}

            conList.add(c);
        }

        //Update Async
        Database.update(conList,false);
        return;
    }
}
