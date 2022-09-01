trigger AccountTrigger on Account (after update) {

    Integer contactTotal = 0;

    Set<Id> accIds = new Set<Id>();

    for(Account a : accList) {accIds.add(a.Id);}
    
    for(AggregateResult AggRe:
    [SELECT AccountId AccId, COUNT(Id) ContactsPerAccount
    FROM Contact
    WHERE Account.Id
    IN: accIds 
    GROUP BY AccountId]) {
        contactTotal +=(Integer)ar.get('ContactsPerAccount');
    }

    System.debug('Contact Total' + contactTotal);
}