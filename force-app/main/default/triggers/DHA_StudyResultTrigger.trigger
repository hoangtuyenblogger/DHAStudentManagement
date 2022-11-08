trigger DHA_StudyResultTrigger on DHA_Study_Result__c (before insert, after insert, before update,after update) {
    // check isActiveTrigger -> field: Is_Study_Result_Trigger_Active__c
    if(DHA_Helper.isActiveTrigger('Is_Study_Result_Trigger_Active__c'))
    {
        new DHA_StudyResultTriggerHandler().run();
    }
}

// DHA_StudyResultTriggerHandler extends, override
// DHA_StudyResultHelper  override void . . .