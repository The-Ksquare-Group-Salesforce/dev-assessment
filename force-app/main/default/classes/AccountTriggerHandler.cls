public with sharing class AccountTriggerHandler {

    public static void beforeUpdateAccountHandler(List<Account> accountList) {

        //0014x00001L0qKGAAZ, 0014x00001L0qKLAAZ
        //Map<Id,Integer> contactsCounter = new Map<Id,Integer>();
        Set<Id> accIds = new Set<Id>();
        Integer contactsToProcess = 0;

        for(Account acc: accountList)
        {
                accIds.add(acc.Id);
        }

        for(AggregateResult ar: [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount FROM Contact WHERE AccountId IN: accIds GROUP BY AccountId])
        {
            contactsToProcess += (Integer)ar.get('ContactsPerAccount');
        }

        System.debug('Total de contactos: '+ contactsToProcess);
    }
}