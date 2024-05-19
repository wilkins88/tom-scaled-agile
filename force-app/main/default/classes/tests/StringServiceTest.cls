@IsTest
private inherited sharing class StringServiceTest {
    @IsTest
    private static void getRandomAlphaNumericString_lessThan64_returnString() {
        System.Test.startTest();
        String result = Services.strings.getRandomAlphaNumericString(20);
        System.Test.stopTest();
        Assert.areEqual(20, result.length(), 'Should return a string with correct length 20');
        Assert.isTrue(result.isAlphanumeric(), 'String should be alphanumeric');
    }

    @IsTest
    private static void getRandomAlphaNumericString_moreThan64_returnString() {
        System.Test.startTest();
        String result = Services.strings.getRandomAlphaNumericString(256);
        System.Test.stopTest();
        Assert.areEqual(256, result.length(), 'Should return a string with correct length 256');
        Assert.isTrue(result.isAlphanumeric(), 'String should be alphanumeric');
    }
}