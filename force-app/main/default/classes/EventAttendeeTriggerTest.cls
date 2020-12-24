/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-24-2020
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   12-24-2020   Anna Makhovskaya   Initial Version
**/
@isTest
public class  EventAttendeeTriggerTest {

    @testSetup
    public static void setupData() {
        Event_Organizer__c org = new Event_Organizer__c(
            Name = 'Dana Smith',
            Phone__c = '091235678',
            Email__c = 'danapartner@gmail.com',
            Alternative_Phone__c = '123456789',
            Alternative_Email__c = 'danapartner1@gmail.com'
        );

        insert org;

        Event__c evt = new Event__c(
            Name__c = 'MAX FIT Compaign',
            Event_Organizer__c  = org.Id,
            Event_Type__c = 'Virtual',
            Frequency__c = 'Weekly',
            Max_Seats__c = 199,
            Recurring__c = true,
            Live__c = true,
            Start_DateTime__c = System.Now(),
            End_DateTime__c = System.Now().addDays(3)
        );

        insert evt;

        Attendee__c att = new Attendee__c(
            Name = 'Denis Win',
            Email__c = 'denpartner@gmail.com',
            Phone__c = '091445678'
        );

        insert att;

        Event_Attendee__c evtAtt = new Event_Attendee__c(
            Event__c = evt.Id,
            Attendee__c = att.Id
        );

        insert evtAtt;

    }


    @isTest
    static void sendConfirmationEmailTest(){

    }
}
