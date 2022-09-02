public with sharing class ContactQueueable implements Queueable {
    public List<Contact> contacts;
    public ContactQueueable(List<Contact> contactList) {
        this.contacts=contactList;
    }

    public void execute(QueueableContext context){
        update contacts;
    }
}