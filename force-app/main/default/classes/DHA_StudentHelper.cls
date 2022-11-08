public class DHA_StudentHelper {

    public void beforeInsert(LIST<DHA_Student__c> lstStudents)
    {
        /*Rule: 
        1. Name should be at least 3 characters long 
        2.Student birthdate should be after 1990/01/01 
        3. Student birthdate should be 6 years before the current date  */
        
        for(DHA_Student__c student :lstStudents)
        {
            if(student.Name.length() < 3 ){
                student.Name.addError('This student name is too short.');
            }

            if(student.Birthday__c != null && student.Birthday__c < date.parse('01/01/1990'))
            {
                student.Birthday__c.addError('This student birthdate is invalid. Birthdate should be after 1990/01/01');
            }
            if(student.Birthday__c != null && student.Birthday__c.daysBetween(date.today())/365 < 6 ) // 1 year = 365 days -> year = days/265
            {
                student.Birthday__c.addError('This student age is not enough to attend our classes.');
            }
        }
    }
}