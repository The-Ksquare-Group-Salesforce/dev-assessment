public class ProcessSynchronousStrategy implements ProcessingStrategy{
    static final String YES_CONSTANT = 'Yes';
    static final String NO_CONSTANT = 'No';
    
    Private Map<Id,String> contactsToProcess;
    
    public ProcessSynchronousStrategy (Map<Id,String> contactsToProcess){
        this.contactsToProcess = contactsToProcess;
    }
    
    public void process(){
        List<Contact> contactsToUpdate = new List<Contact>();
        
        if(contactsToProcess.keySet().size() > 0){
            for(Id contactId: contactsToProcess.keySet() ){
                // if yes
                if(contactsToProcess.get(contactId) == YES_CONSTANT){
                      contactsToUpdate.add(new Contact(Id = contactId, Push_Date__c = Date.today() ));
                }
                
                // if No
                if(contactsToProcess.get(contactId) == NO_CONSTANT){
                      contactsToUpdate.add(new Contact(Id = contactId, Push_Date__c = null ));
                }
            }
        }

        if (Schema.sObjectType.Contact.fields.Push_Date__c.isUpdateable()) {
            update contactsToUpdate;
        } 
    }
}