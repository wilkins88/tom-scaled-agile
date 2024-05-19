@IsTest
private inherited sharing class MeetupSelectorTest {
    @TestSetup
    private static void makeData() {
        // likely use a data factory for any data generation
        // data factory + record mocking can be the same library
        // I personally like to create a record mocking framework that also tries
        // to hydrate schema-required values to mitigate risk of needing future refactors
        insert new List<Meetup__c> { 
            new Meetup__c(RegistrationLimit__c = 1), 
            new Meetup__c(RegistrationLimit__c = 1)
        }; 
    }

    @IsTest
    private static void getMeetupsByRegistrationCode_2existing_return1Queried() {
        Meetup__c openMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c LIMIT 1];

        MeetupSelector selector = new MeetupSelector();
        System.Test.startTest();
        List<Meetup__c> results = selector.getMeetupsByRegistrationCode(
            new Set<String> { openMeetup.RegistrationCode__c },
            false
        );
        System.Test.stopTest();
        
        Assert.areEqual(1, results.size(), 'Should return 1 of the 2 records');
        Assert.areEqual(openMeetup.Id, results[0].Id, 'Should return the correct meetup');
    }

    @IsTest
    private static void getMeetupsById_2existing_return1Queried() {
        Meetup__c openMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c LIMIT 1];

        MeetupSelector selector = new MeetupSelector();
        System.Test.startTest();
        List<Meetup__c> results = selector.getMeetupsById(
            new Set<Id> { openMeetup.Id },
            false
        );
        System.Test.stopTest();
        
        Assert.areEqual(1, results.size(), 'Should return 1 of the 2 records');
        Assert.areEqual(openMeetup.Id, results[0].Id, 'Should return the correct meetup');
    }
}