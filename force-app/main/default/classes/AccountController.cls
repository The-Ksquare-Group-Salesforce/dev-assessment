public with sharing class AccountController {
    @AuraEnabled(Cacheable=true)
    public static Contact[] getRelatedContacts(String Id, Integer limitSize, Integer offset) {
        return [
            SELECT
                Id,
                Name,
                Email,
                Phone,
                Title
                FROM Contact
                WHERE AccountId = :Id
                LIMIT :limitSize
                OFFSET :offset 
        ];
    }
    
}