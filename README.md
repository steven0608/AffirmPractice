# AffirmPractice
This exercise is for Salesforce Development




Technical Documentation

Part 1: Create a custom text field on the Contact object, Account_Industry__c. Create a Contact trigger that pulls the Industry field from the related Account and populates the Account_Industry__c field on the Contact every time a Contact record is created or updated.

#### Based on the requirements, the following considerations and assumptions was made: 
    1. We want to update the Account_Industry__c field before it saved to the database, thereforce we use before trigger (before insert, before update)
    2. Account is a optinal lookup field
        Account_Industry__c can be empty if connact is not related to any account
    3. Trgger should be bulkified and be able to handle whether account is not exist to the contact or not

#### The following source(metadata) was created: 
    1. ContactTriggerHandler.cls (class)
    2. ContactTriggerHandlerTest.cls (class)
    3. ContactTrigger.trigger (trigger)
    4. Account_Industry__c.field-meta.xml (text field on contact object)





Part 2: Lightning Web Component: https://affirminterview-stevenchen-dev-ed--c.visualforce.com/apex/LWCDemo
#### Based on the requirements, the following considerations and assumptions was made: 
    1. we can display lightning web component using $Lightning.use in the visualforce page 
    2. In term of UX: since we are looking to load only 5 accounts to the UI on the initial load, and the length of the account name can be vary. I figure to display one account per row vertically. 
    3. State management (UI looks similar to screen flow) can be enhanced based on requirement on whether user will still want to see he/his previous selection after cliking back
        3a. In my implementation, users will still be able to see previous selected account
    4. There can be scenario where user didn't select account when clicking Next button
        4a. no callout should be made and alert is showed on the UI to remind user 

#### The following source(metadata) was created: 
    1. LWCDemo.page (VF page)
    2. AccountController.cls (class)
    3. accountUI (LWC)
    4. LWCDemoApp (aura app)