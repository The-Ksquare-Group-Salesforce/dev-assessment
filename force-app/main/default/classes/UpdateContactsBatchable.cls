public class UpdateContactsBatchable implements Database.Batchable<SObject>{
	public List<Contact> contactList;

    public UpdateContactsBatchable(List<Contact> contactList){
        this.contactList = contactList;
    }
    
    public List<Contact> start(Database.BatchableContext ctx) {
        return contactList;
    }
    
    public void execute(Database.BatchableContext ctx, List<Contact> contactList) {
        update AccountTriggerHandler.updateContactList(contactList);                
    }
    
    public void finish(Database.BatchableContext ctx) {    
        
	}
}