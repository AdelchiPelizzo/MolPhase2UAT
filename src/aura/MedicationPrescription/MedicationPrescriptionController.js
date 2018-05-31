({
    doInit: function(component, event, helper) {
        console.log(" do init started ...");
        component.find("medicationRecordCreator").getNewRecord(
            "Medication_Prescribed__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newMedication");
                var error = component.get("v.newMedicationError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }else{
                    console.log("Record template initialized: " +  JSON.stringify(rec) );
                }
            })
        );
    },

    cancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    storeMedicationName: function(component, event, helper){
        console.log("Inside storeMedicationName >>> val  "+val);
        var val = component.get("v.selItem3.val");
        /*var val = event.getSource().get('v.value');*/
        component.set('v.medicationName', val);
        console.log("inside storeMedicationName"+component.get("v.medicationName"));
        helper.getNumbers(component, event);
    },

    getBatchNumberList: function(component, event, helper){
        var test = component.isValid();
        console.log("inside getBatchNumberList get Numbers----"+test);
        var medNam = component.get("v.medicationName.text");
        console.log("inside getBatchNumberList get Numbers ---"+medNam);
        var medId = component.get("v.medicationName.val");
        console.log("inside getBatchNumberList get Id ---"+medId);
        var prescrMode = component.get("v.valueMode");
        var action = component.get("c.getBatchNumList");
        console.log("inside getBatchNumberList get Numbers -----"+action);
        action.setParams({
            medId : medId,
            prescriptionMode : prescrMode
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

    storeQty: function(component, event, helper){
        var val = event.getSource().get('v.value');
        component.set('v.qtyPrescribed', val);
    },

    handleSavePrecription: function(component, event, helper) {
        var medPId = '';
        component.set("v.simpleNewMedication.Consultation__c", component.get("v.recordId"));
        component.set("v.simpleNewMedication.prescriptionMode__c", component.get("v.valueMode"));
        component.set("v.simpleNewMedication.Medication_Name__c", component.get("v.medicationName.text"));
        component.set("v.simpleNewMedication.Quantity_Prescribed__c", component.get("v.qtyPrescribed"));
        component.set("v.simpleNewMedication.Prescription_Frequency__c", component.get("v.presFrequency"));
        component.set("v.simpleNewMedication.Prescriber__c", component.get("v.selItem2.val"));
        component.set("v.simpleNewMedication.Batch_Number__c", component.get("v.batchNumber"));
        var action = component.get("c.setExistingQuantity");
        var name = component.get('v.medicationName.text');
        component.find("medicationRecordCreator").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS") {
                component.set("v.medPresId", saveResult.recordId);
                medPId = saveResult.recordId;
                /*var action = component.get("c.setExistingQuantity");
                console.log('action ----'+action);*/
                /*action.setStorable();*/
                action.setParams({
                    prescribedMedId : medPId,
                    medName : name
                });
                console.log('action built ...'+action.getParams());
                /*action.setCallback(this, function(response) {
                    console.log('inside call back ');
                    var state = response.getState();
                    console.log('inside call back state ----> '+state);
                    if(state === "SUCCESS"){console.log('updated inventory');}
                    if(state === "ERROR"){
                        var errors = response.getError();
                        if(errors){
                            if(errors[0] && errors[0].message){
                                console.log('error message ....'+errors[0].message);
                                var resultsToast = $A.get("e.force:showToast");
                                resultsToast.setParams({
                                    "title": "Error",
                                    "message": errors[0].message,
                                });
                                resultsToast.fire();
                            }
                        }
                    }
                });*/
                $A.enqueueAction(action);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success",
                    "message": "Medication Record has been created."
                });
                resultsToast.fire();
            }else{
                alert('Make sure ALL fields are filled in');
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "message": "Make sure ALL fields are filled in."
                });
                resultsToast.fire();
                return;

            }
        }));
        $A.get("e.force:closeQuickAction").fire();
    },

    handleChangeMode: function(component, event, helper){
        var val = event.getSource().get('v.value');
        component.set('v.valueMode', val);
        console.log(val);
    }
})