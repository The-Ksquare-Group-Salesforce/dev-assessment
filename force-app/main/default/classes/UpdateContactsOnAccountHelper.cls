public with sharing class UpdateContactsOnAccountHelper {

    public static void PushToVendorUpdate(list<Account> myAccounts) {

        list<Contact> contactsToUpdate = [Select Id, Push_Date__c, Account.PushToVendor__c From Contact Where AccountId In :myAccounts];
        
        List<Contact> updatedContacts;

        for (Contact cont : contactsToUpdate) {

            if (cont.Account.PushToVendor__c == 'Yes') {

                cont.Push_Date__c = DateTime.Now();

                updatedContacts.add(cont);
            
            }else{

                cont.Push_Date__c = null;

                updatedContacts.add(cont);
            }
        }

        //In the case of total contact count <= 200, update contacts synchronously
        if (contactsToUpdate.size() <= 200 && contactsToUpdate.size() != 0) {

            Database.Update(updatedContacts);
            
                
        //If 1000 <= total contact count > 200, use a one-time process to update the records    
        } else if (contactsToUpdate.size() > 200 && contactsToUpdate.size() <= 1000) {
                
            ID queue = System.enqueueJob(new AccountQueableHelper(contactsToUpdate));
            
        //If total contact count > 1000, the records must be updated in smaller chunks of ideally 150 records per chunk
        } else {

            ID batch = Database.executeBatch( new AccountBatchHelper(contactsToUpdate), 150);
                
        }



    }



}
