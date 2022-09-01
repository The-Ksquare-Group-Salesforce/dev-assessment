trigger AccountTrigger on Account (before update) {

//Logic of beforeUpdate Trigger:

   //Checking if is a before Trigger and calling
   //"beforeUpdateAcccountHandler" static method
   //from "AccountTriggerHandler" class.
   if (Trigger.isBefore) { 
      AccountTriggerHandler.beforeUpdateAccountHandler(Trigger.new);
   }
   
//Logic of beforeUpdate Trigger---------------------------------
}