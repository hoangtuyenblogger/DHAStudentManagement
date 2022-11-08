public with sharing class DHA_Controller {
    @AuraEnabled
	public static List<DHA_Class__c> getClassName()
    {   List<DHA_Class__c> classes = [SELECT Name FROM DHA_Class__c];
        return classes ;
    }

    @AuraEnabled
    public static List<DHA_Student__c> getStudent()
    {
        List<DHA_Student__c> students = [SELECT Student_Code__c, Name, Birthday__c,  Address__c, Email__c FROM DHA_STudent__c  
        WHERE LastViewedDate != null ORDER BY Student_Code__c ASC];
        return students;
    }

    @AuraEnabled
    public static List<DHA_student__c> nameSearch(String name)
    {
        List<DHA_Student__c> students = new List<DHA_Student__c>();
        String likeName = '%' + name + '%';  // -> %Tran%
        String query = 'SELECT Student_Code__c, Name,Birthday__c, Address__c, Email__c FROM DHA_STudent__c  WHERE  Name LIKE \''  + likeName + '\' ORDER BY Student_Code__c ASC';
        students = Database.query(query);
        return students;
    }
    @AuraEnabled
    public static List<DHA_student__c> birthdaySearch(String birthday)
    {
        List<DHA_Student__c> students = new List<DHA_Student__c>();
        String query = 'SELECT Student_Code__c, Name,Birthday__c, Address__c, Email__c FROM DHA_STudent__c  WHERE birthday__c = ' + birthday + ' ORDER BY Student_Code__c ASC';
        students = Database.query(query);
        return students;
    }


    @AuraEnabled
    public static List<DHA_Student__c> searchStudent(String name, String birthday)
    {
        List<DHA_Student__c> students = new List<DHA_Student__c>();
        String likeName = '%' + name + '%';  // -> %Tran%
        if(name != '' && birthday == null) // search by name
        {
            students = nameSearch(name);
            return students;
        }
        if(name == '' && birthday != null) // search by birthday
        {
            students = birthdaySearch(birthday);
            return students;
        }
        if(name != '' && birthday != null)
        {
            String query = 'SELECT Student_Code__c, Name,Birthday__c, Address__c, Email__c FROM DHA_STudent__c WHERE Name LIKE \'' + likeName + '\''   + '  AND birthday__c = ' + birthday + ' ORDER BY Student_Code__c ASC';
            students = Database.query(query);
        }
        return students;
    }

    @AuraEnabled
    public static List<DHA_Student__c> getstudentInfo(String studentId) //a0A5i000002WeiuEAC Tuyen
    {
        List<DHA_Student__c> results = new List<DHA_Student__c>();
        String query = 'SELECT Student_code__c, Name, Birthday__c, Gender__c, Age__c,  Email__c, Address__c FROM DHA_Student__c WHERE Id = \'' + studentId + '\'';
        //String query = 'SELECT Student_code__c, Name, Birthday__c, Gender__c, Age__c,  Email__c, Address__c FROM DHA_Student__c limit 2';
        results = Database.query(query);
        return results;
    }
    
    @AuraEnabled
    public static  List<Object> getStudyResult(String studentId)
    {
        // return Object: assignedClass(1), classHaveFinalScore(2), avgFinalScore(3), studyResults(4)

        // 1. get Assigned Classes
        Integer assignedClass = 0;
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
                    sumScore += (Integer) result.Final_Score__c;
                }
                
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
        //studyResultInfo.add(studyResults);

        Return studyResultInfo;
    }

    @AuraEnabled
    public static List<Object> getDataTableStudyResult(String studentId)
    {
        String query = 'SELECT DHA_Class_Assignment__r.DHA_Class__c, ' + 
                        ' Score_1__c, Score_2__c, Score_3__c, ' + 
                        'Final_Score__c, ' +
                        'Result__c ' +
                        ' FROM DHA_Study_Result__c ' +
                        ' WHERE DHA_Class_Assignment__r.DHA_Student__c =' + '\'' + studentId + '\'';
        List<DHA_Study_Result__c> studyResults = new List<DHA_Study_Result__c>();
        studyResults = Database.query(query);
        return studyResults;
    }
}