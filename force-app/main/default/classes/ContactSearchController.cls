public with sharing class ContactSearchController {
    @AuraEnabled
    public static List<Contact> getContacts(String accountId,String searchTxt,Integer skip,Integer take){
        String query = 'Select Id,Name,Email,Phone From Contact Where AccountId = :accountId';
        if(String.isNotBlank(searchTxt))
            query += ' And Name Like \'%'+searchTxt+'%\'';
        query += ' Limit :take';
        query += ' Offset :skip';
        return Database.query(query);
    }
}