/**
 * I generally implement stateless service class still as instance classes
 * The reasoning is that while this will ultimately behave the same as a class filled with static
 * methods, static methods are not mockable in Apex. So if we want to introduce mocking for services 
 * in our unit tests (something I recommend) then we need to have instance methods to mock
 * 
 * See Services for how to invoke this class
 */
public inherited sharing class StringService {
    public String getRandomAlphaNumericString(Integer len) {
        String result = '';
        Integer loopCounter = (Integer) Math.ceil(len / 64.0);
        for (Integer i = 0; i < loopCounter; i++) {
            result += EncodingUtil.convertToHex(Crypto.generateAesKey(256));
        }
        return result.substring(0, len);
    }
}