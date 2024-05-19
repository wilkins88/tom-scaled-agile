/**
 * Generally try to avoid generic, all encompassing trigger handlers
 * even if those handlers call service methods from other classes
 * Rather I prefer to inject the business logic to be executed at runtime
 * using a bit of DI/IoC with custom metadata pointing to handlers that execute
 * a single bit of business logic. That generally makes things more testable, manageable,
 * and gives us a nice way to easily feature flag automation settings
 * 
 * For the purposes of this interview question, just having a simple handler to show
 * decomp and the importance of moving logic out of the trigger itself
 */
public inherited sharing class MeetupTriggerHandler {
    public void doBeforeInsert(List<Meetup__c> triggerNewList) {
        for (Meetup__c meetup : triggerNewList) {
            if (String.isBlank(meetup.RegistrationCode__c)) {
                meetup.RegistrationCode__c = Services.strings.getRandomAlphaNumericString(8);
            }
        }
    }
}