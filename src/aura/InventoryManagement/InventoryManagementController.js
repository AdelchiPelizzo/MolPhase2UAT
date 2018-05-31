/**
 * Created by Adelchi on 16/04/2018.
 */
({
    doInit: function(component, event, helper) {
        console.log('Start Init');
        var action = component.get("c.getMedicationList");
        console.log('Action set');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Start Callback'+state);
            if (state === "SUCCESS") {
                console.log('Inside Callback');
                /*component.set("v.medicationNames", response.getReturnValue());*/
                console.log('Return Value Callback'+JSON.stringify(response.getReturnValue()));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        var action1 = component.get("c.getConsumablesList");
        console.log('Action set');
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Start Callback'+state);
            if (state === "SUCCESS") {
                console.log('Inside Callback');
                /*component.set("v.consumablesNames", response.getReturnValue());*/
                console.log('Return Value Callback'+JSON.stringify(response.getReturnValue()));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    },
    setMedicationName: function(component, event, helper) {
        var medName = event.getSource().get("v.value");
        console.log(medName);
        component.set("v.InventoryName", medName);
    },

    setConsumableName: function(component, event, helper) {
        var consName = event.getSource().get("v.value");
        console.log(consName);
        component.set("v.consumableName", consName);
    },
    StoreBatchNumber: function(component, event, helper) {
        var bNumb = event.getSource().get("v.value");
        component.set("v.BatchNr", bNumb);
    },

    StoreExpDate: function(component, event, helper) {
        var exDate = event.getSource().get("v.value");
        component.set("v.ExpirationDate", exDate);
    },
    addItem: function(component, event, helper) {
        var invId = component.get("v.InventoryName.val");
        console.log(invId);
        var invName = component.get("v.InventoryName.text");
        console.log(invName);
        var invQty = component.get("v.InventoryQty");
        console.log(invQty);
        var batchNr = component.get("v.batchNumber");
        console.log(batchNr);
        var exDat = component.get("v.ExpirationDate");
        console.log(exDat);
        var action = component.get("c.addItems");
        action.setParams({ medId : invId, Quantity : invQty, batchNumber : batchNr, expireDate : exDat });
        console.log(action.getParams());
        action.setCallback(this, function(response) {
            console.log("inside call back started");
            var state = response.getState();
            console.log("inside call back started >>>  "+state);
            var resultsToast = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Records saved successfully."
                });
                resultsToast.fire();
            } else if (state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Error message: " +
                            errors[0].message
                        });
                        resultsToast.fire();
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
        component.find("InventoryQty").set("v.value", "");
        component.find("MedSelect2").set("v.value", "");
        component.find("MedSelect3").set("v.value", "");
        helper.closeMe();
    },

    addConsumableItem: function(component, event, helper) {
        var consName = component.get("v.consumableName.val");
        console.log(consName);
        var consQty = component.get("v.consQty");
        console.log(consQty);
        var batchNr = component.get("v.consBatchNr");
        console.log(batchNr);
        var exDat = component.get("v.consExpirationDate");
        console.log(exDat);
        var action = component.get("c.addConsumable");
        action.setParams({ consId : consName, Quantity : consQty, batchNumber : batchNr, expireDate : exDat });
        action.setCallback(this, function(response) {
            console.log("inside call back started");
            var state = response.getState();
            console.log("inside call back started >>>  "+state);
            var resultsToast = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Records saved successfully."
                });
                resultsToast.fire();
            } else if (state === "No Items are Available with this Batch Number!") {
                console.log("No Items are Available with this Batch Number!");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "No Items are Available with this Batch Number!"
                });
                resultsToast.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Error message: " +
                            errors[0].message
                        });
                        resultsToast.fire();
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
        component.find("consumablesQty").set("v.value", "");
        component.find("consumable1").set("v.value", "");
        component.find("consumable2").set("v.value", "");
        helper.closeMe();
    },

    removeItems: function(component, event, helper){
        var invId = component.get("v.InventoryName.val");
        console.log('inventory Id'+invId);
        var invName = component.get("v.InventoryName.text");
        console.log('inventory name'+invName);
        var invQty = component.get("v.InventoryQty");
        console.log('inventory qty'+invQty);
        var batchNum = component.get("v.batchNumber");
        console.log('batch number'+batchNum);
        var remMode = component.get("v.valueMode");
        console.log('removal mode'+remMode);
        var remReas = component.get("v.removalReason");
        console.log('removal reason'+remReas);
        var action = component.get("c.removeMedItems");
        action.setParams({ medId : invId, Quantity : invQty, removalReason : remReas, modeRemoval : remMode , batchNr : batchNum });
        console.log(action.getParams());
        action.setCallback(this, function(response) {
            console.log("inside call back started");
            var state = response.getState();
            console.log("inside call back started >>>  "+state);
            var resultsToast = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Records saved successfully."
                });
                resultsToast.fire();
            } else if (state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Error message: " +
                            errors[0].message
                        });
                        resultsToast.fire();
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
        component.find("InventoryQty2").set("v.value", "");
        component.find("MedSelect22").set("v.value", "");
        component.find("MedSelect32").set("v.value", "");
        component.find("InventoryQty").set("v.value", "");
        component.find("MedSelect2").set("v.value", "");
        component.find("MedSelect3").set("v.value", "");
        helper.closeMe();
    },

    removeConsumableItems: function(component, event, helper){
        var conId = component.get("v.consumableName.val");
        var consName = component.get("v.InventoryName.text");
        var invQty = component.get("v.consQty");
        var batchNum = component.get("v.consBatchNr");
        var remReas = component.get("v.removalReason");
        var action = component.get("c.removeConsItems");
        action.setParams({ consId : conId, Quantity : invQty, batchNumber : batchNum,  removalReason : remReas });
        action.setCallback(this, function(response) {
            console.log("inside call back started");
            var state = response.getState();
            console.log("inside call back started >>>  "+state);
            var resultsToast = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "Records saved successfully."
                });
                resultsToast.fire();
            } else if (state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Error message: " +
                            errors[0].message
                        });
                        resultsToast.fire();
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
        component.find("consumablesQty").set("v.value", "");
        component.find("consumable1").set("v.value", "");
        component.find("consumable2").set("v.value", "");
        component.find("consumablesQty2").set("v.value", "");
        component.find("consumable12").set("v.value", "");
        component.find("consumable22").set("v.value", "");
        helper.closeMe();
        console.log(component.find("consumablesQty").get("v.value")+component.find("consumable1").get("v.value")+component.find("consumable2").get("v.value"));

    },

    toggleRemoveView: function(component, event, helper){
        if(component.get("v.removalToggle")){
            component.set("v.removalToggle", false);
        }else{
            component.set("v.removalToggle", true);
        }
        if(component.get("v.addToggle")){
            component.set("v.addToggle", false);
        }
    },

    toggleAddView: function(component, event, helper){
        if(component.get("v.addToggle")){
            component.set("v.addToggle", false);
        }else{
            component.set("v.addToggle", true);
        }
        if(component.get("v.removalToggle")){
            component.set("v.removalToggle", false);
        }
    },

    handleChangeMode: function(component, event, helper){
        var val = event.getSource().get('v.value');
        component.set('v.valueMode', val);
        console.log(val);
    },

    batchNumberListCons: function(component, event, helper){
        var consumId = component.get("v.consumableName.val");
        var action = component.get("c.getConsBatchNumList");
        action.setParams({
            consId : consumId
        });
        action.setCallback(this, function(response) {
            console.log('call back started ....');
            var state = response.getState();
            console.log(state);
            console.log('response state <<>> '+state+'  results >> '+response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.consBatchNrList", response.getReturnValue());
            }
            else if(state === "ERROR"){
                var errors = response.getError();
                console.log('error handling started ....');
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log('error message ....'+errors[0].message);
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Not Available"+errors[0].message,
                        });
                        resultsToast.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    batchNumberList: function(component, event, helper){
        var mId = component.get("v.InventoryName.val");
        var action = component.get("c.getBatchNumList");
        action.setParams({
            medId : mId
        });
        action.setCallback(this, function(response) {
            console.log('call back started ....');
            var state = response.getState();
            console.log(state);
            console.log('response state <<>> '+state+'  results >> '+response.getReturnValue());
            if(state === "SUCCESS"){
                component.set("v.batchNumberList", response.getReturnValue());
            }
            else if(state === "ERROR"){
                var errors = response.getError();
                console.log('error handling started ....');
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log('error message ....'+errors[0].message);
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Error",
                            "message": "Not Available"+errors[0].message,
                        });
                        resultsToast.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    storeBatchNumber: function(component, event, helper){
        var val = event.getSource().get('v.value');
        component.set('v.batchNumber', val);
    },

    storeConsBatchNumber: function(component, event, helper){
        var val = event.getSource().get('v.value');
        component.set('v.consBatchNr', val);
    },
})