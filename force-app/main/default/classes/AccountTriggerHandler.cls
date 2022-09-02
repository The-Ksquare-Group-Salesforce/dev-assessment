public with sharing class AccountTriggerHandler {

    public static void beforeUpdateAccountHandler(List<Account> accountList) {

    //Id's Accounts in org to debug, 0014x00001L0qKGAAZ, 0014x00001L0qKLAAZ
    
    //Declaring variables:

        //Set to save Account Ids in the Trigger.new List
        Set<Id> accIds = new Set<Id>();
        Set<Id> accsToUpdatedWithYes = new Set<Id>();
        Set<Id> accsToUpdatedWithNo = new Set<Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        //Integer to save the quantity of contacts to process
        Integer contactsToProcess = 0;
    //Declaring Variables--------------------------------------------------------------------


    
    //Logic to process data form Updated Accounts in Trigger.new:

        //Logic to retrieve Id's of Account Updated:
            //For loop to save the Id's in the Set "accIds" from 
            //"accountList" List (Trigger.new) that were updated for their "Push_To_Vendor" field,
            //so that we can make a query with aggregate functions
            //to obtain a table with the contacts per accounts in the next loop.
            for(Account acc: accountList)
            {
                if (acc.Push_To_Vendor__c == 'Yes') {
                    accsToUpdatedWithYes.add(acc.Id);
                    accIds.add(acc.Id);
                }
                if (acc.Push_To_Vendor__c == 'No') {
                    accsToUpdatedWithNo.add(acc.Id);
                    accIds.add(acc.Id);
                }
            }

        //Logic to retrieve Id's of Account Updated----------------------------   

        //Logic to verify if there are Accounts With "Push_To_Vendor" fiel Updated:
            
            //Verify is "accIds" Set is not Empty. If condition is true,
            //Code can continue to proccess data, If not the code will not run
            //Because there are nothing to update
            if (!accIds.isEmpty()) {
                
                //Logic to calculate the quantity of contacts to process:
                        //For loop to count the quantity of contacts to process by increasing the value
                        //of "contactToProcess" integer variable, using the table returned by the following 
                        //SOQL query(in the for loop) with the SOQL aggregate function "Count", that contains
                        //a table with Contacts per Account based on Ids in "accIds" Set. 
                        for(AggregateResult ar: [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount FROM Contact WHERE AccountId IN: accIds GROUP BY AccountId])
                        {
                            contactsToProcess += (Integer)ar.get('ContactsPerAccount');
                        }
                
                            //System.debug function to debug in the Org developer console:
                            //System.debug('Total de contactos: '+ contactsToProcess);

                //Logic to calculate the quantity of contacts to process----------------------------------


                //Logic to process contact records:

                        //If-Else conditional to decide how to process data.

                        //If there are at less than 200 contact records to update (Synchronously).
                        if (contactsToProcess <= 200) {
                            if (!accsToUpdatedWithYes.isEmpty()) {
                                for (Contact cont: [SELECT Name, Id, AccountId, Push_Date__c FROM Contact WHERE AccountId IN:accsToUpdatedWithYes]) {
                                    cont.Push_Date__c = System.now();
                                    contactsToUpdate.add(cont);
                                }
                            }
                            if (!accsToUpdatedWithNo.isEmpty()) {
                                for (Contact cont: [SELECT Name, Id, AccountId, Push_Date__c FROM Contact WHERE AccountId IN:accsToUpdatedWithNo]) {
                                    cont.Push_Date__c = Null;
                                    contactsToUpdate.add(cont);
                                }
                            }
                            Update contactsToUpdate;
                        }
                        //If there are more than 200 and less than 1000 contact records to update.
                        else if (contactsToProcess > 200 && contactsToProcess <= 1000) {
                        


                        }
                        //If there are more than 1000 contact records to update.
                        else if (contactsToProcess > 1000) {
                        


                        }
                //Logic to process contact records--------------------------------
            }

        //Logic to verify if there are Accounts With "Push_To_Vendor" fiel Updated----------------------------

    //Logic to process data form Updated Accounts in Trigger.new--------------------------------------------
    }
}