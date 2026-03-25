public class FixPromoteCheckboxBatch implements Database.Batchable<sObject> {
    
    public String pipelineId;

    // Constructor to pass the pipeline ID
    public FixPromoteCheckboxBatch(String pId) {
        this.pipelineId = pId;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Select ALL records. No LIMIT needed here.
        return Database.getQueryLocator([
            SELECT Id, copado__Promote_Change__c
            FROM copado__User_Story__c 
            WHERE copado__Project__r.copado__Deployment_Flow__c = :pipelineId
            AND copado__Promote_Change__c = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        // Scope size will be controlled by the executeBatch parameter (we set it to 10)
        List<copado__User_Story__c> stories = (List<copado__User_Story__c>)scope;
        
        for(copado__User_Story__c s : stories){
            s.copado__Promote_Change__c = true;
        }
        
        // In Batch Apex, we usually just update the whole scope
        // If one fails, we let the batch error handling catch it, or use Database.update(stories, false)
        Database.update(stories, false); 
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Batch Processing Complete.');
    }
}