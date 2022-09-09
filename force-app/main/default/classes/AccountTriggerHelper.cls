public class AccountTriggerHelper {
    
    private static List<Contact> contactList;
    private static Set<Id> contactIds;
    
    public static void updateRelatedContacts(Set<Id> accIds, DateTime pushDate) {
        contactList = [SELECT Id FROM Contact WHERE AccountId IN: accIds];
        contactIds = (new Map<Id, sObject>(contactList)).keySet();
        Integer contactCount = contactList.size();
        
        if (contactCount > 1000) {
            // Total contact count greater than 1000
            // Update contacts in chunks of 150 records
            Database.executeBatch(new UpdateContacts_Batch(contactIds, pushDate), 150);
            
        } else if (contactCount > 200 && contactCount <= 1000) {
            // Total contact count greater than 200 and less than or equal to 1000
            // Use a one-time process to update the records
            Database.executeBatch(new UpdateContacts_Batch(contactIds, pushDate), 1000);
            
        } else {
            // Total contact count less than or equal to 200
            // Update conctacts synchronously
            for(Contact contact : contactList) {        
                contact.Push_Date__c = pushDate;	// Update Push_Date__c field
            }
            Database.SaveResult[] srList = Database.update(contactList, false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed                
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
   
}