/**
 * Created by Adelchi on 27/05/2018.
 */

@IsTest
private class LookupInvReqTest {

    public static Account a ;
    public static Account a1 ;
    public static Site__c s;
    public static User uD;
    public static Profile profileId;
    public static Contact contD;
    public static Inventory_Required__c invReq;

    public static void generateTestData(){
        Profile pD = [SELECT Id FROM Profile WHERE Name = 'Partner Community User - Clone - Doctor' LIMIT 1];
        a = new Account(
                Status__c = 'Active',
                Name = 'testAccount'
        );
        insert a;
        a1 = new Account(
                Status__c = 'Active',
                Name = 'testAccount'
        );
        insert a1;
        s = new Site__c(
                Name = 'testSite',
                Account__c = a1.Id,
                Site_Type__c = 'Office',
                Clinic_Code__c = 'testClinicCode',
                SAP_Customer_ID__c = 'testNAVId'
        );
        insert s;
        String siteName = [SELECT Name FROM Site__c WHERE Id =: s.Id LIMIT 1].Name;
        contD = new Contact(
                FirstName = 'Test',
                LastName = 'testLastNameD',
                AccountId = a.Id,
                Birthdate = date.newInstance(2000,1,1),
                GDPRCompliant__c = True,
                Gender__c = 'Male',
                OccupationCategory__c = 'Operations Administration',
                OccupationTitle__c = 'Medic',
                Contract_Employer__c = a.Id,
                Site__c = s.Id
        );
        insert contD;
        uD = new User(
                LastName = 'LastD',
                FirstName='JamesD',
                Alias = 'jlasD',
                Email = 'test@test.testD',
                Username = 'test@iqarus.iqarusD',
                CommunityNickname = 'testUser123D',
                ProfileId = pD.Id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = contD.Id,
                LocaleSidKey = 'en_US',
                IsActive = true
        );

        invReq = new Inventory_required__c(
                Name = 'inventory',
                Doses_per_Item__c = 12,
                Quantity_Required__c = 12,
                Existing_Boxes__c = 12,
                Existing_Doses__c = 12,
                Site__c = s.Id
        );
        insert invReq;

    }

    static testMethod void testBehavior () {
        generateTestData();
        insert uD;
        system.runAs(uD){
            test.startTest();
            String invList = LookupInvReq.searchDB('Inventory_Required__c','Name','Id',1,'Name','inventory');
            system.assertEquals('[{"val":"'+invReq.Id+'","text":"inventory","rD":"144","rB":"12","objName":"Inventory_Required__c","eD":"12","eB":"12"}]', invList);
            test.stopTest();
        }

    }
}