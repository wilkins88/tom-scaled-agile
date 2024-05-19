@IsTest
private inherited sharing class MeetupRegistrationControllerTest {
    // Would generally mock out dependencies here with a generic class mocker
    @IsTest
    private static void getAvailableMeetupIdForCode_noCode_throwException() {
        String err;
        System.Test.startTest();
        try {
            MeetupRegistrationController.getAvailableMeetupIdForCode(null);
        } catch (AuraHandledException e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        Assert.isTrue(err.contains(MeetupRegistrationController.REGISTRATION_CODE_REQUIRED), 'Should throw the no code exception');
    }

    @IsTest
    private static void getAvailableMeetupIdForCode_noMeetups_throwException() {
        String err;
        System.Test.startTest();
        try {
            MeetupRegistrationController.getAvailableMeetupIdForCode('abcd1234');
        } catch (AuraHandledException e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        Assert.isTrue(err.contains(MeetupRegistrationController.MEETUP_NOT_FOUND), 'Should throw the no meetup exception');
    }

    @IsTest
    private static void getAvailableMeetupIdForCode_meetupClosed_throwException() {
        insert new Meetup__c(RegistrationLimit__c = 1, Status__c = 'Closed');
        // a reason to mock -- even our test setup is an integration test that requires 
        // automation to work
        Meetup__c meetup = [SELECT RegistrationCode__c FROM Meetup__c LIMIT 1];
        String err;
        System.Test.startTest();
        try {
            MeetupRegistrationController.getAvailableMeetupIdForCode(meetup.RegistrationCode__c);
        } catch (AuraHandledException e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        Assert.isTrue(err.contains(MeetupRegistrationController.MEETUP_IS_CLOSED), 'Should throw the closed meetup exception');
    }

    @IsTest
    private static void getAvailableMeetupIdForCode_meetupFull_throwException() {
        insert new Meetup__c(RegistrationLimit__c = 1);
        // a reason to mock -- even our test setup is an integration test that requires 
        // automation to work
        Meetup__c meetup = [SELECT RegistrationCode__c FROM Meetup__c LIMIT 1];
        insert new MeetupRegistration__c(FirstName__c = 'test', LastName__c = 'tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id);
        String err;
        System.Test.startTest();
        try {
            MeetupRegistrationController.getAvailableMeetupIdForCode(meetup.RegistrationCode__c);
        } catch (AuraHandledException e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        Assert.isTrue(err.contains(MeetupRegistrationController.MEETUP_IS_FULL), 'Should throw the full meetup exception');
    }

    @IsTest
    private static void getAvailableMeetupIdForCode_meetupAvailable_returnMeetupId() {
        insert new Meetup__c(RegistrationLimit__c = 1);
        // a reason to mock -- even our test setup is an integration test that requires 
        // automation to work
        Meetup__c meetup = [SELECT RegistrationCode__c FROM Meetup__c LIMIT 1];
        System.Test.startTest();
        Id result = MeetupRegistrationController.getAvailableMeetupIdForCode(meetup.RegistrationCode__c);
        System.Test.stopTest();
        Assert.areEqual(meetup.Id, result, 'Should return the correct Id');
    }
}