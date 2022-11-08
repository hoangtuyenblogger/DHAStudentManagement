public class DHA_StudyResultTriggerHandler extends TriggerHandler {

    public DHA_StudyResultHelper helper;
    public DHA_StudyResultTriggerHandler() {
        this.helper = new DHA_StudyResultHelper();
    }

    public override void beforeInsert()
    {
        helper.beforeInsert(Trigger.new);
    }

    public override void afterInsert()
    {
        helper.afterInsert(Trigger.new);
    }

    public override void beforeUpdate()
    {
        helper.beforeUpdate(Trigger.newMap,Trigger.oldMap);
    }

    public override void afterUpdate()
    {
        helper.afterUpdate(Trigger.new);
    }
}


