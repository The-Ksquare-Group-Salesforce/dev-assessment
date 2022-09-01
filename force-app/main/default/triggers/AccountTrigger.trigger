trigger AccountTrigger on Account (after update) {
    if(trigger.IsUpdate) {System.Debug('Hello World');}
}