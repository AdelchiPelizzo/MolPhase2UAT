/**
 * Created by Adelchi on 23/03/2018.
 */

public with sharing class LoggedInUserDataCtrl {
//Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static String getUserName() {
        return userInfo.getName();
    }

    @AuraEnabled
    public static String getSiteName() {
        String contactUserId = [SELECT ContactId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1].ContactId;
        String assignedSiteId = [SELECT Site__c FROM Contact WHERE Id =: contactUserId].Site__c;
        String siteName = [SELECT Name FROM Site__c WHERE Id =: assignedSiteId LIMIT 1].Name;
        return siteName;
    }

    @AuraEnabled
    public static void setSiteName(String siteId) {
        system.debug('Inside Set Site Name >>> '+ siteId);
        String contactUserId = [SELECT ContactId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1].ContactId;
        Contact c = [SELECT Id, Site__c FROM Contact WHERE Id =: contactUserId];
        /*String siteName = [SELECT Name FROM Site__c WHERE Id =: c.Site__c LIMIT 1].Name;*/
        c.Site__c = siteId;
        update c;
    }
}