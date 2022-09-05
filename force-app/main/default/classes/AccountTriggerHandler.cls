public class AccountTriggerHandler extends TriggerHandler {
    
    private List<Account> newAccList;
    private Set<Id> pTVYesAccIds;	// Accounts with PushToVendor__c = Yes
    private Set<Id> pTVNoAccIds;	// Accounts with PushToVendor__c = No
    private DateTime pushDate;

    public AccountTriggerHandler() {
        this.newAccList = (List<Account>) Trigger.new;
        this.pTVYesAccIds = new Set<Id>();
        this.pTVNoAccIds = new Set<Id>();
        this.pushDate = datetime.now();
    }

    public override void afterUpdate() {
        for (Account acc : newAccList) {
            if (acc.PushToVendor__c == 'Yes') {
                pTVYesAccIds.add(acc.Id);
            } else if (acc.PushToVendor__c == 'No') {
                pTVNoAccIds.add(acc.Id);
            }
        }
        
        if (pTVYesAccIds.size() > 0) {
            AccountTriggerHelper.updateRelatedContacts(pTVYesAccIds, pushDate); 
        }
        
        if (pTVNoAccIds.size() > 0) {
            AccountTriggerHelper.updateRelatedContacts(pTVNoAccIds, null);
        }
    }
}