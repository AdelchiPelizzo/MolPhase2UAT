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
                component.set("v.requirementList", response.getReturnValue());
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

    passName: function (component, event, helper) {
        var rec = event.getSource();
        console.log(rec.get("v.value"));
        component.set("v.reId", rec.get("v.value"));
        console.log(component.get("v.reId"));
    },


    handleSelectEvent: function (component, event, helper) {
        console.log('handleSelectEvent inventory required list');
        var consId = event.getParam("consumableId");
        component.set('v.reId', consId);
        console.log('handleSelectEvent inventory required list--- '+component.get("v.reId"));
    },

    doneRendering: function (component, event, helper) {
        var exBox = component.find("existing-boxes");
        var exBox1 = component.find("required-boxes");
        var exBox2 = component.find("existing-doses");
        var exBox3 = component.find("required-doses");
        console.log('element exBox'+exBox[0]);
        var i;
        for (i in exBox){
            $A.util.addClass(exBox[i], 'warning');
        }
        /*var i;
            for(i=0; i<exBox.length; i++){
                console.log("  <<<values " + exBox.length);
            }*/
        /*$A.util.addClass(exBox1, 'warning');
        $A.util.addClass(exBox2, 'warning');
        $A.util.addClass(exBox3, 'warning');*/

    }
})