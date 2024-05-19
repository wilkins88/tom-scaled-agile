/**
 * Would genenerally run this through a robust trigger dispatcher (or better yet, a full automation framework that combines
 * both triggers and flows in a comprehensive, fully manageable automation solution)
 * 
 * but for the purposes of simplicity, will implement the bare minimum
 */
trigger MeetupRegistrationTrigger on MeetupRegistration__c (before insert) {
    // dispatcher mentioned above would handle instantiation,
    // and here would usually be some sort of factory to create the dispatcher
    // in the absence of that for this interview problem, will just keep the dispatching logic
    // in the trigger with the business logic in the handler
    if (Trigger.isBefore && Trigger.isInsert) {
        new MeetupRegistrationTriggerHandler().doBeforeInsert(Trigger.new);
    }
}