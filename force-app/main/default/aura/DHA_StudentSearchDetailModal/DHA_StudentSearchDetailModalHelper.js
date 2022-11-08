({
	setdataTable : function(component, event, helper)
	{
		let action = component.get();
	},

	getstudentInfo : function(component, event, helper,studentId)
	{
		let action = component.get('c.getstudentInfo');
		action.setParams({
			"studentId" : studentId,
		});
        action.setCallback(this, function(response){
        let state = response.getState();
        if(state === "SUCCESS")
        {	
            try {
				component.set('v.studentInfo', response.getReturnValue()); // erroo
				console.log('set data ok');
			} catch (error) {
				console.log('erro in getstudentInfo : ', error);
			}       
        }
        else{
            console.log('Erro, state = ',state );
        }});
    	$A.enqueueAction(action);
	},

	getStudyResult: function(component, event, helper,studentId)
	{
		let action = component.get('c.getStudyResult');
		action.setParams({
			"studentId" : studentId,
		});
		action.setCallback(this, function(response)
		{
			
			let state = action.getState();
			if(state === "SUCCESS")
			{
				try {
					let return_value = response.getReturnValue();
					component.set("v.studyResult", return_value);
				} catch (error) {
					console.log('Error in getStudyResult : ', error);
				}
			}
		});
		$A.enqueueAction(action);
	},

	getDataTableStudyResult : function(component, event, helper,studentId)
	{
		let action = component.get('c.getDataTableStudyResult');
		action.setParams({
			"studentId" : studentId,
		});
		action.setCallback(this, function(response)
		{
			
			let state = action.getState();
			if(state === "SUCCESS")
			{
				try {
					let return_value = response.getReturnValue();
					component.set("v.studyResult[3]", return_value);
				} catch (error) {
					console.log('Error in getDataTableStudyResult : ', error);
				}
			}
		});
		$A.enqueueAction(action);
	}
})