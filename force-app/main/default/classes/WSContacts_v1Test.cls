@IsTest
@SuppressWarnings('PMD.ApexDoc')
private with sharing class WSContacts_v1Test {
    private static final String UUID = '1d66a150-497a-4fd5-a947-8a249e3a7a80';

    @TestSetup
    static void makeData() {
        TestDataFactory.generateContactProductInfoDataSet(WSContacts_v1Test.UUID);
    }

    @IsTest
    private static void testWSReturnsContactInfoFromCustomerExternalId() {
        Contact testContact = [SELECT Id, External_Id__c, Home_Country__c FROM Contact LIMIT 1];
    
        Test.startTest();
        WSContacts_v1Test.makeGETCallout(WSContacts_v1Test.UUID);
        WSContacts_v1.Response response = WSContacts_v1.getCallout();
        Test.stopTest(); 

        System.assertEquals(WSContacts_v1.OK_CODE, response.status, 'status code is wrong');
        System.assertEquals(testContact.External_Id__c, response.customerInfo.uuId, 'retrieved customer is wrong');
        System.assertNotEquals(null, response.customerInfo, 'response doesnt contains customer info');
        System.assertEquals(testContact.Home_Country__c, response.customerInfo.countryCode, 'customer info is wrong');
    }

    @IsTest
    private static void testWSReturnsErrorWhenNoParamsInCallout() {
        Test.startTest();
        WSContacts_v1Test.makeGETCallout('');
        WSContacts_v1.Response response = WSContacts_v1.getCallout();
        Test.stopTest();

        System.assertEquals(WSContacts_v1.NO_PARAMS_ERROR_CODE, response.status, 'status code is wrong');
        System.assertEquals(null, response.customerInfo, 'response contains customer info when shouldnt');
        System.assert(response.message.contains(WSContacts_v1.NO_PARAMS_ERROR_TEXT), 'info message is wrong');
    }

    @IsTest
    private static void testWSReturnsMessageWhenNoCustomerFoundForAnExternalId() {    
        Test.startTest();
        WSContacts_v1Test.makeGETCallout('6b3cd917-1c2d-4d85-ad29-698f25561490');
        WSContacts_v1.Response response = WSContacts_v1.getCallout();
        Test.stopTest(); 

        System.assertEquals(WSContacts_v1.OK_CODE, response.status, 'status code is wrong');
        System.assertEquals(null, response.customerInfo, 'response contains customer info when shouldnt');
        System.assert(response.message.contains(WSContacts_v1.NO_CONTACT_FOUND_INFO_TEXT), 'info message is wrong');
    }

    @IsTest
    private static void testWSReturnsMessageWhenNoProductFoundForTheContact() {  
        delete [SELECT Id FROM Product2 LIMIT 1];

        Test.startTest();
        WSContacts_v1Test.makeGETCallout(WSContacts_v1Test.UUID);
        WSContacts_v1.Response response = WSContacts_v1.getCallout();
        Test.stopTest();

        System.assertEquals(WSContacts_v1.OK_CODE, response.status, 'status code is wrong');
        System.assertEquals(null, response.customerInfo, 'response contains customer info when shouldnt');
        System.assert(response.message.contains(WSContacts_v1.NO_PRODUCT_FOUND_INFO_TEXT), 'info message is wrong');
    }

    @IsTest
    private static void testWSReturnsErrorWhenInteralExceptionOcurrs() {
        Id minimumAccesProfileId = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce'].Id;
        User minAccessUser = [SELECT Id FROM User WHERE ProfileId = :minimumAccesProfileId];

        Test.startTest();
        System.runAs(minAccessUser) {
            WSContacts_v1Test.makeGETCallout(WSContacts_v1Test.UUID);
            WSContacts_v1.Response response = WSContacts_v1.getCallout();

            System.assertEquals(WSContacts_v1.SERVER_ERROR_CODE, response.status, 'status code is wrong');
            System.assertEquals(null, response.customerInfo, 'response contains customer info when shouldnt');
        }
        Test.stopTest();
    }

    private static RestResponse makeGETCallout(String externalId) {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/customer/';
        req.httpMethod = 'GET';
        if(!String.isBlank(externalId)) {
            req.addParameter(WSContacts_v1.UUID_PARAM_NAME, externalId);
        }

        RestContext.request = req;  
        RestContext.response = res;
        return res;
    }
}
