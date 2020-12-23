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
trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {

 if(Trigger.isAfter && Trigger.isInsert){

    EventAttendeeTriggerHandler.sendConfirmationEmail(Trigger.New);
 }
}