/**
 * @description       : Web Service Class with a Get method that receives a Contact UUID, and retrieves the Customer Product information for N26 external systems
 * @last modified on  : 01-11-2023
**/
@RestResource(urlMapping='/v1/customer/*')
global with sharing class WSContacts_v1 {

    @TestVisible private static final Integer OK_CODE = 200;
    @TestVisible private static final Integer NO_PARAMS_ERROR_CODE = 400;
    @TestVisible private static final Integer SERVER_ERROR_CODE = 500;
    @TestVisible private static final String NO_PARAMS_ERROR_TEXT = 'No parameters found in the request.';
    @TestVisible private static final String NO_CONTACT_FOUND_INFO_TEXT = 'There is no Contact for the passed UUID.';
    @TestVisible private static final String NO_PRODUCT_FOUND_INFO_TEXT = 'There is no matching Product for the Contact.';
    @TestVisible private static final String UUID_PARAM_NAME = 'UUID';

    /**
    * @description Web Service GET Method
    * @return Response -> The response to return
    **/
    @HttpGet
    global static Response getCallout() {
        Response toRet = new Response();
        try {
            RestRequest request = RestContext.request;
            toRet.requestURI = request.requestURI;

            Map<String,String> uriParams = RestContext.request.params;
            String externalContactId;

            if(uriParams == null || !uriParams.containsKey(WSContacts_v1.UUID_PARAM_NAME)) {
                throw new ParamsException(WSContacts_v1.NO_PARAMS_ERROR_TEXT);
            }
            externalContactId = RestContext.request.params.get(WSContacts_v1.UUID_PARAM_NAME);

            Contact matchingContact = WSContacts_v1.getContact(externalContactId);
            if(matchingContact == null) {
                throw new NoFoundException(WSContacts_v1.NO_CONTACT_FOUND_INFO_TEXT);
            }

            Product2 product = WSContacts_v1.getProduct(matchingContact);
            if(product == null) {
                throw new NoFoundException(WSContacts_v1.NO_PRODUCT_FOUND_INFO_TEXT);
            }

            ContactWrapper customerInfo = WSContacts_v1.buildDataBody(matchingContact, product);
            customerInfo.uuId = externalContactId;
            toRet.customerInfo = customerInfo;
            toRet.status = WSContacts_v1.OK_CODE;
            toRet.message = 'OK';

        } catch(ParamsException ex) {
            System.debug(LoggingLevel.ERROR, 'ParamsException --> '+ ex);
            toRet.status = WSContacts_v1.NO_PARAMS_ERROR_CODE;
            toRet.message = ex.getMessage();

        } catch(NoFoundException ex) {
            System.debug(LoggingLevel.INFO, 'NoFoundException --> '+ ex);
            toRet.status = WSContacts_v1.OK_CODE;
            toRet.message = ex.getMessage();

        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'InternalException --> '+ ex);
            toRet.status = WSContacts_v1.SERVER_ERROR_CODE;
            toRet.message = 'Error --> ' + ex.getMessage() +
                '\nLine error --> ' + ex.getLineNumber() +
                '\nTrace --> ' + ex.getStackTraceString();
        }
        return toRet;
    }

    /**
    * @description Get Contact from an External Id
    * @param externalId -> The UUID from URI params
    * @return Contact -> The found Contact
    **/
    private static Contact getContact(String externalId) {
        List<Contact> contact = [
            SELECT
            Name,
            Home_Country__c,
            Product__c
            FROM Contact
            WHERE External_Id__c = :externalId
            WITH SECURITY_ENFORCED
            LIMIT 1
            ];
        return !contact.isEmpty() ? contact[0] : null;
    }

    /**
    * @description Get Product from the info of found Contact
    * @param contact -> The found Contact
    * @return Product2 -> The found Product for the Contact info
    **/
    private static Product2 getProduct(Contact contact) {
        List<Product2> matchingProduct = [
            SELECT
                Name,
                Available_Country__c,
                Calendar_Month_Cost__c,
                Other_Currency_ATM_Fee__c,
                Card_Replacement_Cost__c,
                CurrencyIsoCode
            FROM Product2
            WHERE IsActive = true
                AND Name = :contact.Product__c
                AND Available_Country__c = :contact.Home_Country__c
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        return !matchingProduct.isEmpty() ? matchingProduct[0] : null;
    }

    /**
    * @description Builds the JSON body with all the Contact and Product information
    * @param contact -> The found Contact
    * @param product -> The found Product for the Contact info 
    * @return ContactWrapper -> The JSON body class with the Contact and Product Information
    **/
    private static ContactWrapper buildDataBody(Contact contact, Product2 product) {
        ContactWrapper data = new ContactWrapper();
        data.sfdcId = contact.Id;
        data.name = contact.Name;
        data.countryCode = contact.Home_Country__c;
        data.product = contact.Product__c;
        data.currencyISOCode = product.CurrencyIsoCode;
        data.costPerCalendarMonth = product.Calendar_Month_Cost__c;
        data.otherCurrenciesATMFee = product.Other_Currency_ATM_Fee__c;
        data.cardReplacementCost = product.Card_Replacement_Cost__c;
        return data;
    }

    /**
     * @description       : Response class that contains response data and wrapped Contact information for a successful request
     * @last modified on  : 01-11-2023
    **/
    global class Response {
        global Integer status;
        global String message;
        global String requestURI;
        global ContactWrapper customerInfo;
    }

    /**
     * @description       : Wrapper class to return Contact information
     * @last modified on  : 01-11-2023
    **/
    global class ContactWrapper {
        global String sfdcId;
        global String uuId;
        global String name;
        global String countryCode;
        global String product;
        global String currencyISOCode;
        global Decimal costPerCalendarMonth;
        global Decimal otherCurrenciesATMFee;
        global Decimal cardReplacementCost;
    }

    public class ParamsException extends Exception {}
    public class NoFoundException extends Exception {}
}