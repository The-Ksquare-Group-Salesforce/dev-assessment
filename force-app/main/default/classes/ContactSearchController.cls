public without sharing class ContactSearchController {

    @AuraEnabled(cacheable=true)
    public static List<WrapperContact> search(String searchTerm, String recordId,Integer limitSize, Integer offset) {
        System.debug(recordId);
        List<WrapperContact> wrapperContacts = new List<WrapperContact>();
        String searchName = '%' + searchTerm + '%';

        List<AccountContactRelation> lookUpList = [SELECT ContactId, Contact.Name, Contact.Email, Contact.Phone, Contact.PhotoUrl FROM AccountContactRelation WHERE AccountId =: recordId AND Contact.Name LIKE:searchName ORDER BY Contact.Name LIMIT:limitSize OFFSET : offset];
        for (AccountContactRelation acr : lookUpList) {
            WrapperContact wc = new WrapperContact(); 
            wc.Id = acr.ContactId;
            wc.Name = acr.Contact.Name;
            wc.Phone = acr.Contact.Phone;
            wc.Email = acr.Contact.Email;
            wc.Url = acr.Contact.PhotoUrl;
            wrapperContacts.add(wc);
        }
        
        System.debug(lookUpList);
        return wrapperContacts;
    }

    @AuraEnabled(cacheable=true)
    public static WrapperContact searchSingleContact(String searchTerm, String recordId) {
        String searchName = '%' + searchTerm + '%';

        List<AccountContactRelation> contactRecord = new List<AccountContactRelation>([SELECT ContactId, Contact.Name, Contact.Email, Contact.Phone, Contact.PhotoUrl FROM AccountContactRelation WHERE AccountId =: recordId AND Contact.Name LIKE:searchName LIMIT 1]);
        
        if (!contactRecord.isEmpty()) {
            WrapperContact wc = new WrapperContact(); 
            for (AccountContactRelation con : contactRecord) {
                wc.Id = con.ContactId;
                wc.Name = con.Contact.Name;
                wc.Phone = con.Contact.Phone;
                wc.Email = con.Contact.Email;
                wc.Url = con.Contact.PhotoUrl; 
            }
            return wc;
        } else {
            return null;
        }
            
        
    }

    public class WrapperContact{
        @AuraEnabled
        public String Id {get; set;}
        @AuraEnabled
        public String Name{get; set;}
        @AuraEnabled
        public String Email{get; set;}
        @AuraEnabled
        public String Phone{get; set;}
        @AuraEnabled
        public String Url{get; set;}

    }

}