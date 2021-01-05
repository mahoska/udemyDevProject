/**
 * @description       : 
 * @author            : Anna Makhovskaya
 * @group             : 
 * @last modified on  : 01-05-2021
 * @last modified by  : Anna Makhovskaya
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   01-05-2021   Anna Makhovskaya   Initial Version
 * 
 * PS: added site-address (https://us-street.api.smartystreets.com) to Remote Site Settings
**/
public with sharing class LocationTriggerHandler {
    
    @future(callout=true)
    public static void verifyAddress ( String recordId ) {

        Location__c loc = [SELECT Id, Name, Street__c, City__c, Postal_Code__c, State__c FROM Location__c WHERE Id = :recordId];


        //https://us-street.api.smartystreets.com/street-address?auth-id=f8e7f115-d50f-91cd-5699-71064ce62835&auth-token=3JInjbI9xtZAS1CmfEZt&candidates=10&street=&city=&state=&zipcode=&match=invalid
        
        String baseURL = 'https://us-street.api.smartystreets.com/street-address?auth-id=f8e7f115-d50f-91cd-5699-71064ce62835&auth-token=3JInjbI9xtZAS1CmfEZt';
        baseURL += '&street=' + EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')
                +'&city=' + EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
                +'&state=' + EncodingUtil.urlEncode(loc.State__c, 'UTF-8')
                +'&zipcode=' + EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8')
                +'&match=invalid&candidates=10';
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        //httpReq.setHeader('Content-Type', 'application/json');

        Http http = new Http();

        HttpResponse httpResp = new HttpResponse();

        try{
            httpResp = http.send(httpReq);

            System.debug('responseBody ' + httpResp.getBody());

            if(httpResp.getStatusCode() == 200 && httpResp.getStatus() == 'OK'){

                String responseBody = httpResp.getBody();

                if(!String.isBlank(responseBody) && responseBody.length() > 2){

                    loc.Verified__c = true;

                }else{

                    loc.Verified__c = false;
                }

                update loc;

            }else{
                TransactionLogHandler.doHandleExceptionWithError( httpResp.getBody(), 'LocationTriggerHandler');
            }
        }catch(System.CalloutException ex){

            System.debug('responseBody ' + httpResp.getBody());

            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
        }

    }
}
