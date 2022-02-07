@isTest
public class PaymentTriggerHelperTest {    
    @testSetup static void setup(){
        List <Payment__c> paymentList = new List <Payment__c>();
        Contact cont =  new Contact();
        cont.LastName= 'Tester';
        Insert cont;
        Project__c proj = new Project__c();
        proj.Name ='MyProject';
        insert proj;
        
        Payment__c payment1 = new Payment__c();
        payment1.Amount__c= 154.00;
        payment1.Contact__c = cont.Id;
        payment1.Project__c = proj.Id;
        payment1.Payment_Date__c= System.today();
        
        Payment__c payment2 = new Payment__c();
        payment2.Amount__c= 155.00;
        payment2.Contact__c = cont.Id;
        payment2.Project__c = proj.Id;
        payment2.Payment_Date__c= System.today();

        paymentList.add(payment1);
        paymentList.add(payment2);
        insert paymentList;  
    } 
    @isTest 
    public Static void myTestMethodOne(){
        Payment__c payment =[Select Id From Payment__c Where Name !=null limit 1];
        payment.Amount__c =255.00;
        update payment;
    }
    @isTest 
    public Static void myTestMethodTwo(){
        Delete [Select Id From Payment__c Where Name !=null limit 1];
    }
}