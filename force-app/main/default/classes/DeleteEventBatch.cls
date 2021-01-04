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
public  class DeleteEventBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext batchContext) {

        String query = 'SELECT Id, Name FROM Event__c WHERE Live__c = true AND End_DateTime__c < LAST_N_MONTHS:2';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext batchContext, List<Event__c> eventList) {

        if(!eventList.IsEmpty()){
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);
            for(Database.DeleteResult dr : deleteResult){
                if(!dr.isSuccess()){
                    List<Database.Error> errors = dr.getErrors();
                    String errorString = String.join(errors, ', ');
                    TransactionLogHandler.doHandleExceptionWithError(errorString, 'DeleteEventBatch');
                }
            }
        }
    }

    public void finish(Database.BatchableContext batchContext) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSubject('Batch Processing Completed');
            List<String> toAddress =  new List<String>();
            toAddress.add('mahovskajaanna@gmail.com');
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('Admin "MAX FIT"');
            mail.setHtmlBody('The DeleteEventBatch Batch Processing has been Completed');
            List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage> {mail};

            Messaging.sendEmail(emails);
    }
}
