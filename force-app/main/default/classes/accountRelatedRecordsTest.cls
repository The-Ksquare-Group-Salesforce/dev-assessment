@isTest
private class accountRelatedRecordsTest {
    static testMethod void accountWithRelatedRecordsTest(){
        String noContId = '';
        Account[] accts = accountTriggerDataFactory.createAccWithCont(1,3);
        Contact[] contsToTest = accountRelatedRecords.accountRelatedRecords(accts[0].Id, noContId);
        String contId = contsToTest[0].Id;
        Contact[] contToTest = accountRelatedRecords.accountRelatedRecords(accts[0].Id, contId);
        //Assert when is an account with many contacts
        system.assertEquals(3, contsToTest.size());
        //Assert when contact is selected within account
        system.assertEquals('Contact0', contToTest[0].Name);
    }
    
    static testMethod void searchContactsTest(){
        String contName = 'Cont';
        String contFullName = 'Contact2';
        Account[] accts = accountTriggerDataFactory.createAccWithCont(1,3);
        Contact[] contsToTest = accountRelatedRecords.searchContacts(contName, accts[0].Id);
        Contact[] contToTest = accountRelatedRecords.searchContacts(contFullName, accts[0].Id);
        //Assert for contacts searched
        system.assertEquals(3, contsToTest.size());
        //Assert for contact searched
        system.assertEquals(1, contToTest.size());
    }
    
    static testMethod void getPhotoId(){
        Account[] accts = accountTriggerDataFactory.createAccWithCont(1,3);
        
        Test.startTest();
        Contact contWithDoc = [SELECT Id, Name, AccountId FROM Contact WHERE Name = 'Contact1' AND AccountId =: accts[0].Id];
        Contact contWithoutDoc = [SELECT Id, Name, AccountId FROM Contact WHERE Name = 'Contact2' AND AccountId =: accts[0].Id];
        
        ContentVersion content = new ContentVersion(); 
        content.Title='profilePicture'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = contWithDoc.id;
        contentlink.contentdocumentid = [select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        insert contentlink;
        Test.stopTest();
        
        List<String> contPhotoURL = accountRelatedRecords.getPhotoId(contWithDoc.Id);
        List<String> contWithNoPhotoURL = accountRelatedRecords.getPhotoId(contWithoutDoc.Id);
    }

}