public class AccountQueuebleClass implements Queueable {
    
    private List<SObject> myList;
    public AccountQueuebleClass(List<SObject> lstParam) {
        myList = lstParam;
    }
    public void execute(QueueableContext context) {
        update myList;       
    }
}