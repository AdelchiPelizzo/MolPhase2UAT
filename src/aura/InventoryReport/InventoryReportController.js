/**
 * Created by Adelchi on 07/05/2018.
 */
({
    getReport: function (component, event, helper) {
        var sum = document.getElementById("sum");
        sum.className = "slds-is-expanded";
        console.log('init started ...');
        /*var nam = component.get('v.selItem2.text');*/
        var nam = component.get('v.medicationName');
        var action = component.get("c.getList");
        console.log('action initialization  started ...');
        action.setParams({
            searchTerm : nam
        });
        action.setCallback(this, function(response) {
            console.log('action callback initialization started ...');
            var state = response.getState();
            console.log('state ...'+ state);
            if (state === "SUCCESS") {
                console.log('response from server ---- '+JSON.stringify(response.getReturnValue()));
                component.set("v.report", response.getReturnValue());
                var report = component.get("v.report");
                var values = [];
                var values2 = [];
                var i;
                for(i=0; i<report.length; i++ ){
                    values.push(report[i].totBoxByNam);
                    values2.push(report[i].totalDoseName);
                }
                var sum = values.reduce( function(total, amount){
                    return total + amount
                });
                var sum2 = values2.reduce( function(total, amount){
                    return total + amount
                });
                component.set("v.sum", sum);
                component.set("v.sum2", sum2);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " report returned successfully."
                });
                toastEvent.fire();
            }else{
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    var message = errors[0].message;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": message
                    })};
                toastEvent.fire();
                var sum = document.getElementById("sum");
                sum.className = "slds-is-collapsed";
            }
        });
        $A.enqueueAction(action);
    },

    getSum : function(component, event, helper){
        var report = component.get("v.report");
        var values = [];
        var values2 = [];
        var i;
        for(i=0; i<report.length; i++ ){
            values.push(report[i].totBoxByNam);
            values2.push(report[i].totalDoseName);
        }
        var sum = values.reduce( function(total, amount){
            return total + amount
        });
        var sum2 = values2.reduce( function(total, amount){
            return total + amount
        });
        component.set("v.sum", sum);
        component.set("v.sum2", sum2);
        var cmpTarget = component.find('sum');
        $A.util.toggleClass(cmpTarget, 'slds-show');
    },


    passName: function (component, event, helper) {
        var name = event.getSource().get('v.value');
        component.set('v.medName', name);
    },

    passBatch: function (component, event, helper) {
        var bNum = event.getSource().get('v.value');
        component.set('v.batchNum', bNum);
    }
})