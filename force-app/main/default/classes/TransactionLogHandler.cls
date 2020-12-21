/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 12-21-2020
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   12-21-2020   Anna Makhovskaya   Initial Version
**/
public with sharing class TransactionLogHandler {
    public static void doHandleException(System.Exception ex, String processName) {
        
        Error_Log__c transactionLog = new Error_Log__c(
            Log_Details__c = ex.getStackTraceString() + '<br/> <strong> Message is </strong>' + ex.getMessage() 
            + '<br/>' + ex.getCause() + '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber(),
            Log_DateTime__c = system.Now(),
            Process_Name__c = processName
        );

        //if(Schema.sObjectType.Error_Log__c.isCreateable()){
            insert transactionLog;
        //}
    }
}
