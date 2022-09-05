public with sharing class Lwc_SearchContactController {

    @AuraEnabled
    public static List<Contact> getContactData(String recordId, String search, Boolean filter) {
        String searchStr = search + '%';
        System.debug('recordId---'+recordId);
        System.debug('searchStr---'+searchStr);
        System.debug('filter---'+filter);
        try {
            String qry = 'SELECT Id, Name, Phone, Email, Picture_Path__c,  '+
                                '(SELECT Roles FROM AccountContactRelations WHERE Roles <> NULL) '+
                                'FROM Contact '+
                                'WHERE Id IN (SELECT ContactId FROM AccountContactRelation WHERE AccountId =: recordId AND IsActive = true)';
            if(filter){
                qry += ' AND Name LIKE: searchStr';
            }
            
            qry += ' WITH SECURITY_ENFORCED ORDER BY Contact.Name ASC LIMIT 50000';

            return Database.query(qry);		
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }	
    }
}