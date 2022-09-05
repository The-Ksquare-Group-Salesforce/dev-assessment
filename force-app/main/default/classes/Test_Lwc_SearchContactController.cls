@isTest 
private  class Test_Lwc_SearchContactController {
    static testMethod void testAccountContacts() {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;

        List<Contact> conList = new List<Contact>();
        for(Integer i =0; i<20; i++){
            Contact con = new Contact(FirstName = 'Test Con'+i, LastName='Tester', AccountId=acc.Id);
            conList.add(con);
        }
        insert conList;

        Test.startTest();
            List<Contact> contList = Lwc_SearchContactController.getContactData(acc.Id, '', false);

            Lwc_SearchContactController.getContactData(acc.Id, 'Test Con1', true);
        Test.stopTest();

        System.assertEquals(20, contList.size());
    }

}