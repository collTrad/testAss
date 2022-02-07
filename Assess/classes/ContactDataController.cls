/**
* @author : Char
* @className: ContactDataController
* @createdDate: 5 Feb 2022
* @description: This apex class is being to be used in LWC component.
* @componentName:  contactPayment
*/

public class ContactDataController {
    
    /************************************************************************************************************
    * @description: This method is being used to get the contact records
    * @return: list of contact records
    */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactRecords() {
        return [SELECT id, FirstName, LastName, Recent_Payment_Date__c, Total_Amount_Of_Payment__c,
                (SELECT id, Project__c, Amount__c,Payment_Date__c from Payments__r ORDER BY Payment_Date__c ASC) 
                FROM Contact WHERE Total_Amount_Of_Payment__c != null];
    }
    
}