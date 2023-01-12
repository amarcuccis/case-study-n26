/**
 * @description       : Data Factory class helper for Test classes
 * @last modified on  : 01-12-2023
**/
@IsTest
public with sharing class TestDataFactory {

    /**
    * @description Dataset generator for Contact Product Info module Test classes: ContactProductInfoTest, WSContacts_v1Test
    * @param contactExternalId -> The contact external Id (required for Contacts)
    **/
    public static void generateContactProductInfoDataSet(String contactExternalId) {
        Account testAccount = new Account(
            Name = 'N26 Test Customer'
        );
        insert testAccount;

        Contact testContact = new Contact(
            LastName = 'Test Contact',
            AccountId = testAccount.Id,
            Home_Country__c = 'ES',
            Product__c = 'Standard',
            External_Id__c = contactExternalId
        );
        insert testContact;

        Case caseContact = new Case(
            ContactId = testContact.Id
        );
        insert caseContact;

        Product2 standardESProd = new Product2(
            Name = 'Standard',
            ProductCode = 'STD-ES',
            Available_Country__c = 'ES',
            Calendar_Month_Cost__c = 0,
            Other_Currency_ATM_Fee__c = 1.70,
            Card_Replacement_Cost__c = 6,
            CurrencyIsoCode = 'EUR',
            IsActive = true
        );

        Product2 blackESProd = new Product2(
            Name = 'Black',
            ProductCode = 'BLK-ES',
            Available_Country__c = 'ES',
            Calendar_Month_Cost__c = 9.90,
            Other_Currency_ATM_Fee__c = 0,
            Card_Replacement_Cost__c = 6,
            CurrencyIsoCode = 'EUR',
            IsActive = true
        );

        Product2 metalESProd = new Product2(
            Name = 'Metal',
            ProductCode = 'MTL-ES',
            Available_Country__c = 'ES',
            Calendar_Month_Cost__c = 16.9,
            Other_Currency_ATM_Fee__c = 0,
            Card_Replacement_Cost__c = 45,
            CurrencyIsoCode = 'EUR',
            IsActive = true
        );
        insert new List<Product2>{standardESProd, blackESProd, metalESProd};
    }
}
