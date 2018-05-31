/**
 * Created by Adelchi on 17/04/2018.
 */
({
    closeMe : function(component, event, helper)  {
        var btnCopy = document.getElementsByClassName("slds-pill__remove");
        var i;
        for(i=0; i<btnCopy.length; i++){
            btnCopy[i].click();
        }
    }
})