/**
* @author : Char
* @className: PaymentTriggerHelper
* @createdDate: 5 Feb 2022
* @description: This apex class is being to be used in Payment Trigger.
*/

public class PaymentTriggerHelper {
    
    //After Insert Records
    public static void onAfterInsert(List<Payment__c> newRecordList){
        filterAndUpdateRecord(newRecordList);
    }
    // After Update Records
    public static void onAfterUpdate(List<Payment__c> oldRecordList, Map<Id,Payment__c> oldRecordMap, List<Payment__c> newRecordList, Map<Id,Payment__c> newRecordMap){
        Set<id> contactIds = new Set<id>();
        Set<id> projectIds = new Set<id>();
        for(Payment__c paymentRecords : newRecordList){
            Payment__c oldPaymentsRecords = oldRecordMap.get(paymentRecords.id);
            // condition to check the old value and new value
            if((paymentRecords.Contact__c != oldPaymentsRecords.Contact__c) || (paymentRecords.Amount__c != oldPaymentsRecords.Amount__c)){
                if(paymentRecords.Contact__c != null){
                    contactIds.add(paymentRecords.Contact__c);
                }
                if(oldPaymentsRecords.Contact__c != null){
                    contactIds.add(oldPaymentsRecords.Contact__c);
                }
            }
            // condition to check the old value and new value
            if((paymentRecords.Project__c != oldPaymentsRecords.Project__c) || (paymentRecords.Amount__c != oldPaymentsRecords.Amount__c)){
                if(paymentRecords.Project__c != null){
                    projectIds.add(paymentRecords.Project__c);
                }
                if(oldPaymentsRecords.Project__c != null){
                    projectIds.add(oldPaymentsRecords.Project__c);
                }
            }
        }
        updateContactRecords(contactIds);
        updateProjectRecords(projectIds);
    } 
    
    // After Delete Records
    public static void onAfterDelete(List<Payment__c> oldRecordList, Map<Id,Payment__c> oldRecordMap){
        filterAndUpdateRecord(oldRecordList);
    }
    
    /************************************************************************************************************
    * @description: This method is being used to filter and update Contact and project records
	* @param {paymentRecordList} List of Payment__c records
    */
    private static void filterAndUpdateRecord(List<Payment__c> paymentRecordList){
        Set<id> contactIds = new Set<id>();
        Set<id> projectIds = new Set<id>();
        for(Payment__c paymentRecord : paymentRecordList){
            if(paymentRecord.Contact__c != null){
                contactIds.add(paymentRecord.Contact__c);
            }
            if(paymentRecord.Project__c != null){
                projectIds.add(paymentRecord.Project__c);
            }
        }
        updateContactRecords(contactIds);
        updateProjectRecords(projectIds);
    }
    
    /************************************************************************************************************
    * @description: This method is being used to update Contact object field -  Total_Amount_Of_Payment__c, Recent_Payment_Date__c
	* @param {contactIds} set of contact record ids
    */
    private static void updateContactRecords(set<id> contactIds ){
        List <Contact> contactListToUpdate = new List <Contact> ();
        List <AggregateResult> agrList = new List <AggregateResult>();
        agrList = [SELECT Sum(Amount__c)sumAmount, MAX(Payment_Date__c)mostRecentPayment,
                   Contact__c FROM Payment__c WHERE Contact__c IN:contactIds GROUP BY Contact__c];
        if(!agrList.isEmpty()){
            for(AggregateResult agr :agrList){
                
                Decimal sum = (Decimal)agr.get('sumAmount');
                Date mostRecentPayment = (Date)agr.get('mostRecentPayment');
                Id accId  = (Id)agr.get('Contact__c');
                
                contactListToUpdate.add(new Contact(Id =accId, 
                                                    Total_Amount_Of_Payment__c = sum, 
                                                    Recent_Payment_Date__c = mostRecentPayment));
                
            }
        }
        if(contactListToUpdate.isEmpty()){
            update contactListToUpdate; // DML to update the contact List 
        } 
    }
   
     /************************************************************************************************************
    * @description: This method is being used to update Project object field - Total amount of Payments
	* @param {projectIds} set of project record ids
    */
    private static void updateProjectRecords(set<id> projectIds ){
        List <Project__c> projectListToUpdate = new List <Project__c> ();
        List <AggregateResult> agrList = new List <AggregateResult>();
        agrList = [SELECT Sum(Amount__c)sumAmount, Project__c FROM Payment__c
                   WHERE Project__c IN:projectIds GROUP BY Project__c];
        if(!agrList.isEmpty()){
            for(AggregateResult agr :agrList){
                Decimal sum = (Decimal)agr.get('sumAmount');
                Id accId  = (Id)agr.get('Project__c');
                projectListToUpdate.add(new Project__c(Id =accId, Total_Amount_Of_Payment__c = sum));
                
            }
        }
        if(projectListToUpdate.isEmpty()){
            update projectListToUpdate;   // DML to update the project List 
        } 
    }
}