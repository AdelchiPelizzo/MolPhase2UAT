/**
 * Created by Adelchi on 21/05/2018.
 */
({

    afterRender : function(component, helper){
        var afterRend = this.superAfterRender();
        var exBox = component.find("existing-boxes");
        var exBox1 = component.find("required-boxes");
        console.log('element exBox'+exBox[0].get('v.value'));
        var i;
        for (i=0; i<exBox.length; i++){
            if(exBox[i].get('v.value')<exBox1[i].get('v.value')){
                $A.util.addClass(exBox[i], 'warning');
            }
        }
        return afterRend;
    }
})