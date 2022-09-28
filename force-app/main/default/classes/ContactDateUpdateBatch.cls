public class ContactDateUpdateBatch implements Database.Batchable<sObject>{

   public final String Query;
   public final String Entity;
   public final String Field;
   public final Date Value;
   public final Map<Id, String> contactsToUpdateDateMap;
   public final Set<Id> contactIds;
   // TODO : Create a type with yes and no and utilize it across implementations
   static final String YES_CONSTANT = 'Yes';
   static final String NO_CONSTANT = 'No';
    

   public ContactDateUpdateBatch(String q, String e, String f, Date v, Map<Id, String> contactsYesAndNoMap){

      Query=q; 
      Entity=e;
      Field=f;
      Value=v;
      contactsToUpdateDateMap = contactsYesAndNoMap;
      contactIds = contactsYesAndNoMap.keySet();
      
   }

   public Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator(Query);
   }

   public void execute(Database.BatchableContext bc, List<sObject> scope){
     List<Contact> contactsToUpdate = new List<Contact>();
     for(sobject s : scope){
         Contact ctt = (Contact)s;
         
         System.debug(ctt);
         System.debug(contactsToUpdateDateMap);
         
         if(contactsToUpdateDateMap.get(ctt.id) == YES_CONSTANT){
             ctt.put(Field,Value); 
         }
         
         if(contactsToUpdateDateMap.get(ctt.id) == NO_CONSTANT){
             if(ctt.Push_Date__c == null){
                 continue;
             }
             ctt.put(Field, null); 
         }
         
         contactsToUpdate.add(ctt);
         
     }

    if (Schema.sObjectType.Contact.fields.Push_Date__c.isUpdateable()) {
        try{
            update contactsToUpdate;
        }catch(DmlException e){
           System.debug(e.getMessage());
           System.debug('Error ocurred during processing of contacts: ' +e.getMessage());
        }
    } 
}

   public void finish(Database.BatchableContext bc){
       System.debug('Contact update batch finished');
   }
}