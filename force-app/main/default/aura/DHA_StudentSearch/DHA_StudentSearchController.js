({
    handleSort: function(component,event, helper)
    {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);	         
    },

	click_search : function(component, event, helper) {
        // if check_valid -> true -> search
        if(helper.check_valid(component, event, helper))
        {
            component.set("v.loaded", !component.get("v.loaded")); // show Spiner
            helper.getDataSearch(component,event);
            setTimeout(function(){
                component.set("v.loaded", !component.get("v.loaded")); // hide Spiner after 1 second
            },1000);
        }
	},
	clear_condition: function(component, event, helper) {
		    helper.resetField(component);
            
            let dataGlobal = component.get('v.dataGlobal');
            component.set('v.data',dataGlobal); // set back data table
    },
        
	doInit : function(component, event, helper) {

        // set null value for inputField
		component.set('v.studentName', '');
        component.set('v.birthday', null);
        
		// load name of DHA_Class__c dropdown
		helper.getclass(component, event, helper);

        var actions = [
            { label: 'Show details', name: 'show_details' }
        ];
		// set colums datatable
		component.set('v.columns', [
            {label: 'Student Code', fieldName: 'Student_code__c', type: 'text', sortable :'true'},
            {label: 'Student Name', fieldName: 'Name', type: 'text', sortable :'true'},
            {label: 'Birthday', fieldName: 'Birthday__c', type: 'date',sortable :'true',
            typeAttributes:{
                month: "2-digit",
                day: "2-digit",
                year: "numeric",
                
            }},
            {label: 'Address', fieldName: 'Address__c', type: 'text', sortable :'true'},
            {label: 'Email', fieldName: 'Email__c', type: 'email', sortable :'true' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
		helper.get_datatable(component);
	},


    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        

        switch (action.name) {
            case 'show_details':
                let studentId = row['Id'];
                console.log('Row Student Id = ', studentId);
                helper.showDetails(component, event, helper,studentId);

                break;
        }
    }

})