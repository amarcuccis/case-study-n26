/**
 * @description       : Apex Controller for ContactProductInfo LWC. Retrieves the selected Product information from the Contact info in a Case
 * @last modified on  : 01-10-2023
**/
public with sharing class ContactProductInfo {
    
    /**
    * @description Returns a matching active Product for a Case's contact by a Product type and a Home Country
    * @author AM | 01-10-2023 
    * @param caseId -> The current Case Id related to the Contact
    * @return Product2 -> The matching product for the selected Product type and Home Country on the Case's Contact 
    **/
    @AuraEnabled
    public static Product2 getSelectedProduct(Id caseId) {
        Product2 selectedProduct;
        List<Case> currentCase = [
            SELECT 
                Contact.Home_Country__c,
                Contact.Product__c
            FROM Case
            WHERE Id = :caseId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        if(!currentCase.isEmpty()) {
            List<Product2> matchingProduct = [
                SELECT
                    Name,
                    toLabel(Available_Country__c),
                    Calendar_Month_Cost__c,
                    Other_Currency_ATM_Fee__c,
                    Card_Replacement_Cost__c
                FROM Product2
                WHERE IsActive = true
                    AND Name = :currentCase[0].Contact.Product__c
                    AND Available_Country__c = :currentCase[0].Contact.Home_Country__c
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];
            selectedProduct = !matchingProduct.isEmpty() ? matchingProduct[0] : null;
        }
        return selectedProduct;
    }
}
