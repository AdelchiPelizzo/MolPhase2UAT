/**
 * Created by Adelchi on 21/05/2018.
 */

public with sharing class ConsumableRequiredListViewCustCtrl {
    @AuraEnabled
    Public static List<Consumable_Required__c> getRequirementList(){
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        List<Consumable_Required__c> inLst = new List<Consumable_Required__c>();
        inLst = [SELECT Id, Name, Quantity_Required__c, Existing_Boxes__c FROM Consumable_Required__c WHERE Site__c =: siteId ORDER BY Name ASC];
        return inLst;
    }
}