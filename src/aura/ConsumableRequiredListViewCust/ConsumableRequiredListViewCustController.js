/**
 * Created by Adelchi on 21/05/2018.
 */
/**
 * Created by Adelchi on 14/05/2018.
 */
({
    doInit: function (component, event, helper) {
        var action = component.get("c.getRequirementList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set("v.consumableList", response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
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
    },
/*

    passName: function (component, event, helper) {
        var rec = event.getSource();
        var compEvent = $A.get("e.consumableSelected");
        compEvent.setParams({consumableId: rec.get("v.value")});
    },
*/

    passName : function(component, event, helper) {
        var rec = event.getSource();
        console.log('pass name Event'+rec.get("v.value"));
        var cmpEvent = component.getEvent("consId");
        console.log('event validity--'+cmpEvent);
        cmpEvent.setParams({
            consumableId : rec.get("v.value")
        });
        cmpEvent.fire();
    }
})