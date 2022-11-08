public without sharing class DHA_StudyResultHelper {
    public static Boolean skipMarkAsLatest = false;

    
    public void beforeUpdate(Map<Id,SObject> newMap, Map<Id,SObject> oldMap) 
    {   
        if(skipMarkAsLatest == true)
        {
            return;
        }
        
        if(skipMarkAsLatest == false)
        {
            Integer passScore = DHA_Helper.getOrgDefaults_DHA_ManagementSetting('DHA_Study_Result__c');
            List<Object> parameters = new List<Object>{passScore};
            String errorMessage = String.format('Cannot update this result because Final Score is less than {0}', parameters);
            
            for(Id studyId :newMap.keySet())
            {   
                DHA_Study_Result__c newStudyResult = (DHA_Study_Result__c) newMap.get(studyId);
                if(newStudyResult.Is_Latest__c == false)
                {
                    // 1. update Is_Latest__c of new records to true when it is updated
                    newStudyResult.Is_Latest__c = true;
                    
                }

                DHA_Study_Result__c oldStudyResult = (DHA_Study_Result__c) oldMap.get(studyId);
                // oldStudyResult != null
                if(oldStudyResult.Result__c != newStudyResult.Result__c && newStudyResult.Result__c == 'Passed')
                {
                    if(newStudyResult.Final_Score__c < passScore)
                    {
                        newStudyResult.Result__c.addError(errorMessage);
                    }
                }
            
            }
    }
    
    }        

    public void afterUpdate(List<DHA_Study_Result__c> lstStudyResult)
    {   
        if(skipMarkAsLatest == true)
        {
            return;
        }
        Set<Id> idStudyResultSet = new Set<Id>();
        Set<String> classAssignmentSet = new Set<String>();
        //  build sets needed to query
        for(DHA_Study_Result__c studyResult :lstStudyResult)
        {
            idStudyResultSet.add(studyResult.Id);
            classAssignmentSet.add(studyResult.DHA_Class_Assignment__c);
        }

        //  query record which associates with class assignment (not oursefl)
        List<DHA_Study_Result__c> studyResultQuery = [SELECT Is_Latest__c FROM DHA_Study_Result__c 
                                                WHERE Is_Latest__c = true 
                                                AND  DHA_Class_Assignment__c IN :classAssignmentSet
                                                    AND Id NOT IN :idStudyResultSet ];

        // 2. set Is_Latest__c to false
        for(DHA_Study_Result__c studyResult_toUpdate :studyResultQuery)
        {
            studyResult_toUpdate.Is_Latest__c = false;
        }
        // 3. update record
        
        skipMarkAsLatest = true;
        update studyResultQuery;

 
    }
    

    // update Is_Latest__c of all new records to true when new results are created
    public void beforeInsert(List<DHA_Study_Result__c> lstStudyResult)
    {
        for(DHA_Study_Result__c studyResult :lstStudyResult)
        {
            studyResult.Is_Latest__c = true;
        }
    }
    // the older results in the same class assignment should have Is_Latest__c equals to false
    public void afterInsert(List<DHA_Study_Result__c> lstStudyResult)
    {
        List<DHA_Study_Result__c> olderResults = new List<DHA_Study_Result__c>();
        Set<String> classAssignmentSet = new Set<String>();
        Set<ID> studyIdSet = new Set<ID>();

        //1. build sets to query
        for(DHA_Study_Result__c studyResult :lstStudyResult )
        {
            classAssignmentSet.add(studyResult.DHA_Class_Assignment__c); 
            studyIdSet.add(studyResult.Id); // Id ourseft
        }

        // 2. query for all other DHA_Study_Result__c (not to query ourself) with matching classAssignmentSet
        for(DHA_Study_Result__c studyResult :[ SELECT Is_Latest__c FROM DHA_Study_Result__c 
                                                WHERE Is_Latest__c = true
                                                AND DHA_Class_Assignment__c IN :classAssignmentSet
                                                AND Id NOT IN :studyIdSet])
        {
            studyResult.Is_Latest__c = false;
            olderResults.add(studyResult);
        }
        //3. update older DHA_Study_Result__c
        try {
            skipMarkAsLatest = true;
            update olderResults;
            System.debug('Updated older study result ');
        } catch (Exception ex) {
            System.debug('Exception in afterInsert : ' + ex);
        }
    }

}