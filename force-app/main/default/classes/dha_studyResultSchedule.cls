global class dha_studyResultSchedule implements Schedulable {
    public dha_studyResultSchedule() {

    }
    global void execute(SchedulableContext sc)
    {
        studyResultUpdateBatch studyResultBatch = new studyResultUpdateBatch();
        Database.executeBatch(studyResultBatch);
    }
}
