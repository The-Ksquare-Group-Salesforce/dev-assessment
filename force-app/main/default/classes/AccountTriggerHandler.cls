public with sharing class AccountTriggerHandler {
    
    private static final Integer CERO = 0;
    private static final Integer TWOHUNDRED = 200;
    private static final Integer ONETHOUSAND = 1000;
    private static final Integer ONEHUNDREDANDFIFTY = 150;
    private static final String PUSH_TO_VENDOR_NO = 'No';
    private static final String PUSH_TO_VENDOR_YES = 'Yes';

    public static void handleAfterUpdate(List<Account> accountList){
        // Maps to capture accounts with push to vendor condition and avoid update operation inside for
        Datetime myDateTime = null;
        Map<Id, Account> positiveAccountsUpdate = new Map<Id, Account>();
        Map<Id, Account> negativeAccountsUpdate = new Map<Id, Account>();
        for(Account acc : accountList){
            if(acc.PushToVendor__c == PUSH_TO_VENDOR_YES){
                positiveAccountsUpdate.put(acc.Id, acc);
            } else if(acc.PushToVendor__c == PUSH_TO_VENDOR_NO){
                negativeAccountsUpdate.put(acc.Id, acc);
            }
        }

        if(positiveAccountsUpdate.size() > CERO){
            myDateTime = DateTime.now();
            processContactsRelatedToAcc(positiveAccountsUpdate.keySet(), positiveAccountsUpdate.values(), myDateTime);
        } 
        
        if(negativeAccountsUpdate.size() > CERO){
            processContactsRelatedToAcc(negativeAccountsUpdate.keySet(), negativeAccountsUpdate.values(), myDateTime);
        } 
    }

    public static void processContactsRelatedToAcc(Set<Id> accountIds, List<Account> accountList, Datetime myDateTime){
        //CheckContactsInAccount
        List<Contact> contList = new List<Contact>([SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId IN : accountList]);
        
        // Contact list <= 200 - Synchronous update
        if(contList.size() > CERO && contList.size() <= TWOHUNDRED){
            List<Contact> contListToUpdate = new List<Contact>();
            for(Contact con : contList){
                con.Push_Date__c = myDateTime;
                contListToUpdate.add(con);
            }
            update contListToUpdate;
        } 

        // 200 < Contact list <= 1000 - Async update single operation
        else if(contList.size() > TWOHUNDRED && contList.size() <= ONETHOUSAND){
            ContactsBatch asyncContBatch = new ContactsBatch(accountIds, myDateTime);
            Database.executeBatch(asyncContBatch, ONETHOUSAND);
        }

        // Contact list > 1000 - Async update with batches
        else if(contList.size() > ONETHOUSAND){
            ContactsBatch asyncContBatch = new ContactsBatch(accountIds, myDateTime);
            Database.executeBatch(asyncContBatch, ONEHUNDREDANDFIFTY);
        }
    }
}