public with sharing class MeetupRegistrationController {
    @TestVisible
    private static final String REGISTRATION_CODE_REQUIRED = 'Registration code required to retrieve meetup details.';
    @TestVisible
    private static final String MEETUP_NOT_FOUND = 'Meetup was not found.';
    @TestVisible
    private static final String MEETUP_IS_CLOSED = 'Meetup is closed and cannot accept any more registrations.';
    @TestVisible
    private static final String MEETUP_IS_FULL = 'Meetup is full and cannot accept any more registrations.';
    @TestVisible
    private static final String CANNOT_PROVIDE_BLANK_REGISTRATION_VALUES = 'One or more registration details were blank.';

    @AuraEnabled
    public static Id getAvailableMeetupIdForCode(String registrationCode) {
        try {
            if (String.isBlank(registrationCode)) {
                throw new RegistrationException(REGISTRATION_CODE_REQUIRED);
            }
            // would normally have a factory similar to the services class so that this can be mockable
            // would maybe move this logic down to a service class too -- we want to keep entry points thin to promote reuse
            List<Meetup__c> meetups = new MeetupSelector().getMeetupsByRegistrationCode(new Set<String> { registrationCode }, true);
            if (meetups.isEmpty()) {
                throw new RegistrationException(MEETUP_NOT_FOUND);
            }
            if (meetups[0].Status__c == 'Closed') {
                throw new RegistrationException(MEETUP_IS_CLOSED);
            }
            if (meetups[0].Registrations__c >= meetups[0].RegistrationLimit__c) {
                throw new RegistrationException(MEETUP_IS_FULL);
            }
            return meetups[0].Id;
        } catch (Exception e) {
            // would generally move this to a more reusable service so we aren't repeating in every method
            Services.logger.error('MeetupRegistrationController.getMeetupIdForCode', e);
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        }
    }

    @AuraEnabled
    public static void register(RegistrationArgs args) {
        try {
            args.validate();
            // would use data library for more flexible and holistic secure by default dml here rather than this, but using standard libs for interview problem
            Database.insert(
                new MeetupRegistration__c(
                    FirstName__c = args.firstName,
                    LastName__c = args.lastName,
                    Email__c = args.email,
                    Meetup__c = args.meetup
                ), 
                AccessLevel.User_mode
            ); 
        } catch (Exception e) {
            // would generally move this to a more reusable service so we aren't repeating in every method
            Services.logger.error('MeetupRegistrationController.register', e);
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    // DTO for UI contract
    public inherited sharing class RegistrationArgs {
        @AuraEnabled
        public Id meetup { get; set; }
        @AuraEnabled
        public String firstName { get; set; }
        @AuraEnabled
        public String lastName { get; set; }
        @AuraEnabled
        public String email { get; set; }

        public void validate() {
            if (
                String.isBlank(this.firstName) 
                || String.isBlank(this.lastName) 
                || String.isBlank(this.email)
                || String.isBlank(this.meetup)
            ) {
                throw new RegistrationException(CANNOT_PROVIDE_BLANK_REGISTRATION_VALUES);
            }
        }
    }

    private inherited sharing class RegistrationException extends Exception {
    }
}