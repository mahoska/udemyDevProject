/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 01-04-2021
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   01-04-2021   Anna Makhovskaya   Initial Version
**/

@isTest
public class DeleteEventBatchTest {
    
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

        List<Event__c> eventList =  new List<Event__c>();

        for(Integer i = 0; i <= 200; i++){


            Event__c evt = new Event__c(
                Name__c = 'MAX FIT Compaign #' + i + 1,
                Event_Organizer__c  = org.Id,
                Event_Type__c = 'Virtual',
                Frequency__c = 'Weekly',
                Max_Seats__c = 199,
                Recurring__c = true,
                Live__c = true,
                Start_DateTime__c = System.Now().addMonths(-4),
                End_DateTime__c = System.Now().addDays(3).addMonths(-4)
            );

            eventList.add(evt);
        }
     
        insert eventList;
    }

    @isTest
    static void sendDeleteEventTest(){

        Test.startTest();

            String jobId = Database.executeBatch(new DeleteEventBatch(), 250);

        Test.stopTest();
    }

}
