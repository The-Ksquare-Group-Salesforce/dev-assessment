public class AccountTriggerHandler extends TriggerHandler  {

    public AccountTriggerHandler() {
        this.setMaxLoopCount(5);
    }

    public override void afterUpdate() {
        AccountTriggerHandler.updatePushDate();
    }

    public static void updatePushDate(){
        System.debug('updatePushDate');
        List<Account> updatedAccounts =  [SELECT Id,PushToVendor__c FROM Account WHERE Id IN :Trigger.New];
        List<Contact> relatedContacts =  [SELECT Id,AccountId,Push_Date__c FROM Contact WHERE AccountId IN :Trigger.New];

            if (relatedContacts.size() <= 200)
            {
                 System.debug('<200');
                 updateContatSync(relatedContacts, updatedAccounts);
                
            }else if ((relatedContacts.size()>200) && (relatedContacts.size()<=1000))
            {
                System.debug('<1000');
                List<id> updatedAccountsId = getAccoundIds(updatedAccounts);
                updateContatAsync(updatedAccountsId);
            }else {
                //100 batches or 150
                System.debug('batche');
                //List<id> updatedAccountsId = getAccoundIds(updatedAccounts);
                //processBatchInsert(updatedAccountsId);
                processBatchInsert(updatedAccounts);
            }
    }

    public static List<Id> getAccoundIds (List<Account> updatedAccounts){
        List<Id> updatedAccountsId = new List<id>();
                for(Account c: updatedAccounts){
                    updatedAccountsId.add(c.Id);
                }
        return updatedAccountsId;
    }
    
    public static List<Contact> updateContactRecords (List<contact> relatedContacts, list<account> updatedAccounts){
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Account a:updatedAccounts){
            for(Contact b: relatedContacts){
                if((b.AccountId == a.Id)&(a.PushToVendor__c == 'Yes')){
                    b.Push_Date__c = date.today();
                    contactsToUpdate.add(b);        
                }
                else if((b.AccountId == a.Id)&(a.PushToVendor__c == 'No')&&(b.Push_Date__c != null)){
                   b.Push_Date__c = null;
                   contactsToUpdate.add(b);         
               }
            }
        }
        return contactsToUpdate;
    }

    public static void updateContatSync(List<Contact> relatedContacts, List<Account> updatedAccounts){
        System.debug('updateContatSync');
        List<Contact> recordsToUpdate = updateContactRecords(relatedContacts, updatedAccounts);
        update recordsToUpdate;
    }

   @future
    public static void updateContatAsync(list<Id> updatedAccountsId) {
        System.debug('updateContatAsync');
        List<Account> upAccounts =  [SELECT Id,PushToVendor__c FROM Account WHERE Id IN :updatedAccountsId];
        List<Contact> relContacts =  [SELECT Id,AccountId,Push_Date__c FROM Contact WHERE AccountId IN :updatedAccountsId];
        AccountTriggerHandler.updateContatSync(relContacts, upAccounts);
    }

    public static void processBatchInsert (List<Account> updatedAccount){
    //public static void processBatchInsert (List<Id> updatedAccountsId){
        System.debug('1');
        AccountBatchUpdate myBatchObject = new AccountBatchUpdate(updatedAccount);
        Id batchId = Database.executeBatch(myBatchObject, 150);
    }
      
}