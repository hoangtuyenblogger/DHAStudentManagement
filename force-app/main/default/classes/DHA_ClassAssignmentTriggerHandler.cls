public without sharing class DHA_ClassAssignmentTriggerHandler extends TriggerHandler  {

    public DHA_ClassAssignmentHelper helper;
    public DHA_ClassAssignmentTriggerHandler()
    {
        this.helper = new DHA_ClassAssignmentHelper();
    }

    public override void beforeInsert()
    {
        this.helper.beforeInsert(Trigger.new);
    }
    public override void afterInsert()
    {
        this.helper.afterInsert(Trigger.new);
    }
}