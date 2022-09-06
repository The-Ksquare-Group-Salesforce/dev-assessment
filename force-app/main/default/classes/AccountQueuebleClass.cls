public class AccountQueuebleClass implements Queueable {
    
    private List<Contact> myList;
    public AccountQueuebleClass(List<Contact> lstParam) {
        myList = lstParam;
    }
    public void execute(QueueableContext context) {
        for(Contact con: myList){
            if(con.Account.PushToVendor__c == 'Yes'){
                con.Push_Date__c = Date.today();
            }
            else if(con.Account.PushToVendor__c == 'No'){
                con.Push_Date__c = null;
            }
        }
        update myList;       
    }
}