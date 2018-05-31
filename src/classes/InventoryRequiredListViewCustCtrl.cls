/**
 * Created by Adelchi on 14/05/2018.
 */

public with sharing class InventoryRequiredListViewCustCtrl {

    @AuraEnabled
    Public static List<Inventory_Required__c> getRequirementList(){
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        List<Inventory_Required__c> inLst = new List<Inventory_Required__c>();
        inLst = [SELECT Id, Name, Quantity_Required__c, Existing_Boxes__c, Existing_Doses__c, Total_Doses_Required__c  FROM Inventory_Required__c WHERE Site__c =: siteId ORDER BY Name ASC];
        return inLst;
    }
}