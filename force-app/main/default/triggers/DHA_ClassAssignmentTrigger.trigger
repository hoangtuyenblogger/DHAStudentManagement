trigger DHA_ClassAssignmentTrigger on DHA_Class_Assignment__c (before insert,before update,after insert,after update) {
    if(DHA_Helper.isActiveTrigger('Is_Class_Assignment_Trigger_Active__c'))
    {
        new DHA_ClassAssignmentTriggerHandler().run();
    }

}