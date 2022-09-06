@IsTest
public class TestSetupHelper {
  
    /**
     * generateAccountList Description
     *
     * @param count (Integer): Number of records to create
     * @param doInsert (Boolean): Do de DML Inserition
     *
     * @return List<Account>: List of the accounts created
     */
    public static List<Account> generateAccountList(final Integer count, final Boolean doInsert){

        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < count; i++){
            accountList.add(new Account(Name = 'Test Account' + i, Phone = '809-220-1234'));
        }

        if (doInsert){
            insert accountList;
        }

        return accountList;
    }

    /**
     * createContactList Description
     *
     * @param recordCount (Integer): Number of records to create
     * @param accountId (Id): Account relation
     * @param doInsert (Boolean): Write the parameter description
     *
     * @return List<Contact>: List of the accounts created
     */
    public static List<Contact> generateContactList(final Integer recordCount, final Id accountId, final Boolean doInsert){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List<Contact> contactList = new List<Contact>();
        if (recordCount < 200){
            for (Integer i = 0; i < recordCount; i++){
                contactList.add(new Contact(FirstName = 'Hello' + i, LastName = 'World' + i, Email = 'frangel@ksquare.com', AccountId = accountId));
            }

            if (doInsert){
                insert contactList;
            }
        } else{            
            for (Integer i = 0; i < recordCount; i = i+ 200){
                List<Contact> tempContactList = new List<Contact>();//clear flag each iteration
                for (Integer j = 0; j < 200; j++){
                    tempContactList.add(new Contact(FirstName = i+'Hello' + j, LastName = i+'World' + j, Email = 'frangel@ksquare.com', AccountId = accountId));
                }
                Database.insert(tempContactList,dml);
                contactList.addAll(tempContactList);
            }
        }
        return contactList;
    }

}
