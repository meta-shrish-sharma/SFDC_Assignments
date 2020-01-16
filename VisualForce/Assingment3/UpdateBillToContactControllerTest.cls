@isTest
public class UpdateBillToContactControllerTest 
{
    @testSetup 
    static void setup() 
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        upsert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Prospecting';
        opp.Manager__c = acc.Id;
        upsert opp;
        Contact ct = new Contact();
        ct.LastName = 'Test Contact';
        ct.AccountId = acc.Id;
        upsert ct;
    }
    @isTest
    static void testUpdateBillToContact_update_updateUpdateBillToContact()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        Contact ct = [SELECT Id, Name FROM Contact WHERE LastName = 'Test Contact'];
        Test.setCurrentPage(Page.UpdateBillToContact);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        UpdateBillToContactController pageController = new UpdateBillToContactController();
        pageController.selectedCard = ct.Id;
        pageController.returnSavePage();
        opp = [SELECT BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        System.assertEquals(ct.Id, opp.BillToContact__c);
        System.assertEquals(1, pageController.getRecords().size());
    }
    @isTest
    static void testUpdateBillToContact_clear_clearUpdateBillToContact()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        Contact ct = [SELECT Id, Name FROM Contact WHERE LastName = 'Test Contact'];
        opp.BillToContact__c = ct.Id;
        update opp;
        Test.setCurrentPage(Page.UpdateBillToContact);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        UpdateBillToContactController pageController = new UpdateBillToContactController();
        pageController.returnClearPage();
        opp = [SELECT BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        System.assertEquals(null, opp.BillToContact__c);
    }
    @isTest
    static void testUpdateBillToContact_cancel_cancelUpdateBillToContact()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        Test.setCurrentPage(Page.UpdateBillToContact);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        UpdateBillToContactController pageController = new UpdateBillToContactController();
        PageReference pf = pageController.returnCancelPage();
        System.assertEquals('/' + opp.Id, pf.getUrl());
    }
    @isTest
    static void testUpdateBillToContact_errorZeroContacts_noRecordsFound()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        Contact ct = [SELECT Id, Name FROM Contact WHERE Name = 'Test Contact'];
        ct.AccountId = null;
        upsert ct;
        Test.setCurrentPage(Page.UpdateBillToContact);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        UpdateBillToContactController pageController = new UpdateBillToContactController();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('No records found')) foundErrorMessage = true;
        }
        system.assert(foundErrorMessage);
    }
    @isTest
    static void testUpdateBillToContact_errorManagerNull_noRecordsFound()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
        opp.Manager__c = null;
        upsert opp;
        Test.setCurrentPage(Page.UpdateBillToContact);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        UpdateBillToContactController pageController = new UpdateBillToContactController();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean foundErrorMessage = false;
        for(Apexpages.Message msg:msgs)
        {
            if (msg.getDetail().contains('No records found')) foundErrorMessage = true;
        }
        system.assert(foundErrorMessage);
    }
}
