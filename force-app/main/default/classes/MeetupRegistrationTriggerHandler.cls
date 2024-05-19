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
public inherited sharing class MeetupRegistrationTriggerHandler {
    @TestVisible
    private static String REGISTRATION_LIMIT_EXCEEDED = 'Registration limit exceeded';
    @TestVisible
    private static String REGISTRATION_DUPLICATE_EMAIL = 'This email has already been registered for this meetup';

    public void doBeforeInsert(List<MeetupRegistration__c> triggerNewList) {
        // if not using the above framework which would organically break this apart, then decomp where it makes
        // sense for clarity
        this.checkRegistrationLimit(triggerNewList);
        this.checkForUniqueEmail(triggerNewList);
    }

    private void checkRegistrationLimit(List<MeetupRegistration__c> registrations) {
        Set<Id> meetupIds = new Set<Id>();
        for (MeetupRegistration__c registration : registrations) {
            meetupIds.add(registration.Meetup__c);
        }
        List<Meetup__c> meetups = new MeetupSelector().getMeetupsById(meetupIds, false);
        map<Id, Integer> remainingSeats = new Map<Id, Integer>();
        // need to keep track over the whole trigger context as we iterate over registrations
        // just in case we have a bulk registration option
        for (Meetup__c meetup : meetups) {
            remainingSeats.put(meetup.Id, (Integer) meetup.RegistrationLimit__c - (Integer) meetup.Registrations__c);
        }
        for (MeetupRegistration__c registration : registrations) {
            if (remainingSeats.get(registration.Meetup__c) <= 0) {
                // generally like to add wrappers around add error
                // or use exceptions in a more robust framework
                // so that we can mock and not have integration tests be a requirement for trigger logic
                // but just using standard libs for now
                registration.addError(REGISTRATION_LIMIT_EXCEEDED);
            }
            remainingSeats.put(registration.Meetup__c, remainingSeats.get(registration.Meetup__c) - 1);
        }
    }

    private void checkForUniqueEmail(List<MeetupRegistration__c> registrations) {
        Set<Id> meetupIds = new Set<Id>();
        for (MeetupRegistration__c registration : registrations) {
            meetupIds.add(registration.Meetup__c);
        }
        List<Meetup__c> meetups = new MeetupSelector().getMeetupsById(meetupIds, false);
        Map<Id, Set<String>> meetupToEmails = new Map<Id, Set<String>>();
        for (Meetup__c meetup : meetups) {
            meetupToEmails.put(meetup.Id, new Set<String>());
            for (MeetupRegistration__c registration : meetup.Meetup_Registrations__r) {
                meetupToEmails.get(meetup.Id).add(registration.Email__c);
            }
        }
        for (MeetupRegistration__c registration : registrations) {
            if (meetupToEmails.get(registration.Meetup__c).contains(registration.Email__c)) {
                // generally like to add wrappers around add error
                // or use exceptions in a more robust framework
                // so that we can mock and not have integration tests be a requirement for trigger logic
                // but just using standard libs for now
                registration.addError(REGISTRATION_DUPLICATE_EMAIL);
            }
            meetupToEmails.get(registration.Meetup__c).add(registration.Email__c);
        }
    }
}