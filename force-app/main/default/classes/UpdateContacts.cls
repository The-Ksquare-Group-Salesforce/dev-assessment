public without sharing class UpdateContacts {


    public static void updateCons(List<Account> accounts){
        List<Contact> contactsUpdated = new List<Contact>();
        for (Account acc : accounts) {
            if (acc.PushToVendor__c == 'Yes') {
                for(Contact con :acc.Contacts){
                    con.Push_Date__c = Datetime.now();
                    contactsUpdated.add(con);
                }
            } else if (acc.PushToVendor__c == 'No'){
                for(Contact con :acc.Contacts){
                    con.Push_Date__c = null;
                    contactsUpdated.add(con);
                } 
            }
            
        }

        update contactsUpdated;
    }
}