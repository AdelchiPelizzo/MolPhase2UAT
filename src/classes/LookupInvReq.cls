/**
 * Created by Adelchi on 11/05/2018.
 */

public with sharing class LookupInvReq {

    /**
         * Returns JSON of list of ResultWrapper to Lex Components
         * @objectName - Name of SObject
         * @fld_API_Text - API name of field to display to user while searching
         * @fld_API_Val - API name of field to be returned by Lookup COmponent
         * @lim   - Total number of record to be returned
         * @fld_API_Search - API name of field to be searched
         * @searchText - text to be searched
         * */
    @AuraEnabled
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val,
            Integer lim,String fld_API_Search,String searchText )
    {
        String contactUserId = [SELECT ContactId FROM User WHERE Id =: userInfo.getUserId() LIMIT 1].ContactId;
        Contact c = [SELECT Id, Site__c FROM Contact WHERE Id =: contactUserId LIMIT 1];
        String siteId = c.Site__c;
        String eBoxes = 'Existing_Boxes__c';
        String rBoxes = 'Quantity_Required__c';
        String eDoses = 'Existing_Doses__c';
        String rDoses = 'Total_Doses_Required__c';

        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
        /*' AND Site__c = '+c.Site__c+*/
        String query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+' , '+eBoxes+' , '+rBoxes+' , '+eDoses+' , '+rDoses+
                ' FROM '+objectName+
                ' WHERE '+fld_API_Search+' LIKE '+searchText+' AND Site__c = \''+siteId+'\''+
                ' LIMIT '+lim;
        system.debug(query);
        List<sObject> sobjList = Database.query(query);
        system.debug(sobjList.size());
        List<ResultWrapper> lstRet = new List<ResultWrapper>();

        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.eB = String.valueOf(s.get(eBoxes)) ;
            obj.rB = String.valueOf(s.get(rBoxes)) ;
            obj.eD = String.valueOf(s.get(eDoses)) ;
            obj.rD = String.valueOf(s.get(rDoses)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            lstRet.add(obj);
        }
        system.debug(JSON.serialize(lstRet));
        return JSON.serialize(lstRet) ;
    }

    public class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String eB{get;set;}
        public String rB{get;set;}
        public String eD{get;set;}
        public String rD{get;set;}
        public String val{get;set;}
    }
}