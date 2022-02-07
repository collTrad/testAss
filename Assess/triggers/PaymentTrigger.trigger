// Trigger with Context variable for controlling the calling flow
trigger PaymentTrigger on Payment__c (after insert, after Update, after Delete) {
    
    // This condition will check for trigger events using isAfter context variable
    if(Trigger.isAfter){
        if(Trigger.isInsert){ 
            PaymentTriggerHelper.onAfterInsert(trigger.new);
        }else if(Trigger.isUpdate){
            PaymentTriggerHelper.onAfterUpdate(trigger.old, trigger.oldmap, trigger.new, Trigger.newmap);
        }else if(Trigger.isDelete){
            PaymentTriggerHelper.onAfterDelete(trigger.old, trigger.oldmap);
        }
    }
    
}