public with sharing class AccountTriggerHelper{
    public AccountTriggerHelper(){
    }

    public void updateContactsFromAccount(List<Account> newRecords){
        List<Contact> newContacts = new List<Contact>();
        for (Account a : newRecords){
            List<Contact> contacts = [SELECT Id, Push_Date__c
                                      FROM Contact
                                      WHERE AccountId = :a.Id
                                      LIMIT 10000];
            //Update the contacts Push_Date__c #NESTED </3
            if (contacts.size() > 1000){
                Database.executeBatch(new UpdateContactBatch(contacts,a), 150);
            } else if(contacts.size()<=1000 && contacts.size()>200){
                UpdateContactQueue updatequeue = new UpdateContactQueue(contacts,a);
                Id queue = System.enqueueJob(updatequeue);
           
            }else{
                for (Contact c : contacts){
                    if (a.Push_To_Vendor__c == 'Yes'){
                        c.Push_Date__c = System.today();
                        newContacts.add(c);
                    } else{
                        c.Push_Date__c = Null;
                        newContacts.add(c);
                    }
                }
                update newContacts;
            }
            //if (contacts.size() <= 200){a
            // } else if (contacts.size() <= 1000 && contacts.size() > 200){

            // }
        }
        /*
         Requiriments:
         If 1000 <= total contact count > 200, use a one-timeprocess to update the records.
         If total contact count > 1000, the records must be updated in smaller chunks of ideally 150 records per chunk
         In the case of total contact count <= 200, update contacts synchronously.

         if PushToVendor__c = YES
         Contact.Push_Date__c = Today’s Date
         else
         Push_Date__c = Today’s Date  = null
         */
    }

}