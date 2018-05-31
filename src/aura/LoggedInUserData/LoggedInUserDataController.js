/**
 * Created by Adelchi on 23/03/2018.
 */
({
    doInit: function(cmp){
        console.log('start do init');
        var action = cmp.get("c.getUserName");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.Name", response.getReturnValue());
            }
        });
        var action1 = cmp.get("c.getSiteName");
        console.log('start action 1');
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log('inside action 1 - State >>> '+ state);
            if (state === "SUCCESS") {
                cmp.set("v.assignedSite", response.getReturnValue());
                console.log('Response value - Site name >>> '+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    },

    changeSte: function(component, event, helper){
        window.setTimeout(helper.changeSiteN(component), 5000);
    },

    changeSite: function(component, event, helper){
        console.log('inside change site');
/*        var c = event.currentTarget.getAttribute("data-value");
        /!*var target = event.getSource().getAttribute('data-value');*!/
        console.log('target value >> '+c);
        if(c != "false"){*/
            var action = component.get("c.setSiteName");
            var site = component.get("v.Site.val");
            console.log('Hello Site >> '+site);
            action.setParams({
                siteId : component.get("v.Site.val")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "Hippie - Your Site was reassigned."
                    });
                    resultsToast.fire();
                } else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saving Error",
                        "message": "Please make sure you entered values correctly."
                    });
                    resultsToast.fire();
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            });
            $A.enqueueAction(action);
            $A.get('e.force:refreshView').fire();
            /*
            event.currentTarget.setAttribute("data-value", "false");
        }else{
            event.currentTarget.setAttribute("data-value", "true");
        }*/
    }
})