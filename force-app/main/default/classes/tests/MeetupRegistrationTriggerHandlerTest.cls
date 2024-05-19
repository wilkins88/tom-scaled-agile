@IsTest
private inherited sharing class MeetupRegistrationTriggerHandlerTest {

    @TestSetup
    private static void makeData() {
        insert new Meetup__c(RegistrationLimit__c = 2);
    }

    @IsTest
    private static void doBeforeInsert_singleRecordHappyPath_succeed() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        System.Test.startTest();
        insert new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id);
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(1, result.size(), 'Should create the registration record');
    }

    @IsTest
    private static void doBeforeInsert_multipleRecordHappyPath_succeed() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        System.Test.startTest();
        insert new List<MeetupRegistration__c> {
            new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id),
            new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test2@Tester.com', Meetup__c = meetup.Id)
        };
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(2, result.size(), 'Should create the registration record');
    }

    @IsTest
    private static void doBeforeInsert_singleRecordLimitExceeded_throwException() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        insert new List<MeetupRegistration__c> {
            new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id),
            new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test2@Tester.com', Meetup__c = meetup.Id)
        };
        String err;
        System.Test.startTest();
        try {
            insert new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test3@Tester.com', Meetup__c = meetup.Id);
        } catch (Exception e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(2, result.size(), 'Should not create the 3rd registration record');
        Assert.isTrue(err.contains(MeetupRegistrationTriggerHandler.REGISTRATION_LIMIT_EXCEEDED), 'Should throw the correct error');
    }

    @IsTest
    private static void doBeforeInsert_multipleRecordLimitExceeded_throwException() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        String err;
        System.Test.startTest();
        try {
            insert new List<MeetupRegistration__c> {
                new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id),
                new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test2@Tester.com', Meetup__c = meetup.Id),
                new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test3@Tester.com', Meetup__c = meetup.Id)
            };
        } catch (Exception e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(0, result.size(), 'Should not create any registration records');
        Assert.isTrue(err.contains(MeetupRegistrationTriggerHandler.REGISTRATION_LIMIT_EXCEEDED), 'Should throw the correct error');
    }

    @IsTest
    private static void doBeforeInsert_singleRecordEmailDupe_throwException() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        insert new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id);
        String err;
        System.Test.startTest();
        try {
            insert new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id);
        } catch (Exception e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(1, result.size(), 'Should not create the 2nd registration record');
        Assert.isTrue(err.contains(MeetupRegistrationTriggerHandler.REGISTRATION_DUPLICATE_EMAIL), 'Should throw the correct error');
    }

    @IsTest
    private static void doBeforeInsert_multipleRecordEmailDupe_throwException() {
        Meetup__c meetup = [SELECT Id FROM Meetup__c LIMIT 1];
        String err;
        System.Test.startTest();
        try {
            insert new List<MeetupRegistration__c> {
                new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id),
                new MeetupRegistration__c(FirstName__c = 'Test', LastName__c = 'Tester', Email__c = 'Test@Tester.com', Meetup__c = meetup.Id)
            };
        } catch (Exception e) {
            err = e.getMessage();
        }
        System.Test.stopTest();
        List<MeetupRegistration__c> result = [SELECT Id FROM MeetupRegistration__c WHERE Meetup__c = :meetup.Id];
        Assert.areEqual(0, result.size(), 'Should not create any registration records');
        Assert.isTrue(err.contains(MeetupRegistrationTriggerHandler.REGISTRATION_DUPLICATE_EMAIL), 'Should throw the correct error');
    }
}