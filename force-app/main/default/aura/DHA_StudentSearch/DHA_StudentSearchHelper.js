({
	sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.data", data);
    },
    sortBy: function (field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
    getDataSearch : function(component, event){
        let action = component.get('c.searchStudent');
        action.setParams({
            "name" : component.get("v.studentName"),
            "birthday": component.get("v.birthday"),
        });

        action.setCallback(this,function(Response){
            let state = Response.getState();
            if(state === "SUCCESS")
            {
                component.set("v.data",Response.getReturnValue());
            }
            else{
                console.log('Erro, state = ',state );
            }
        });
        $A.enqueueAction(action);
    },

    get_datatable : function(component)
    {
        let action = component.get('c.getStudent');
        action.setCallback(this, function(response){
        let state = response.getState();
        if(state === "SUCCESS")
        {	
            component.set('v.data', response.getReturnValue());
            component.set('v.dataGlobal', response.getReturnValue());             
        }
        else{
            console.log('Erro, state = ',state );
        }         
    });
    $A.enqueueAction(action);
    
    },

    resetField: function(component){
       component.set('v.studentName', '');
       component.set('v.className', '');
       component.set('v.birthday', null);
    },
    
	getclass : function(component, event, helper) {
		let action = component.get('c.getClassName');
		action.setCallback(this, function(response)
		{
			let state = response.getState();
			if(state === "SUCCESS")
			{	
				component.set('v.classes', response.getReturnValue());               
			}
            else{
                console.log('fail');
            }         
		});
        $A.enqueueAction(action);
	},
    
    showtoast : function(component, event, helper)
    {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "type": "error",
        "message": "Please provide at least 1 condition to search for students."
    });
    toastEvent.fire();       
    },
    
    check_valid : function(component, event, helper){
        var allValid = component.find('field'); // get inputName & dropdown list
        var birthday = component.find('birthdayField'); // get birthday input
        
        if(allValid[0].get("v.value") == '' 
            && allValid[1].get("v.value") == '' 
            && birthday.get("v.value") == null ){
            helper.showtoast(component, event, helper);
            return false;
        }
        return true;
    },

    showDetails : function(component, event, helper, studentId)
    {
        try {
            component.set('v.studentId', studentId);
            component.set('v.isModalOpen', true);
            console.log('show model = true');
        } catch (error) {
            console.log('erro from helper Search ', error);
        }
    }
})