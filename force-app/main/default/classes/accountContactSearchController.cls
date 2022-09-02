public class accountContactSearchController {
    
	@AuraEnabled(cacheable=true)    
    public static List<Contact> getAccountContacts(string contactName){
    
        String likeStatement = '%' + contactName + '%';
        List<Contact> contactList = [Select Id, FirstName, LastName, Email, Phone, Account.Name From Contact Where FirstName like :likeStatement OR LastName like :likeStatement];
        return contactList;
    }
    
    @AuraEnabled(cacheable=true)    
    public static Contact getContactInfo(string contactId){
    
        Contact contactInfo = [Select Id, FirstName, LastName, Email, Phone, Title From Contact Where Id = :contactId];
        return contactInfo;
    }   
}