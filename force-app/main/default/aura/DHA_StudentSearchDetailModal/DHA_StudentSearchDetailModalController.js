({
	myAction : function(component, event, helper) {
		
	},
	changeState_studentInfo : function(component)
	{
		component.set('v.isexpanded_studentInfo', !component.get('v.isexpanded_studentInfo'));
	},

	changeState_studyResult : function(component)
	{
		component.set('v.isexpanded_studyResult', !component.get('v.isexpanded_studyResult'));
	},
	
	doInit : function(component,event, helper)
	{	
		// set colums datatable
		component.set('v.columns',
		[
            {label: 'Class', fieldName: 'DHA_Class_Assignment__r', type: 'text'},
            {label: 'Score 1', fieldName: 'Score_1__c', type: 'number'},
			{label: 'Score 2', fieldName: 'Score_2__c', type: 'number'},
			{label: 'Score 3', fieldName: 'Score_3__c', type: 'number'},
			{label: 'Final Score', fieldName: 'Final_Score__c', type: 'number'},
            {label: 'Result', fieldName: 'Result__c', type: 'text'}
		]);
		
        
		// get studentId
		var studentId = component.get('v.studentId');
		// get student info
		helper.getstudentInfo(component, event, helper,studentId);
		// get summary information
		helper.getStudyResult(component, event, helper,studentId);
		// get dataTable study result
		helper.getDataTableStudyResult(component, event, helper,studentId);

		


	},

	closeModel : function(component, Event, helper)
	{
		component.set('v.isShowModel', false);
	}
})