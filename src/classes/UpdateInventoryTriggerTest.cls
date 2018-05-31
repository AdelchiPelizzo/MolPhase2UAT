/**
 * Created by Adelchi on 25/05/2018.
 */
@isTest(SeeAllData=true)
private class UpdateInventoryTriggerTest {
    public static Account a ;
    public static Account a1 ;
    public static Site__c s;
    public static User UD;
    public static Contact contD;
    public static Inventory__c Inventory;
    public static Inventory__c InventoryPartial;
    public static Inventory__c InventoryPartial2;
    public static Medication_Prescribed__c medPrescribed;
    public static Medication_Prescribed__c medPrescribed2;
    public static Medication_Prescribed__c medPrescribed3;
    public static Medication_Prescribed__c medPrescribed4;
    public static Consultation__c c;
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

        Inventory = new Inventory__c(
                Name = 'Inventory',
                Available__c = True,
                Batch_Number__c = '12345',
                SiteName__c = s.Id,
                Total_Doses__c = 10
        );
        insert Inventory;

        InventoryPartial = new Inventory__c(
                Name = 'Inventory',
                Available__c = True,
                Batch_Number__c = '12345',
                SiteName__c = s.Id,
                Total_Doses__c = 7,
                isPartial__c = True
        );
        insert InventoryPartial;

        InventoryPartial2 = new Inventory__c(
                Name = 'Inventory',
                Available__c = True,
                Batch_Number__c = '12345',
                SiteName__c = s.Id,
                Total_Doses__c = 1,
                isPartial__c = True
        );
        insert InventoryPartial2;

        c = new Consultation__c(
                Status__c = 'In Progress',
                shift__c = 'Day',
                Disposal__c = 'Advice Only',
                Operator__c = a1.Id,
                Site__c = s.Id,
                CreatedDate = datetime.newInstance(2018,01,02)
        );
        insert c;

        medPrescribed = new Medication_Prescribed__c(
                Quantity_Prescribed__c = 1,
                prescriptionMode__c = 'box',
                Batch_Number__c = '12345',
                Medication_Name__c = Inventory.Name,
                Consultation__c = c.Id,
                Inventory__c = Inventory.Id
        );

        medPrescribed2 = new Medication_Prescribed__c(
                prescriptionMode__c = 'dose',
                Quantity_Prescribed__c = 7,
                Batch_Number__c = '12345',
                Medication_Name__c = Inventory.Name,
                Consultation__c = c.Id,
                Inventory__c = Inventory.Id
        );

        medPrescribed3 = new Medication_Prescribed__c(
                prescriptionMode__c = 'dose',
                Quantity_Prescribed__c = 5,
                Batch_Number__c = '12345',
                Medication_Name__c = Inventory.Name,
                Consultation__c = c.Id,
                Inventory__c = Inventory.Id
        );

        medPrescribed4 = new Medication_Prescribed__c(
                prescriptionMode__c = 'dose',
                Quantity_Prescribed__c = 9,
                Batch_Number__c = '12345',
                Medication_Name__c = Inventory.Name,
                Consultation__c = c.Id,
                Inventory__c = Inventory.Id
        );
    }

    public static void generateTestData2(){
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

        Inventory = new Inventory__c(
                Name = 'Inventory',
                Available__c = True,
                Batch_Number__c = '12345',
                SiteName__c = s.Id,
                Total_Doses__c = 10
        );
        insert Inventory;

        c = new Consultation__c(
                Status__c = 'In Progress',
                shift__c = 'Day',
                Disposal__c = 'Advice Only',
                Operator__c = a1.Id,
                Site__c = s.Id,
                CreatedDate = datetime.newInstance(2018,01,02)
        );
        insert c;

        medPrescribed = new Medication_Prescribed__c(
                Quantity_Prescribed__c = 1,
                prescriptionMode__c = 'dose',
                Batch_Number__c = '12345',
                Medication_Name__c = Inventory.Name,
                Consultation__c = c.Id,
                Inventory__c = Inventory.Id
        );
    }

    static testMethod void testBehavior () {
        generateTestData();
        test.startTest();
        system.runAs(UD){
            insert medPrescribed;
            Inventory__c i = [SELECT Available__c, Removal_Reason__c FROM Inventory__c WHERE Id =: Inventory.Id LIMIT 1];
            system.assertEquals(i.Available__c, False);
            system.assertEquals(i.Removal_Reason__c, 'Used');
            system.assertEquals(medPrescribed.Inventory__c, i.Id);
        }
        test.stopTest();
    }
    static testMethod void testBehavior2 () {
        generateTestData();
        test.startTest();
        system.runAs(UD) {
            insert medPrescribed2;
            Inventory__c i = [SELECT Available__c, Removal_Reason__c, Total_Doses__c FROM Inventory__c WHERE Id =: Inventory.Id LIMIT 1];
            system.assertEquals(i.Available__c , True);
            system.assertEquals(i.Total_Doses__c , 10);
            system.assertEquals(medPrescribed2.Inventory__c , i.Id);
        }
        test.stopTest();
    }
    static testMethod void testBehavior3 () {
        generateTestData();
        test.startTest();
        system.runAs(UD) {
            insert medPrescribed3;
            Inventory__c i = [SELECT Id, Available__c, Removal_Reason__c, Total_Doses__c FROM Inventory__c WHERE Id =: Inventory.Id LIMIT 1];
            system.assertEquals(i.Available__c , True);
            system.assertEquals(i.Removal_Reason__c , '-');
            system.assertEquals(i.Total_Doses__c , 10);
            system.assertEquals(medPrescribed3.Inventory__c , i.Id);
        }
        test.stopTest();
    }
    static testMethod void testBehavior4 () {
        generateTestData();
        test.startTest();
        system.runAs(UD) {
            insert medPrescribed4;
            system.assertEquals(Inventory.Available__c , True);
            system.assertEquals(Inventory.Removal_Reason__c , Null);
            system.assertEquals(Inventory.Total_Doses__c , 10);
            system.assertEquals(medPrescribed4.Inventory__c , Inventory.Id);
        }
        test.stopTest();
    }

    static testMethod void testBehavior5 () {
        generateTestData2();
        test.startTest();
        system.runAs(UD) {
            insert medPrescribed;
            system.assertEquals(Inventory.Available__c , True);
            system.assertEquals(Inventory.Removal_Reason__c , Null);
            system.assertEquals(Inventory.Total_Doses__c , 10);
            system.assertEquals(medPrescribed.Inventory__c , Inventory.Id);
        }
        test.stopTest();
    }
}