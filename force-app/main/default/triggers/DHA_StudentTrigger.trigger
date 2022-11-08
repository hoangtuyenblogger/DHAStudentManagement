trigger DHA_StudentTrigger on DHA_Student__c (before insert,before update,after insert,after update) {
    // run trigger if isActiveTrigger = true
    if(DHA_Helper.isActiveTrigger('Is_Class_Trigger_Active__c')) {
        new DHA_StudentTriggerHandler().run();
    }

}