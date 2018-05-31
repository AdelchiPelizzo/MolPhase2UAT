/**
 * Created by Adelchi on 16/04/2018.
 */

public with sharing class InventoryManagementCtrl {
    public static Inventory__c newInventory;
    public static List<String> inventoryNames;
    public static List<String> consumablesNames;
    public static Inventory_Required__c invReq;
    public static Consumable_Required__c consReq;

    @AuraEnabled
    public static void addItems(String medId, Decimal Quantity, String batchNumber, String expireDate){
        Date expiringDate = date.valueOf(expireDate);
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        String medName = [SELECT Name FROM Inventory_Required__c WHERE Id =: medId LIMIT 1].Name;
        invReq = [SELECT Name, Quantity_Required__c, Total_Doses_Required__c, Doses_per_Item__c, Existing_Boxes__c, Existing_Doses__c,  Group__c  FROM Inventory_Required__c WHERE Id =: medId LIMIT 1];
        system.debug(medName);
        if(Quantity > 1){
            List<Inventory__c> newInventories = new List<Inventory__c>();
            system.debug('Inside first Loop');
            for(Integer i=0; i<Quantity; i++ ){
                Inventory__c newInventory  = new Inventory__c();
                newInventory.Total_Doses__c = invReq.Doses_per_Item__c;
                newInventory.Name = medName;
                newInventory.Batch_Number__c = batchNumber;
                newInventory.Expiration_Date__c = expiringDate;
                newInventory.SiteName__c = siteId;
                newInventory.Available__c = True;
                newInventory.Inventory_Required__c = medId;
                invReq.Existing_Boxes__c += 1;
                invReq.Existing_Doses__c += invReq.Doses_per_Item__c;
                newInventories.add(newInventory);
            }
            update invReq;
            insert newInventories;
        }else if(Quantity == 1){
            system.debug('Inside second Loop');
            Inventory__c newInventory  = new Inventory__c();
            newInventory.Total_Doses__c = invReq.Doses_per_Item__c;
            newInventory.Name = medName;
            newInventory.Batch_Number__c = batchNumber;
            newInventory.Expiration_Date__c = expiringDate;
            newInventory.SiteName__c = siteId;
            newInventory.Available__c = True;
            newInventory.Inventory_Required__c = medId;
            invReq.Existing_Boxes__c += 1;
            invReq.Existing_Doses__c += invReq.Doses_per_Item__c;
            update invReq;
            insert newInventory;
        }
    }

    @AuraEnabled
    public static void addConsumable(String consId, Decimal Quantity, String batchNumber, String expireDate){
        Date expiringDate = date.valueOf(expireDate);
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        String consName = [SELECT Name FROM Consumable_Required__c WHERE Id =: consId LIMIT 1].Name;
        consReq = [SELECT Name, Quantity_Required__c, Existing_Boxes__c FROM Consumable_Required__c WHERE Id =: consId LIMIT 1];
        system.debug(consName);
        if(Quantity > 1){
            List<Consumable__c> newConsumables = new List<Consumable__c>();
            for(Integer i=0; i<Quantity; i++ ){
                Consumable__c newConsumable  = new Consumable__c();
                newConsumable.Name = consName;
                newConsumable.Batch_Number__c = batchNumber;
                newConsumable.Expiration_Date__c = expiringDate;
                newConsumable.Site__c = siteId;
                newConsumable.Available__c = True;
                newConsumable.Consumable_Required__c = consId;
                consReq.Existing_Boxes__c += Quantity;
                newConsumables.add(newConsumable);
            }
            update consReq;
            insert newConsumables;
        }else if(Quantity == 1){
            system.debug('Inside second Loop');
            Consumable__c newConsumable  = new Consumable__c();
            newConsumable.Name = consName;
            newConsumable.Batch_Number__c = batchNumber;
            newConsumable.Expiration_Date__c = expiringDate;
            newConsumable.Site__c = siteId;
            newConsumable.Available__c = True;
            newConsumable.Consumable_Required__c = consId;
            consReq.Existing_Boxes__c += 1;
            update consReq;
            insert newConsumable;
        }
    }

/*    @AuraEnabled
    public static List<String> getMedicationList(){
        Medication_Prescribed__c mp = new Medication_Prescribed__c();
        inventoryNames = fetchPickList.getselectOptions(mp, 'Medication_Name__c');
        return inventoryNames;
    }


    @AuraEnabled
    public static List<String> getConsumablesList(){
        Medication_Prescribed__c mp = new Medication_Prescribed__c();
        consumablesNames = fetchPickList.getselectOptions(mp, 'Consumables__c');
        return consumablesNames;
    }*/

    @AuraEnabled
    public static void removeMedItems(String medId, Decimal Quantity, String removalReason, String modeRemoval, String batchNr){
        /*Date expiringDate = date.valueOf(expireDate);*/
        Integer qty = (Integer)Quantity;
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        String medName = [SELECT Name FROM Inventory_Required__c WHERE Id =: medId LIMIT 1].Name;
        system.debug(medName);
        system.debug(batchNr);
        system.debug(siteId);
        system.debug(qty);
        system.debug(modeRemoval);
        invReq = [SELECT Name, Quantity_Required__c, Total_Doses_Required__c, Doses_per_Item__c, Existing_Boxes__c, Existing_Doses__c,  Group__c FROM Inventory_Required__c WHERE Id =: medId LIMIT 1];
        Integer count = [SELECT Count() FROM Inventory__c WHERE Name =: medName AND SiteName__c =: siteId];
        List<Inventory__c> inventoryItems = [SELECT Id, Available__c, isPartial__c, Manual_Removal_Reason__c, Removal_Reason__c, Batch_Number__c, Expiration_Date__c FROM Inventory__c WHERE Name =: medName AND Available__c = TRUE AND Batch_Number__c =: batchNr AND SiteName__c =: siteId];
        system.debug(inventoryItems.size());
        List<Inventory__c> inventoryItemsPart = [SELECT Id, Available__c, isPartial__c, Manual_Removal_Reason__c, Removal_Reason__c, Batch_Number__c, Expiration_Date__c FROM Inventory__c WHERE Name =: medName AND isPartial__c = TRUE AND Batch_Number__c =: batchNr AND SiteName__c =: siteId];
        if(modeRemoval == 'box'){
            if(inventoryItems.size() >= qty){
                for(Integer i=0; i<qty; i++) {
                    system.debug('inside for loop ' + inventoryItems[i].Batch_Number__c);
                    inventoryItems[i].Available__c = False;
                    system.debug('inside for loop ' + inventoryItems[i].Available__c);
                    inventoryItems[i].Removal_Reason__c = 'Manually Removed';
                    system.debug('inside for loop ' + inventoryItems[i].Removal_Reason__c);
                    inventoryItems[i].Manual_Removal_Reason__c = removalReason;
                    system.debug('inside for loop ' + inventoryItems[i].Manual_Removal_Reason__c);
                    system.debug('inside for loop '+inventoryItems[i].Id);
                }
                update inventoryItems;
            }else{
                system.debug('Inventory List Size'+inventoryItems.size()+'<'+qty+' Quantity of Items Intended to be Removed');
            }
            invReq.Existing_Boxes__c -= qty;
            invReq.Existing_Doses__c -= qty*invReq.Doses_per_Item__c;
            update invReq;
        }else{
            if(!(inventoryItemsPart.size()<qty)){
                for(Integer i=0; i<qty; i++){
                    inventoryItems[i].Available__c = False;
                    inventoryItems[i].Removal_Reason__c = 'Manually Removed';
                    inventoryItems[i].Manual_Removal_Reason__c = removalReason;
                }
                update inventoryItemsPart;
            }else{
                system.debug('Inventory List Size < Quantity of Items Intended to be Removed');
            }
            invReq.Existing_Doses__c -= qty;
            update invReq;
        }
    }

    @AuraEnabled
    public static void removeConsItems(String consId, Decimal Quantity, String batchNumber, String removalReason){
        system.debug(consId+'---'+Quantity+'---'+batchNumber+'---'+removalReason);
        String userId = userInfo.getUserId();
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        String consName = [SELECT Name FROM Consumable_Required__c WHERE Id =: consId LIMIT 1].Name;
        consReq = [SELECT Name, Quantity_Required__c, Existing_Boxes__c FROM Consumable_Required__c WHERE Id =: consId LIMIT 1];
        Integer count = [SELECT Count() FROM Consumable__c WHERE Name =: consId AND Site__c =: siteId];
        List<Consumable__c> consumableItems = [SELECT Id, Available__c, Manual_Removal_Reason__c, Batch_Number__c, Expiration_Date__c FROM Consumable__c WHERE Name =: consName AND Available__c = TRUE AND Batch_Number__c =: batchNumber AND Site__c =: siteId];
        if(consumableItems.size() > (Integer)Quantity || consumableItems.size() == (Integer)Quantity){
            for(Integer i=0; i<(Integer)Quantity; i++) {
                consumableItems[i].Available__c = False;
                consumableItems[i].Manual_Removal_Reason__c = removalReason;
            }
            consReq.Existing_Boxes__c -= Quantity;
            system.debug(consReq.Existing_Boxes__c + Quantity);
            update consumableItems;
            update consReq;
        }else{
            system.debug('Consumables List Size'+consumableItems.size()+'<'+(Integer)Quantity+' Quantity of Items Intended to be Removed');
        }
    }

    @AuraEnabled
    public static List<String> getConsBatchNumList(String consId){
        String userId = userInfo.getUserId();
        system.debug(userId);
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        system.debug(contactId);
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        system.debug(siteId);
        String consName = [SELECT Name FROM Consumable_Required__c WHERE Id =: consId LIMIT 1].Name;
        List<String> batchNLst = new List<String>();
        List<Consumable__c> consLst = new List<Consumable__c>();
        consLst = [SELECT Batch_Number__c FROM Consumable__c WHERE Name =: consName AND Site__c =: siteId AND Available__c = TRUE];
        for(Integer i=0; i<consLst.size(); i++){
            batchNLst.add(consLst[i].Batch_Number__c);
        }
        return batchNLst;
    }

    @AuraEnabled
    public static List<String> getBatchNumList(String medId){
        String userId = userInfo.getUserId();
        system.debug(userId);
        String contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
        system.debug(contactId);
        String siteId = [SELECT Site__c FROM Contact WHERE Id =: contactId LIMIT 1].Site__c;
        system.debug(siteId);
        String medName = [SELECT Name FROM Inventory_Required__c WHERE Id =: medId LIMIT 1].Name;
        List<String> batchNLst = new List<String>();
        List<Inventory__c> medLst = new List<Inventory__c>();
        medLst = [SELECT Batch_Number__c FROM Inventory__c WHERE Name =: medName AND SiteName__c =: siteId AND Available__c = TRUE];
        for(Integer i=0; i<medLst.size(); i++){
            batchNLst.add(medLst[i].Batch_Number__c);
        }
        return batchNLst;
    }
}