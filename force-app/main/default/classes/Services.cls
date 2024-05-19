/**
 * For things like services I like to employ a "static accessor" patter that allows several things
 * First, it gives us the QoL of having static access for instance methods, which is helpful for having mockable 
 * services. Second, it gives us a nice way of collecting all of our services for code discovery. Third,
 * it supports an intuitive for IoC and DI for services (just load the correct implementation for an abstraction)
 * in the getter
 */
public inherited sharing class Services {
    // testvisible for the private setter
    @TestVisible
    public static StringService strings {
        get {
            if (strings == null) {
                strings = new StringService();
            }
            return strings;
        }
        private set;
    }
    @TestVisible
    public static LoggerService logger {
        get {
            if (logger == null) {
                logger = new LoggerService();
            }
            return logger;
        }
        private set;
    }
}