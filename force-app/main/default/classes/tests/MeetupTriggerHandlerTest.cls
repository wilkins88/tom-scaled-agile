@IsTest
private inherited sharing class MeetupTriggerHandlerTest {
    @IsTest
    private static void doBeforeInsert_1HasCode1DoesNot_generateCodeOnSecond() {
        System.Test.startTest();
        insert new List<Meetup__c> {
            new Meetup__c(Name = '1', RegistrationLimit__c = 1, RegistrationCode__c = 'abcd1234'),
            new Meetup__c(Name = '2', RegistrationLimit__c = 1)
        };
        System.Test.stopTest();
        List<Meetup__c> results = [SELECT Name, RegistrationCode__c FROM Meetup__c];
        for (Meetup__c result : results) {
            if (result.Name == '1') {
                Assert.areEqual('abcd1234', result.RegistrationCode__c, 'Should not overwrite the registration code');
            } else {
                Assert.isTrue(String.isNotBlank(result.RegistrationCode__c), 'Should populate the registration code');
                Assert.isTrue(result.RegistrationCode__c.isAlphanumeric(), 'Should store an alpha numeric string');
            }
        }
    }
}