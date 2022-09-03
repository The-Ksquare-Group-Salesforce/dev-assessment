public with sharing class UpdateContactsWithQueueableApex implements Queueable{
    
    Set<Id> accsToUpdatedWithYesAsync;
    Set<Id> accsToUpdatedWithNoAsync;
    List<Contact> contactsToUpdateAsync =  new List<Contact>();

    public UpdateContactsWithQueueableApex(Set<Id> accsToUpdatedWithYesAsync, Set<Id> accsToUpdatedWithNoAsync) {

        this.accsToUpdatedWithYesAsync = accsToUpdatedWithYesAsync;
        this.accsToUpdatedWithNoAsync = accsToUpdatedWithNoAsync;

    }

    public void execute(QueueableContext qc){

        if (!accsToUpdatedWithYesAsync.isEmpty()) {
            for (Contact cont: [SELECT Name, Id, AccountId, Push_Date__c FROM Contact WHERE AccountId IN:accsToUpdatedWithYesAsync]) {
                cont.Push_Date__c = System.now();
                contactsToUpdateAsync.add(cont);
            }
        }
        if (!accsToUpdatedWithNoAsync.isEmpty()) {
            for (Contact cont: [SELECT Name, Id, AccountId, Push_Date__c FROM Contact WHERE AccountId IN:accsToUpdatedWithNoAsync]) {
                cont.Push_Date__c = Null;
                contactsToUpdateAsync.add(cont);
            }
        }
        Update contactsToUpdateAsync;

    }

}
