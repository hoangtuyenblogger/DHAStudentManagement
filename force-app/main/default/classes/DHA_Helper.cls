public with sharing class DHA_Helper {
    public DHA_Helper() {

    }
    public static Integer getOrgDefaults_DHA_ManagementSetting(String sObjectName)
    {
        try {
            DHA_Management_Setting__c dha_Management_Setting =  DHA_Management_Setting__c.getvalues(Userinfo.getUserId());

            if(dha_Management_Setting == null){
                dha_Management_Setting = DHA_Management_Setting__c.getvalues(Userinfo.getProfileId());
            }

            if(dha_Management_Setting == null){
                dha_Management_Setting = DHA_Management_Setting__c.getOrgDefaults();
            }

            if(sObjectName == 'DHA_Class__c')
            {
                return dha_Management_Setting.Max_Assigned_Classes__c.intValue();
            }
            else if(sObjectName == 'DHA_Student__c') {
                return dha_Management_Setting.Max_Students_In_Class__c.intValue();
            }
            else if(sObjectName == 'DHA_Study_Result__c') {
                return dha_Management_Setting.Pass_Score__c.intValue();
            }
        }
        catch (Exception ex) 
        {
            System.debug('Return -1, Error in method getMaxAssignedClasses(), message: ' + ex); 
        }
        return 0;
    }

    public static Integer getOrgDefaults(String fieldName)
    {
        try {
            DHA_Management_Setting__c dha_Management_Setting =  DHA_Management_Setting__c.getvalues(Userinfo.getUserId());

            if(dha_Management_Setting == null){
                dha_Management_Setting = DHA_Management_Setting__c.getvalues(Userinfo.getProfileId());
            }

            if(dha_Management_Setting == null){
                dha_Management_Setting = DHA_Management_Setting__c.getOrgDefaults();
            }

            if(fieldName == 'Max_Assigned_Classes__c')
            {
                return dha_Management_Setting.Max_Assigned_Classes__c.intValue();
            }
            else if(fieldName == 'Max_Students_In_Class__c') {
                return dha_Management_Setting.Max_Students_In_Class__c.intValue();
            }
            else if(fieldName == 'Pass_Score__c') {
                return dha_Management_Setting.Pass_Score__c.intValue();
            }
        }
        catch (Exception ex) 
        {
            System.debug('Return -1, Error in method getMaxAssignedClasses(), message: ' + ex); 
        }
        return 0;
    }

    public static Boolean isActiveTrigger(String field)
    {
        try {
            DHA_Management_Setting__c DHA_triggerSetting =  DHA_Management_Setting__c.getvalues(Userinfo.getUserId());

            if(DHA_triggerSetting == null){
                DHA_triggerSetting = DHA_Management_Setting__c.getvalues(Userinfo.getProfileId());
            }

            if(DHA_triggerSetting == null){
                DHA_triggerSetting = DHA_Management_Setting__c.getOrgDefaults();
            }

            if(DHA_triggerSetting == null)
            {
                return true;
            }
            else {
                return Boolean.valueOf(DHA_triggerSetting.get(field));
            }
            
        } catch (Exception ex) {
            return true; 
        }
    }




    //
    /* [Select DHA_Class__c, count(Id)numberClass from DHA_Class_Assignment__c Group By DHA_Class__c]    
        [
            {DHA_Class__c: 'a0C5i000005nYsUEAU', cound(id): 2},
            {DHA_Class__c: 'a0C5i000005ncgyEAA', cound(id): 1}
        ]

        getSumClass('a0C5i000005nYsUEAU') -> 2  */

    public static Integer getSumClass(String className)
    {
        Integer returnValue = -1;
        List<AggregateResult> total_class = [Select DHA_Class__c, count(Id)sumClass from DHA_Class_Assignment__c Group By DHA_Class__c];
        for(AggregateResult result :total_class)
            {
                if(result.get('DHA_Class__c') == className)
                {
                    returnValue = (Integer) result.get('sumClass');
                    return returnValue;
                }
            }
        return returnValue;
    }
    


        //
    /* [Select DHA_Student__c, count(Id)sumStudent from DHA_Class_Assignment__c Group By DHA_Student__c]    
        [
            {DHA_Student__c: 'a0A5i000002WfxkEAC', cound(id): 2},
            {DHA_Student__c: 'a0A5i000002WeizEAC', cound(id): 1},
            {DHA_Student__c: 'a0A5i000002WdxjEAC', cound(id): 1}
        ]

    getNumberClass('a0C5i000005nYsUEAU') -> 2  */
    public static Integer getSumStudent(String studentName)
    {
        Integer returnValue = -1;
        List<AggregateResult> total_student = [Select DHA_Student__c, count(Id)sumStudent from DHA_Class_Assignment__c Group By DHA_Student__c];
        for(AggregateResult result :total_student)
            {
                if(result.get('DHA_Student__c') == studentName)
                {
                    returnValue = (Integer) result.get('sumStudent');
                    return returnValue;
                }
            }
        return returnValue;
    }


}