/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 01-05-2021
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   01-05-2021   Anna Makhovskaya   Initial Version
**/
trigger LocationTrigger on Location__c (after insert) {

    if(Trigger.isAfter && Trigger.isInsert){

        for(Location__c loc : Trigger.New){

            LocationTriggerHandler.verifyAddress (loc.Id);
        }
    }
}