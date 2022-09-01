public with sharing class AccountTriggerHandler {

    public static void beforeUpdateAccountHandler(List<Account> accountList) {

    //Id's Accounts in org to debug, 0014x00001L0qKGAAZ, 0014x00001L0qKLAAZ
    
    //Declaring variables:

        //Set to save Account Ids in the Trigger.new List
        Set<Id> accIds = new Set<Id>();
        //Integer to save the quantity of contacts to process
        Integer contactsToProcess = 0;

    //Declaring Variables--------------------------------------------------------------------


    //Logic to calculate the quantity of contacts to process:

        //For loop to save the Id's in the Set "accIds" from 
        //"accountList" List (Trigger.new), so that we can make a query with aggregate functions
        // to obtain a table with the contacts per accounts in the next loop.
        for(Account acc: accountList)
        {
                accIds.add(acc.Id);
        }

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
    }
}