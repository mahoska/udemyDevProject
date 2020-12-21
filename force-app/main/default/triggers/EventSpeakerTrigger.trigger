/*Develop a Trigger on Event - Speaker object which will throw an error if
the Speaker Selected on Event - Speaker Record already have an Event against his name. i.e - For a Speaker there will be
only one event at a time. Reject Duplicate Bookings
 */
trigger EventSpeakerTrigger on EventSpeaker__c (before insert, before update) {
    
    // Step 1 - Get the speaker id & event id 
	// Step 2 - SOQL on Event to get the Start Date and Put them into a Map
	// Step 3 - SOQL on Event - Spekaer to get the Related Speaker along with the Event Start Date
	// Step 4 - Check the Conditions and throw the Error
	
	Set<Id> speakerIdSet = new Set<Id>();
    Set<Id> eventIdSet = new Set<Id>();
    
    for(EventSpeaker__c es : Trigger.New){
        speakerIdSet.add(es.Speaker__c);
        eventIdSet.add(es.Event__c);
    }
    
    Map<Id, DateTime> requestedEvents = new Map<Id, DateTime>();
    
    List<Event__c> relatedEventList = [SELECT Id, Start_DateTime__c FROM Event__c WHERE Id IN :eventIdSet];
    
    for(Event__c evt : relatedEventList){
        requestedEvents.put(evt.Id, evt.Start_DateTime__c);
    }
    
    List<EventSpeaker__c> relatedEventSpeakerList = [SELECT Id, Event__c, Speaker__c, Event__r.Start_DateTime__c FROM EventSpeaker__c WHERE Speaker__c IN :speakerIdSet];
    
    for(EventSpeaker__c esb : Trigger.New ){
        
        DateTime bookingTime = requestedEvents.get(esb.Event__c);
        
        for(EventSpeaker__c es : relatedEventSpeakerList){
            
            if(es.Speaker__c == esb.Speaker__c && es.Event__r.Start_DateTime__c == bookingTime){
                esb.Speaker__c.addError('The speaker is already booked at that time');
                esb.addError('The speaker is already booked at that time');
            }
        }
    }
    
}