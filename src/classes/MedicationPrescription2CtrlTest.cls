/**
 * Created by Adelchi on 27/05/2018.
 */

@IsTest
private class MedicationPrescription2CtrlTest {
    public static Account a ;
    public static Account a1 ;
    public static Site__c s;
    public static User UD;
    public static Contact contD;
    public static Consultation__c c;
    public static Inventory_Required__c inventoryRequired;
    public static Inventory__c inventoryPart;
    public static Inventory__c inventory;
    public static Consumable_Required__c consumableRequired;
    public static Consumable__c consumable;
    public static Profile pD;
    public static Medication_Prescribed__c prescribedMed;

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
                Contract_Employer__c = a1.Id,
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

        c = new Consultation__c(
                Status__c = 'In Progress',
                shift__c = 'Day',
                Disposal__c = 'Advice Only',
                Operator__c = a1.Id,
                Site__c = s.Id,
                CreatedDate = datetime.newInstance(2018,01,02)
        );
        insert c;

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
                Available__c = True,
                Name = 'Inventory',
                SiteName__c = s.Id,
                Total_Doses__c = 10,
                isPartial__c = True,
                Batch_Number__c = '12345'
        );
        insert inventoryPart;

        inventory = new Inventory__c(
                Available__c = True,
                Name = 'Inventory',
                SiteName__c = s.Id,
                Total_Doses__c = 10,
                isPartial__c = False,
                Batch_Number__c = '12345'
        );
        insert inventory;

        prescribedMed = new Medication_Prescribed__c(
                Batch_Number__c = '12345',
                Consultation__c = c.Id,
                prescriptionMode__c = 'box',
                Quantity_Prescribed__c = 1,
                Medication_Name__c = 'Inventory'
        );
        insert prescribedMed;
    }

    static testMethod void testBehavior () {
        generateTestData();
        test.startTest();
        system.runAs(UD){
            String invId = inventoryRequired.Id;
            String medId = prescribedMed.Id;
            String medNam = prescribedMed.Medication_Name__c;
            system.debug(invId);
            Integer qTy = 1;
            Integer qTy2 = 2;
            system.assert(MedicationPrescription2Ctrl.getBatchNumList(invId, 'box', qTy).size() > 0);
            MedicationPrescription2Ctrl.setExistingQuantity(medId, medNam);
            system.assert(inventoryRequired.Existing_Boxes__c > 0);
            /*String medPId, String consultId, String InventoryName, String batchN, Decimal qty, String prescriptionMode*/
            MedicationPrescription2Ctrl.getInventoryItem(medId, c.Id, 'Inventory', '12345',(Decimal)qty, 'box');
            system.assert(MedicationPrescription2Ctrl.getRequired(s.Id).size()>0);
        }
        system.runAs(UD){
            String invId = inventoryRequired.Id;
            system.debug(invId);
            Integer qTy = 1;
            Integer qTy2 = 2;
            system.assert(MedicationPrescription2Ctrl.getBatchNumList(invId, 'dose', qTy).size() > 0);
        }
        test.stopTest();
    }
}