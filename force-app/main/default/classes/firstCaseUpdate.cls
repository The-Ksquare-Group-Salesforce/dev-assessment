public class firstCaseUpdate implements Queueable{
    
     private List<Id> accounts;
    private String pushToDate;
    public firstCaseUpdate(List<Id> records, String what) {
        this.accounts = records;
        this.pushToDate = what;
    }
    public void execute(QueueableContext context) {
        List<Contact> conList = new List<Contact>([select id, Push_Date__c from contact where accountId in:accounts]);

        if(pushToDate=='Yes'){
            for(Contact con: conList){
                con.Push_Date__c = Date.today();
            }
        }
        
        if(pushTodate=='No'){
             for(Contact con: conList){
                con.Push_Date__c = null;
            }
        }
       
        update conList;
    }

}