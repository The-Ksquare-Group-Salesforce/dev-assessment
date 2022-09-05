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
            try {
                update contactList;
            } catch(Exception e) {
                System.debug(e);
            }
        }
    }
   
}