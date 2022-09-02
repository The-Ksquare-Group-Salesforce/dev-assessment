public class updateContactsBatchable implements Database.Batchable<sObject> {
    
    public String strQuery;
    public DateTime pushed_Date;
    public List<Contact> contactsToBeUpdated = new List<Contact>();
    public List<String> AccountIdList = new List<String>();
    
    public updateContactsBatchable(List<String> AccountId, DateTime pushedDate) {

		pushed_Date = pushedDate;
		AccountIdList = AccountId;
        strQuery = 'SELECT Id, Push_Date__c FROM Contact WHERE AccountId IN :AccountIdList';
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> contactsList) {
        
        for (Contact contact : contactsList) {
            Contact contactObject = new Contact();
            contactObject.Id = contact.Id;
            contactObject.Push_Date__c = pushed_Date;
            contactsToBeUpdated.add(contactObject);
        }
        
        Database.SaveResult[] result = Database.update(contactsToBeUpdated, false);
        
        for (Database.SaveResult r : result) {
            if (r.isSuccess()) {
                system.debug('[INFO] Successfully updated record with Id: ' + r.getId());
            } else {
                system.debug('[INFO] Record was not updated: ' + r.getId());
            }
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}