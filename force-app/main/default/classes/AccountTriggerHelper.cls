public class AccountTriggerHelper {
        
    public void validateContactsPerAccount(Map<Id, Account> accountMap, DateTime pushedDate){
        
        AggregateResult[] contactsByAccountResult = [SELECT AccountId, COUNT(Id) contactsCount FROM Contact WHERE AccountId IN :accountMap.keySet() GROUP BY AccountId];

        if (contactsByAccountResult.size() > 0) {
            
            List<String> lowerLimitList = new List<String>();
            List<String> middleLimitList = new List<String>();
            List<String> upperLimitList = new List<String>();
            
            for(AggregateResult contactsByAccount : contactsByAccountResult){
                
                integer contactsCount = Integer.valueOf(contactsByAccount.get('contactsCount'));
                String accountId = String.valueOf(contactsByAccount.get('AccountId'));
                
                if (contactsCount <= AccountConstants.TWO_HUNDRED) {
                    //Update contacts synchronously.
                    lowerLimitList.add(accountId);
                } else if (contactsCount > AccountConstants.TWO_HUNDRED && contactsCount <= AccountConstants.ONE_THOUSAND) {
                    //Use a one-time process to update the records.
                    middleLimitList.add(accountId);
                } else {
                    //The records must be updated in smaller chunks of ideally 150 records per chunk 
                    upperLimitList.add(accountId);                       
                }
            }
            
            if (lowerLimitList.size() > 0) {
                updateContactsSynchronously(lowerLimitList, pushedDate);
            }
            
            if (middleLimitList.size() > 0) {
                updateContactsAsynchronously(middleLimitList, pushedDate, AccountConstants.ONE_HUNDRED_FIFTY);
            }
            
            if (upperLimitList.size() > 0) {
                updateContactsAsynchronously(upperLimitList, pushedDate, AccountConstants.ONE_THOUSAND);
            }
            
        }       
    }
    
    public void updateContactsSynchronously(List<String> AccountIdList, DateTime pushedDate){
        
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact contact : [SELECT Id, Push_Date__c FROM Contact
                               	WHERE AccountId IN :AccountIdList]) {
                                    
                                    contactsToUpdate.add(
                                        new Contact(
                                            Id = contact.id,
                                            Push_Date__c = pushedDate
                                        )
                                    );
        }
        
        update contactsToUpdate;
    }
    
    public void updateContactsAsynchronously(List<String> AccountIdList, DateTime pushedDate, Integer batchSize){
        updateContactsBatchable updateContactsBatch = new updateContactsBatchable(AccountIdList, pushedDate);
        Database.executeBatch(updateContactsBatch, batchSize);
    }
}