public class DHA_ClassAssignmentHelper {
    
    public void beforeInsert(List<DHA_Class_Assignment__c> lstDHA_Class_Assignment)
    {
        // Rule: Student’s assigned classes should not be greater than DHA_Management_Setting__c.Max_Assigned_Class__c
        Integer max_Assigned_Classes = DHA_Helper.getOrgDefaults_DHA_ManagementSetting('DHA_Class__c');
        
        for(DHA_Class_Assignment__c assignment :lstDHA_Class_Assignment)
        {
            Integer sumClass = DHA_Helper.getSumClass(assignment.DHA_Class__c);
            if(sumClass < max_Assigned_Classes)
            {
                System.debug('Added assignment!');
            }
            else {
                assignment.DHA_Class__c.addError('There is no seat to join this class.');
            }
        }
        // Rule: Student’s assigned classes should not be greater than DHA_Management_Setting__c.Max_Assigned_Class__c
        //Integer max_Student_In_Class = DHA_Helper.getOrgDefaults_DHA_ManagementSetting('DHA_Student__c');
        for(DHA_Class_Assignment__c assignment :lstDHA_Class_Assignment )
        {
            Integer sumStudent = DHA_Helper.getSumStudent(assignment.DHA_Student__c);
            if(sumStudent < max_Assigned_Classes)
            {
                System.debug('Added assignment!');
            }
            else {
                assignment.DHA_Class__c.addError('This student is attending to too much class.');
            }
        }
    }

    public void afterInsert(List<DHA_Class_Assignment__c> lstDHA_Class_Assignment)
    {
        List<DHA_Study_Result__c> newStudyResults = new  List<DHA_Study_Result__c>();

        for(DHA_Class_Assignment__c item :lstDHA_Class_Assignment)
        {
            newStudyResults.add(new DHA_Study_Result__c(DHA_Class_Assignment__c = item.Id, Is_Latest__c= true));
        }
        if(!newStudyResults.isEmpty())
        {
            insert newStudyResults;
        }
    }

   
}