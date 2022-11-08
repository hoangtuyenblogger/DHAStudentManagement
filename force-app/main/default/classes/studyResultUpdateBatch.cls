public  class studyResultUpdateBatch implements Database.batchable<sObject>, Database.Stateful {

    private Integer passedScore;
    private Integer successUpdate;
    public studyResultUpdateBatch()
    {
        this.passedScore = DHA_Helper.getOrgDefaults('Pass_Score__c');
        this.successUpdate = 0;
    }
    // Update Result__c to Passed if Final_Score__c > DHA_Mangement_Setting__c.Passed_Score__c

    public Database.QueryLocator start(Database.BatchableContext bc){ 
        String query = 'SELECT Result__c FROM DHA_Study_Result__c WHERE Final_Score__c > ' + passedScore;
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope){
        for(SObject studyResult :scope)
        {
            studyResult.put('Result__c','Passed' );
            successUpdate++;
        }
        update scope;
    }

    public void finish(Database.BatchableContext info){
        System.debug('===== execute batch successfully ======');
        System.debug(successUpdate + ' Result updated');  
    }

}