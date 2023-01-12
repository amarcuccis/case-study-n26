/**
 * @description       : Apex Test class for ContactProductInfo
 * @last modified on  : 01-10-2023
**/
@IsTest
private with sharing class ContactProductInfoTest {

    @TestSetup
    static void makeData() {
        TestDataFactory.generateContactProductInfoDataSet('external-id');
    }
    
    @IsTest
    private static void testContactProductInfoIsRetrievedWhenProductTypeAndCountryIsFullfilledOnContact() {
        Case testCase = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();
        Product2 selectedProduct = ContactProductInfo.getSelectedProduct(testCase.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, selectedProduct, 'selected product shoudlnt be null');
        System.assertEquals(selectedProduct.Calendar_Month_Cost__c, 0, 'retrieved selected product info is wrong');
        System.assertEquals(selectedProduct.Other_Currency_ATM_Fee__c, 1.70, 'retrieved selected product info is wrong');
        System.assertEquals(selectedProduct.Card_Replacement_Cost__c, 6, 'retrieved selected product info is wrong');
    }

    @IsTest
    private static void testContactProductInfoIsNotRetrievedWhenProductTypeOrCountryIsNotFullfilledOnContact() {
        Case testCase = [SELECT Id, ContactId FROM Case LIMIT 1];

        Contact testContact = new Contact(
            Id = testCase.ContactId,
            Home_Country__c = null
        );
        update testContact;

        Test.startTest();
        Product2 selectedProduct = ContactProductInfo.getSelectedProduct(testCase.Id);
        Test.stopTest();

        System.assertEquals(null, selectedProduct, 'selected product was found when shouldnt');
    }

    @IsTest
    private static void testContactProductInfoIsNotRetrievedWhenProductTypeAndCountryDoesntMatchAnExistentActiveProduct() {
        Case testCase = [SELECT Id, ContactId FROM Case LIMIT 1];

        Contact testContact = new Contact(
            Id = testCase.ContactId,
            Home_Country__c = 'FR'
        );
        update testContact;

        Test.startTest();
        Product2 selectedProduct = ContactProductInfo.getSelectedProduct(testContact.Id);
        Test.stopTest();

        System.assertEquals(null, selectedProduct, 'selected product was found when shouldnt');
    }

    @IsTest
    private static void testContactProductInfoThrowExceptionWhenInvalidContactIdIsPassed() {
        Test.startTest();
        try {
            ContactProductInfo.getSelectedProduct('INVALID');
        } catch (Exception e) {
            System.assertEquals('System.StringException', e.getTypeName(), 'An string exception should be thrown: ' + e.getMessage());
            return;
        }
        System.assert(false, 'first exception should be thrown so this assert shouldnt be fired');
        Test.stopTest();
    }
}
