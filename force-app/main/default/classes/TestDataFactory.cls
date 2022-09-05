@IsTest
public class TestDataFactory {
    public static List<Account> getAccounts(Integer size){
        List<Account> toReturn = new List<Account>();
        for(Integer i = 1; i<= size; i++){
            toReturn.add(new Account(
                Name = 'Dummy '+String.valueOf(i),
                CurrencyIsoCode = Constants.CURRENCY_USD
            ));
        }
        return toReturn;
    }
    public static List<Contact> getContacts(List<Account> accounts,Integer size){
        List<Contact> toReturn = new List<Contact>();
        for(Account ac : accounts){
            for(Integer i = 1; i<= size; i++){
                toReturn.add(new Contact(
                    AccountId = ac.Id,
                    FirstName = 'Dummy '+String.valueOf(i),
                    LastName = 'Dum '+ String.valueOf(i),
                    CurrencyIsoCode = 'USD'
                ));
            }
        }
        return toReturn;
    }
    public static void insertData(Integer size){
        List<Account> accounts = getAccounts(size);
        insert accounts;
        insert getContacts(accounts,size);
    }
}