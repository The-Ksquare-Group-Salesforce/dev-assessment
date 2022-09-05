public with sharing class AccountTriggerHandler {

    public static void afterUpdateHandler( List<Account> updatedAccounts, Map<Id,Account> newaccMap){
        
        List<AccountContactRelation> accountsContacts = [SELECT Id, ContactId, AccountId FROM AccountContactRelation WHERE AccountId IN :updatedAccounts];

        Set<Id> contactsIds = AccountTriggerHelper.getContactSet(accountsContacts);
        
        Map<Id, String> lastAccountByContactsMap = AccountTriggerHelper.getLastAccountByContactsMap(contactsIds, accountsContacts, newaccMap);

        if (contactsIds.size() <= 200 ){
            AccountTriggerHelper.updateContacts(lastAccountByContactsMap);
        }
        else if (1000 <= contactsIds.size() &&  contactsIds.size() > 200){
            AccountTriggerHelper.updateContactsAsync(lastAccountByContactsMap);
        }
        else if( contactsIds.size() >1000 ) {
            ContactUpdateBatch batch = new ContactUpdateBatch(lastAccountByContactsMap);
            database.executeBatch(batch,150);
        }

    }
}
