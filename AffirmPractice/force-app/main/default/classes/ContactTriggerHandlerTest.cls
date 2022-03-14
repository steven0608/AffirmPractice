/**
* @author Steven Chen
* @date 03/13/2022
*
* @description Test class for ContactTriggerHandler and ContactTrigger
*/
@isTest
public class ContactTriggerHandlerTest {

    static final string TEST_CONTACT = 'TestContact';
    static final string TEST_ACCOUNT = 'TestAccount';
    static final string BANKING = 'Banking';
    static final string ONE_CONACT_RECORD_NAME ='TestContact0';
    static final string UPDATED_CONACT_RECORD_NAME ='updateTestContactTest';

    /*
    * @description set up contacts and account data
    */
    @testSetup static void setup() {
        
        // Create common test contact
        List<contact> testContacts = new List<contact>();
        for(Integer i=0;i<5;i++) {
            testContacts.add(new Contact(Lastname = TEST_CONTACT+i));
        }
        insert testContacts;
        
        insert new Account(name=TEST_ACCOUNT, Industry=BANKING); // create account 
        
    }
    
    /*
    * @description: update contact when it has no related account
    * expected result: contact is update and Account_Industry__c remain empty
    */
    @isTest static void updateAccountIndustryOnContactOnUpdateWithNoAccountTest() {
        
        Contact contactRecord =[SELECT id FROM Contact WHERE lastName = :ONE_CONACT_RECORD_NAME Limit 1];
        Test.startTest();
        
        contactRecord.lastName = UPDATED_CONACT_RECORD_NAME;
        update contactRecord;
        
        Test.stopTest();
        
        Contact updatedContactRecord =[SELECT id, lastName,Account_Industry__c FROM Contact WHERE lastName = :UPDATED_CONACT_RECORD_NAME Limit 1];
        system.assertEquals(UPDATED_CONACT_RECORD_NAME, updatedContactRecord.LastName, 'Contact lastName should be updated.');
        system.assert(String.isBlank(updatedContactRecord.Account_Industry__c), 'Account industry should be blank'); 
    }
    
    /*
    * @description: update contact's lastName when it has related account
    * expected result: contact is updated and Account_Industry__c is populated
    */
    @isTest static void updateAccountIndustryOnContactOnUpdateWithRelatedAccountTest() {
        
        Contact contactRecord =[SELECT id FROM Contact WHERE lastName = :ONE_CONACT_RECORD_NAME Limit 1];
        Account accountRecord = [SELECT id FROM Account Limit 1];
        Test.startTest();
        
        contactRecord.lastName = UPDATED_CONACT_RECORD_NAME;
        contactRecord.AccountId = accountRecord.id;
        update contactRecord;
        
        Test.stopTest();
        
        Contact updatedContactRecord =[SELECT id, lastName,Account_Industry__c FROM Contact WHERE lastName = :UPDATED_CONACT_RECORD_NAME Limit 1];
        system.assertEquals(UPDATED_CONACT_RECORD_NAME, updatedContactRecord.LastName, 'Contact lastName should be updated.');
        system.assert(!String.isBlank(updatedContactRecord.Account_Industry__c), 'Account industry should be populated'); 
    }
    
    /*
    * @description: update more than one contact lastName when they have related account
    * expected result: contacts are updated and Account_Industry__c is populated
    */
    @isTest static void updateAccountIndustryOnContactsOnUpdateWithRelatedAccountTest() {
        
        List<Contact> contactRecordListBeforeUpdate =[SELECT id FROM Contact WHERE Account_Industry__c = null];
        Account accountRecord = [SELECT id FROM Account Limit 1];
        Test.startTest();
        
        FOR(Contact contactRecord : contactRecordListBeforeUpdate){
            contactRecord.AccountId = accountRecord.id;
        }
        update contactRecordListBeforeUpdate;
        
        Test.stopTest();
        
        List<Contact> updatedContactRecords =[SELECT id FROM Contact WHERE Account_Industry__c != null];
        system.assert(updatedContactRecords.size() == contactRecordListBeforeUpdate.size(), 'All contacts should be updated with account industry'); 
    }
    
    /*
    * @description: Insert contact where it has no related account
    * expected result: contact is inserted and account industry should remain empty
    */
    @isTest static void updateAccountIndustryOnContactOnInsertWithNoAccountTest() {
        
        Test.startTest();
        insert new contact(lastName=TEST_CONTACT);
        Test.stopTest();
        
        list<contact> insertedContact = [SELECT id, Account_Industry__c FROM Contact WHERE lastName=:TEST_CONTACT LIMIT 1];
        system.assertEquals(1, insertedContact.size(), 'Contact record should be inserted');
        system.assert(String.isBlank(insertedContact[0].Account_Industry__c), 'Account industry should be blank'); 

    }
    
    /*
    * @description: Insert contact where it has related account
    * expected result: contact is inserted and account industry should be populated
    */
    @isTest static void updateAccountIndustryOnContactOnInsertWithRelatedAccountTest() {
        
        Account accountRecord = [SELECT id FROM Account Limit 1];
        Test.startTest();
        insert new contact(lastName=TEST_CONTACT, AccountId=accountRecord.id);
        Test.stopTest();
        
        Contact insertedContactRecord =[SELECT id, Account_Industry__c FROM Contact WHERE lastName = :TEST_CONTACT Limit 1];
        system.assert(!String.isBlank(insertedContactRecord.Account_Industry__c), 'Account industry should be populated'); 
        
    }
    
    /*
    * @description: insert more than one contact where they have related accounts
    * expected result: contacts are inserted and account industry should be populated
    */
    @isTest static void updateAccountIndustryOnContactsOnInsertWithRelatedAccountTest() {
        
        Account accountRecord = [SELECT id FROM Account Limit 1];
        Test.startTest();
        
        List<contact> testContacts = new List<contact>();
        for(Integer i=0;i<5;i++) {
            testContacts.add(new Contact(Lastname = TEST_CONTACT+i, accountId=accountRecord.Id));
        }
        insert testContacts;
        
        Test.stopTest();
        
        List<Contact> insertContactRecords =[SELECT id FROM Contact WHERE Account_Industry__c != null];
        system.assert(5 == insertContactRecords.size(), 'All contacts should be inserted with account industry');
    }
    
}