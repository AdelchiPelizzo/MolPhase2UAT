/**
 * Created by Adelchi on 26/05/2018.
 */

@IsTest
private class InventoryReportCtrlTest {
    public static Account a ;
    public static Account a1 ;
    public static Site__c s;
    public static User UD;
    public static Contact contD;
    public static Consultation__c c;
    public static Inventory_Required__c inventoryRequired;
    public static Inventory__c inventoryPart;
    public static Inventory__c inventory;
    public static Inventory__c inventory2;
    public static Consumable_Required__c consumableRequired;
    public static Consumable__c consumable;
    public static Consumable__c consumable2;
    public static Profile pD;

    public static void generateTestData(){
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

        pD = [SELECT Id FROM Profile WHERE Name = 'Partner Community User - Clone - Doctor' LIMIT 1];
        system.debug(pD.Id);
        UD = new User(
                ProfileId  = pd.Id,
                LastName = 'LastD',
                FirstName='JamesD',
                Alias = 'jlasD',
                Email = 'test@test.testD',
                Username = 'test@iqarus.iqarusD',
                CommunityNickname = 'testUser123D',
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = contD.Id,
                LocaleSidKey = 'en_US',
                IsActive = true
        );
        insert UD;

        inventoryRequired = new Inventory_Required__c(
                Name = 'Inventory',
                Site__c = s.Id,
                Doses_per_Item__c = 10,
                Existing_Boxes__c = 1,
                Existing_Doses__c = 10,
                Quantity_Required__c = 1
        );
        insert inventoryRequired;

        inventoryPart = new Inventory__c(
                Name = 'Inventory',
                SiteName__c = s.Id,
                Total_Doses__c = 10,
                isPartial__c = True,
                Batch_Number__c = '12345'
        );

        inventory = new Inventory__c(
                Name = 'Inventory',
                SiteName__c = s.Id,
                Expiration_Date__c = date.newinstance(1960, 2, 17),
                Total_Doses__c = 10,
                isPartial__c = False,
                Batch_Number__c = '12345',
                Available__c = True
        );
        insert inventory;
    }
    public static void generateTestDataC() {
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

        pD = [SELECT Id FROM Profile WHERE Name = 'Partner Community User - Clone - Doctor' LIMIT 1];
        system.debug(pD.Id);
        UD = new User(
                ProfileId  = pd.Id,
                LastName = 'LastD',
                FirstName='JamesD',
                Alias = 'jlasD',
                Email = 'test@test.testD',
                Username = 'test@iqarus.iqarusD',
                CommunityNickname = 'testUser123D',
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = contD.Id,
                LocaleSidKey = 'en_US',
                IsActive = true
        );
        insert UD;

        inventoryRequired = new Inventory_Required__c(
                Name = 'Inventory',
                Site__c = s.Id,
                Doses_per_Item__c = 10,
                Existing_Boxes__c = 1,
                Existing_Doses__c = 10,
                Quantity_Required__c = 1
        );
        insert inventoryRequired;

        inventory = new Inventory__c(
                Name = 'Inventory',
                SiteName__c = s.Id,
                Expiration_Date__c = date.newinstance(1960, 2, 17),
                Total_Doses__c = 10,
                isPartial__c = False,
                Batch_Number__c = '1234',
                Available__c = True
        );
        insert inventory;

        inventory2 = new Inventory__c(
                Name = 'Invent',
                SiteName__c = s.Id,
                Total_Doses__c = 10,
                isPartial__c = False,
                Batch_Number__c = '12345',
                Available__c = True
        );
        insert inventory2;
    }
    public static void generateTestDataCons() {
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

        pD = [SELECT Id FROM Profile WHERE Name = 'Partner Community User - Clone - Doctor' LIMIT 1];
        system.debug(pD.Id);
        UD = new User(
                ProfileId  = pd.Id,
                LastName = 'LastD',
                FirstName='JamesD',
                Alias = 'jlasD',
                Email = 'test@test.testD',
                Username = 'test@iqarus.iqarusD',
                CommunityNickname = 'testUser123D',
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ContactId = contD.Id,
                LocaleSidKey = 'en_US',
                IsActive = true
        );
        insert UD;

        consumableRequired = new Consumable_Required__c(
                Name = 'Consumable',
                Site__c = s.Id,
                Existing_Boxes__c = 1,
                Quantity_Required__c = 1
        );
        insert consumableRequired;

/*        inventoryPart = new Inventory__c(
                Name = 'Inventory',
                SiteName__c = s.Id,
                Total_Doses__c = 10,
                isPartial__c = True,
                Batch_Number__c = '12345'
        );*/

        consumable = new Consumable__c(
                Name = 'Consumable',
                Site__c = s.Id,
                Batch_Number__c = '1234',
                Available__c = True
        );
        insert consumable;

        consumable2 = new Consumable__c(
                Name = 'Consumable',
                Site__c = s.Id,
                Batch_Number__c = '12345',
                Available__c = True
        );
        insert consumable2;
    }

    static testMethod void testBehavior () {
        generateTestData();
        test.startTest();
        system.runAs(UD){
            system.assertNotEquals(InventoryReportCtrl.getList ('Inventory'), Null);
        }
        test.stopTest();
    }

    static testMethod void testBehavior2() {
        generateTestDataC();
        test.startTest();
        system.runAs(UD){
            system.assertNotEquals(InventoryReportCtrl.getList ('Inventory'), Null);
        }
        test.stopTest();
    }
    static testMethod void testBehaviorC() {
        generateTestDataCons();
        test.startTest();
        system.runAs(UD){
            system.assertNotEquals(InventoryReportCtrl.getConsList ('Consumable'), Null);
        }
        test.stopTest();
    }

}