@isTest
public class contactSearchControllerTest {

    @TestSetup
    public static void data(){
        
        Account account = new Account(
        	Name = 'New Account'
        );
        
        insert account;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer x = 0;x<2000; x++){
              Contact contact = new Contact(
                  	accountId = account.Id,
        			lastName = 'Rodriguez' + x
        		);
             
              contactList.add(contact);
        }    
        insert contactList;
    }
    
    @isTest
    public static void getAllContactsTest(){
        
        Test.startTest();
        	List<Contact> contactList = contactSearchController.getAllContacts(10);
        Test.stopTest();
        
        System.assertEquals(10, contactList.size());  
    }

	@isTest
    public static void getSearchContactsTest(){
        
        List<Contact> contactList = [SELECT Id, Name, Title, Phone, Email FROM Contact];
        
        Test.startTest();
        	List<Contact> contactListTest = contactSearchController.getSearchContacts('Rodriguez');
        Test.stopTest();
        
        System.assertEquals(20, contactListTest.size());
    }    
    
    
}