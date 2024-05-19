/**
 * Would generally have this implement a base abstract class as part of a broader
 * secure by default data library, but just separating for this to show proper separation of 
 * concerns
 */
public inherited sharing class MeetupSelector {
    public List<Meetup__c> getMeetupsByRegistrationCode(Set<String> registrationCodes, Boolean enforceFLS) {
        // would normally have this be some sort of query builder as a part of the 
        // data library, but just do inline soql for now
        // note the data library would also be used to enforce/not enforce security, so we wouldn't
        // have to hard code it in queries and do this weird dance with enforce FLS checks
        return (List<Meetup__c>) Database.query(this.getQuery('RegistrationCode__c IN :registrationCodes', enforceFLS));
    }

    public List<Meetup__c> getMeetupsById(Set<Id> meetupIds, Boolean enforceFLS) {
        // would normally have this be some sort of query builder as a part of the 
        // data library, but just do inline soql for now
        // note the data library would also be used to enforce/not enforce security, so we wouldn't
        // have to hard code it in queries and do this weird dance with enforce FLS checks
        return (List<Meetup__c>) Database.query(this.getQuery('Id IN :meetupIds', enforceFLS));
    }

    // wouldnt usually use something like this -- that is usually managed by the data framework
    // to make queries more composable
    private String getQuery(String filter, Boolean enforceFLS) {
        String query = 'SELECT Id, Status__c, RegistrationLimit__c, Registrations__c, ' 
        + ' (SELECT Email__c FROM Meetup_Registrations__r)' 
        + ' FROM Meetup__c WHERE ' + filter;
        if (enforceFLS) {
            query += ' WITH SECURITY_ENFORCED';
        }
        return query;
    }
}