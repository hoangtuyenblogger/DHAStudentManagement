public with sharing class test {
    public static void afterUpdate(List<DHA_Study_Result__c> lstStudyResult)
    {
        DHA_Study_Result__c latestStudy = [SELECT Name, Is_Latest__c FROM DHA_Study_Result__c WHERE Is_Latest__c = true];
        latestStudy.Is_Latest__c = false;
        System.debug('Updated lasted study is ' + latestStudy.Name + ' to false');

        lstStudyResult[0].Is_Latest__c = true;
        System.debug('Latest study result was updated, it\' name is: ' + lstStudyResult[0].Name );
    }

    public static void updateForme(List<DHA_Study_Result__c> studyResultQuery)
    {
        if(studyResultQuery != null)
        {
            update studyResultQuery;
        }
        System.debug('Updated studyResultQuery Is_Latest__c = ' + studyResultQuery[0].Is_Latest__c);
    }
    

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
                                                WHERE DHA_Class_Assignment__c IN :classAssignmentSet AND Id NOT IN :studyIdSet])
        {
            studyResult.Is_Latest__c = false;
            olderResults.add(studyResult);
        }

        System.debug('This is olderResults: ' + olderResults);

        //3. update older DHA_Study_Result__c
        try {
            update olderResults;
            System.debug('Updated older study result ');
        } catch (Exception ex) {
            System.debug('Exception in afterInsert : ' + ex);
        }
    }

/*     public static Integer getNumberClass(String className)
    {
        Integer returnValue = 0;
        List<AggregateResult> total_class = [Select DHA_Class__c, count(Id)numberClass from DHA_Class_Assignment__c Group By DHA_Class__c];
        for(AggregateResult result :total_class)
        {
            if(result.get('DHA_Class__c') == className)
            {
                returnValue = (Integer) result.get('numberClass');
                return returnValue;
            }
        }
        return returnValue;
    } */


    /*      String query = 'select count() from DHA_Class_Assignment__c Where DHA_Class__c = \'a0C5i000005nYsUEAU\'';
        Integer results;
        results = Database.countQuery(query);
        System.debug(results); */
/* 
    public static void test_create_Class_Assignment() 
    {

        DHA_Management_Setting__c manage = new DHA_Management_Setting__c();
        if(manage == null){
            manage = DHA_Management_Setting__c.getOrgDefaults();
        }
        System.debug(manage);

        List<DHA_Management_Setting__c> a = new List<DHA_Management_Setting__c>();
    a = Database.query('select Max_Assigned_Classes__c from DHA_Management_Setting__c');
    System.debug(a);

    } */

    public static Integer getDefaut_DHA_ManagerSetting(String fieldName)
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
            else if(fieldName == 'DHA_Student__c') {
                return dha_Management_Setting.Max_Students_In_Class__c.intValue();
            }
        }
        catch (Exception ex) 
        {
            System.debug('Return -1, Error in method getMaxAssignedClasses(), message: ' + ex); 
        }
        return -1;
    }




    public  List<Object> getStudyResult(String studentId)
    {
        // return Object: assignedClass(1), classHaveFinalScore(2), avgFinalScore(3), studyResults(4)

        // 1. get Assigned Classes
        Integer assignedClass = -1;
        List<AggregateResult> results = [SELECT DHA_Student__c , count(Id)assignedClass FROM DHA_Class_Assignment__c GROUP BY DHA_Student__c ];
        for(AggregateResult ar :results)
        {
            if(ar.get('DHA_Student__c') == studentId)
            {
                assignedClass = (Integer) ar.get('assignedClass');
            }
        }

        // 4. get study result
        String query = 'SELECT DHA_Class_Assignment__r.DHA_Student__c '
                        + ' , DHA_Class_Assignment__r.DHA_Class__c, ' + 
                        ' Score_1__c, Score_2__c, Score_3__c, ' + 
                        'Final_Score__c, ' +
                        'Result__c ' +
                        ' FROM DHA_Study_Result__c ' +
                        ' WHERE DHA_Class_Assignment__r.DHA_Student__c =' + '\'' + studentId + '\'';
        List<DHA_Study_Result__c> studyResults = new List<DHA_Study_Result__c>();
        studyResults = Database.query(query);
        
        // 3. get class have Final Score &  average final score 
        Integer sumScore = 0;
        Integer classHaveFinalScore = 0;
        Double avgFinalScore;
       
        if(studyResults.size() > 0)
        {
            for(DHA_Study_Result__c result :studyResults )
            {
                if(result.Final_Score__c != 0)
                {
                    classHaveFinalScore++;
                }
                sumScore += (Integer) result.Final_Score__c;
            }
            avgFinalScore = Double.valueOf(sumScore) / studyResults.size();
        }
        else {
            avgFinalScore = 0;
        }
        //avgFinalScore = (Double) Decimal.valueOf(avgFinalScore).setScale(2); // 3,146 - > 3,15\


        List<Object> studyResultInfo = new List<Object>();
        studyResultInfo.add(assignedClass);
        studyResultInfo.add(classHaveFinalScore);
        studyResultInfo.add(avgFinalScore);
        studyResultInfo.add(studyResults);

        Return studyResultInfo;
    }


    public void Integer getAssignedClass(String studentId)
    {
        Integer assignedClass = -1;
        List<AggregateResult> results = [SELECT DHA_Student__c , count(Id)assignedClass FROM DHA_Class_Assignment__c GROUP BY DHA_Student__c ];
        for(AggregateResult ar :results)
        {
            if(ar.get('DHA_Student__c') == studentId)
            {
                assignedClass = (Integer) ar.get('assignedClass');
            }
        }
        return assignedClass;
    }

    public void Integer getClassHaveFinalScore(String studentId)
    {
        String query = 'SELECT DHA_Class_Assignment__r.DHA_Student__c '
                        + ' , DHA_Class_Assignment__r.DHA_Class__c, ' + 
                        ' Score_1__c, Score_2__c, Score_3__c, ' + 
                        'Final_Score__c, ' +
                        'Result__c ' +
                        ' FROM DHA_Study_Result__c ' +
                        ' WHERE DHA_Class_Assignment__r.DHA_Student__c =' + '\'' + studentId + '\'';
        List<DHA_Study_Result__c> studyResults = new List<DHA_Study_Result__c>();
        studyResults = Database.query(query);
        
        // 3. get class have Final Score &  average final score 
        Integer sumScore = 0;
        Integer classHaveFinalScore = 0;
        Double avgFinalScore;
       
        if(studyResults.size() > 0)
        {
            for(DHA_Study_Result__c result :studyResults )
            {
                if(result.Final_Score__c != 0)
                {
                    classHaveFinalScore++;
                }
                sumScore += (Integer) result.Final_Score__c;
            }
            avgFinalScore = Double.valueOf(sumScore) / studyResults.size();
        }
        else {
            avgFinalScore = 0;
        }
        return classHaveFinalScore;
    }
}