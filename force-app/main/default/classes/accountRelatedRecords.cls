public without sharing class accountRelatedRecords {
    @AuraEnabled(cacheable=true)
    public static List<Contact> accountRelatedRecords(String acctId, String contId) {
        String accId = string.escapeSingleQuotes(acctId);
        String conId = string.escapeSingleQuotes(contId);
        String query;
        
        if (contId != '') {
            query = 'SELECT Id, Name, Email, Phone, Title'
    			+' FROM Contact'
    			+' WHERE AccountId =\'' +accId+'\''
                +' AND Id =\'' +conId+'\'';
        }
        else {
            query = 'SELECT Id, Name, Email, Phone, Title'
    			+' FROM Contact'
    			+' WHERE AccountId =\'' +accId+'\''
                +' ORDER BY Name';
        }
        return Database.query( query );
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String contName, String actId){
        String sName = contName+'%';
        String cName = string.escapeSingleQuotes(sName);
        String accId = string.escapeSingleQuotes(actId);
        String query;

        if(contName != ''){
            query = 'SELECT Id, Name'
    			+' FROM Contact'
    			+' WHERE Name LIKE :cName AND AccountId =\'' +accId+'\''
                +' ORDER BY Name LIMIT 3';
        }
        return Database.query( query );
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getPhotoId(String contId){
        List<String> contData = new List<String>();
        String photoURL = '';
        String contURL = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];
        contURL = contURL.removeEnd('--c');
        contURL = 'https://'+contURL.toLowerCase()+'.lightning.force.com'+'/lightning/r/Contact/'+contId+'/view';
        
        contData.add(contURL);
        ContentDocumentLink[] cdl = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title
                               FROM ContentDocumentLink WHERE LinkedEntityId =: contId AND ContentDocument.Title = 'profilePicture'];
        if(cdl.size() > 0){
            photoURL = '/sfc/servlet.shepherd/document/download/'+cdl[0].ContentDocumentId;
        }
        else{
            photoURL = 'empty';
        }
        contData.add(photoURL);                             
        return contData;
    }
}