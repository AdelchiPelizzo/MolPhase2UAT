/**
 * Created by Adelchi on 20/05/2018.
 */
({

    afterRender : function(component, helper){
        var afterRend = this.superAfterRender();
        var exBox = component.find("existing-boxes");
        var exBox1 = component.find("required-boxes");
        var exBox2 = component.find("existing-doses");
        var exBox3 = component.find("required-doses");
        console.log('element exBox'+exBox[0].get('v.value'));
        var i;
        for (i=0; i<exBox.length; i++){
            if(exBox[i].get('v.value')<exBox1[i].get('v.value')){
                $A.util.addClass(exBox[i], 'warning');
            }
            if(exBox2[i].get('v.value')<exBox3[i].get('v.value')){
                $A.util.addClass(exBox2[i], 'warning');
            }
        }
        return afterRend;
        /*var i;
            for(i=0; i<exBox.length; i++){
                console.log("  <<<values " + exBox.length);
            }*/
    /*$A.util.addClass(exBox1, 'warning');
    $A.util.addClass(exBox2, 'warning');
    $A.util.addClass(exBox3, 'warning');*/
    }
})