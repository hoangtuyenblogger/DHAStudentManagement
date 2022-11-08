public without sharing class DHA_StudentTriggerHandler extends TriggerHandler {
    public DHA_StudentHelper helper;
    // constructor
    public DHA_StudentTriggerHandler()
    {
        this.helper = new DHA_StudentHelper();
    }

    public override void beforeInsert()
    {
        helper.beforeInsert(Trigger.new);
    }

}