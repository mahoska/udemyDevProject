/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-23-2020
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   12-23-2020   Anna Makhovskaya   Initial Version
**/
public with sharing class EventAttendeeTriggerHandler {

    public static void sendConfirmationEmail(List<Event_Attendee__c> newRecordList) {

        Set<Id> attendeesIdsSet = new Set<Id>();
        Set<Id> eventsIdsSet = new Set<Id>();

        for(Event_Attendee__c ea : newRecordList){

            attendeesIdsSet.add(ea.Attendee__c);
            eventsIdsSet.add(ea.Event__c);
        }

        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>([SELECT Id, Name, Email__c FROM Attendee__c WHERE Id IN : attendeesIdsSet]);

        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([SELECT Id, Name__c, Start_DateTime__c, Event_Organizer__c, Event_Organizer__r.Name,
                                    Location__c, Location__r.Name, Location__r.Country__c, Location__r.Street__c, 
                                    Location__r.City__c, Location__r.State__c, Location__r.Postal_Code__c, Location__r.House_number__c
                                    FROM Event__c WHERE Id IN : eventsIdsSet]);

        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for(Event_Attendee__c ea : newRecordList){

            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            Event__c evt = eventMap.get(ea.Event__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Pass for the ' + evt.Name__c);
            List<String> toAddress =  new List<String>();
            toAddress.add(att.Email__c);
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName(evt.Event_Organizer__r.Name);

            String location = 'https://www.google.com/maps/place/' + evt.Location__r.Street__c + ', '  + evt.Location__r.House_number__c + ', ' +
                                evt.Location__r.City__c + ', ' + evt.Location__r.State__c + ', ' + evt.Location__r.Country__c + ', ' +
                                evt.Location__r.Postal_Code__c;

            String hrefForLocation  = '<a href="' + location + '"' + ' target="_blank">Here</a>';

            String emailBody = 'Dear ' + att.Name + ', '+
            'Thank you for registering for ' + evt.Name__c + ' which will be Organized on ' + evt.Start_DateTime__c + ' & will be held in ' + 
            evt.Location__r.Name + '. We are excited to have you, see you in the event. <br/>' + 
            'Find the Google Map Location for the Event ' + hrefForLocation + '<br/><br/><br/>' + 
            'Thanks, <br/>' + evt.Event_Organizer__r.Name;

            mail.setHtmlBody(emailBody);

            emailList.add(mail);
            
        }

        try{

            List<Messaging.SendEmailResult> result = Messaging.sendEmail(emailList, false);

            for(Messaging.SendEmailResult email : result){
                if(!email.isSuccess()){

                    List<Messaging.SendEmailError> errors = email.getErrors();

                    TransactionLogHandler.doHandleExceptionWithError(JSON.serialize(errors), 'EventAttendeeTriggerHandler');
                }
            }

        }catch(System.Exception ex){
            TransactionLogHandler.doHandleException(ex, 'EventAttendeeTriggerHandler');

        }
    }
}
