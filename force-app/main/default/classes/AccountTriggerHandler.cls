public with sharing class AccountTriggerHandler {

    static Set<Id> accIdsUpdated = new Set<Id>();

    public static void onAfterUpdate(List<Account> accList, Map<Id, Account> oldAccMap) {
        //Check if "PushToVendor__c" field updated on Account
        for(Account acc: accList){
            Account oldAcc = oldAccMap.get(acc.Id);
            if((acc.PushToVendor__c == 'Yes' || acc.PushToVendor__c == 'No') 
                && (acc.PushToVendor__c != oldAcc.PushToVendor__c))
            {
                accIdsUpdated.add(acc.Id);
            }
        }
        System.debug('accIdsUpdated----'+accIdsUpdated);
    }

    public static void checkContactCount(){
        //Check Total Contact count and call sync. or async. apex accordingly
        if(!accIdsUpdated.isEmpty() && Schema.sObjectType.Contact.fields.Id.isAccessible()){
        
            AggregateResult[] agr = [SELECT COUNT(Id)totalCon FROM Contact WHERE AccountId IN: accIdsUpdated];
            Integer totalConCount = (Integer)agr[0].get('totalCon');
            if(totalConCount <= 200){
                System.debug('200----');
                syncConUpdate();
            }
            else if(totalConCount > 200 && totalConCount <= 1000){
                asyncConUpdate(1000);
            }
            else{
                asyncConUpdate(150);
            }
        }
    }

    //Update Contacts synchronously
    public static void syncConUpdate(){
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Contact con: [SELECT Id, Push_Date__c, Account.PushToVendor__c FROm Contact WHERE AccountId IN: accIdsUpdated WITH SECURITY_ENFORCED]){
            con.Push_Date__c = con.Account.PushToVendor__c == 'Yes' ? System.today() : null;
            contactsToUpdate.add(con);
        }
        System.debug('contactsToUpdate----'+contactsToUpdate);
        if(!contactsToUpdate.isEmpty() && Schema.sObjectType.Contact.isUpdateable()){
            update contactsToUpdate;
        }
    }

    //Update Contacts asynchronously
    public static void asyncConUpdate(Integer scope){
        BatchContactUpdate batchCon = new BatchContactUpdate(accIdsUpdated);
        Database.executeBatch(batchCon, scope);
    }
}