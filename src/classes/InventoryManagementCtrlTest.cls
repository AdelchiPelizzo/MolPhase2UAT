/**
 * Created by Adelchi on 26/05/2018.
 */

@IsTest
private class InventoryManagementCtrlTest {
    public static Account a ;
    public static Account a1 ;
    public static Site__c s;
    public static User UD;
    public static Contact contD;
    public static Consultation__c c;
    public static Inventory_Required__c inventoryRequired;
    public static Inventory__c inventoryPart;
    public static Consumable_Required__c consumableRequired;
    public static Consumable__c consumable;
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
    }
    public static void generateTestDataC(){
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
    }
    static testMethod void testBehavior () {
        generateTestData();
        test.startTest();
        system.runAs(UD){
            Integer beforeList = [SELECT count() FROM Inventory__c];
            String invReqId = inventoryRequired.Id;
            Decimal qTy = (Decimal)1;
            Decimal qTy2 = (Decimal)2;
            String d = String.valueOf(Date.newInstance(2010, 01, 01));
            InventoryManagementCtrl.addItems(invReqId, qTy, '12345', d);/*String medId, Decimal Quantity, String batchNumber, String expireDate*/
            Integer afterList = [SELECT count() FROM Inventory__c];
            system.assertEquals(beforeList, 0);
            system.assertEquals(afterList, 1);
            InventoryManagementCtrl.addItems(invReqId, qTy2, '12345', d);/*String medId, Decimal Quantity, String batchNumber, String expireDate*/
            afterList = [SELECT count() FROM Inventory__c];
            system.assertEquals(afterList, 3);
            InventoryManagementCtrl.removeMedItems(invReqId, qTy, 'used', 'box', '12345');
            system.assertEquals(afterList, 3);
            insert inventoryPart;
            InventoryManagementCtrl.removeMedItems(invReqId, qTy, 'used', 'dose', '12345');
            system.assertEquals(afterList, 3);
            List<String> batchList = InventoryManagementCtrl.getBatchNumList(invReqId);
            system.assert(batchList.size()>0);
        }
        test.stopTest();
    }

    static testMethod void testBehaviorC () {
        generateTestDataC();
        test.startTest();
        system.runAs(UD){
            Integer beforeList = [SELECT count() FROM Consumable__c];
            String consReqId = consumableRequired.Id;
            Decimal qTy = (Decimal)1;
            Decimal qTy2 = (Decimal)2;
            String d = String.valueOf(Date.newInstance(2010, 01, 01));
            InventoryManagementCtrl.addConsumable(consReqId, qTy, '12345', d);
            Integer afterList = [SELECT count() FROM Consumable__c];
            system.assertEquals(beforeList, 0);
            system.assertEquals(afterList, 1);
            InventoryManagementCtrl.addConsumable(consReqId, qTy2, '12345', d);
            afterList = [SELECT count() FROM Consumable__c];
            system.assertEquals(afterList, 3);
            InventoryManagementCtrl.removeConsItems(consReqId, qTy, '12345','used');
            system.assertEquals(afterList, 3);
            List<String> consBatchList = InventoryManagementCtrl.getConsBatchNumList(consReqId);
            system.assert(consBatchList.size()>0);
        }
        test.stopTest();
    }
}