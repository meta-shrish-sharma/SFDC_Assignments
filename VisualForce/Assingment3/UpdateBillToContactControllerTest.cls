@isTest
public class UpdateBillToContactControllerTest 
{
    @testSetup 
    static void setup() 
    {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Prospecting';
        upsert opp;
        Contact ct = new Contact();
        ct.LastName = 'Test Contact';
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
    }
    @isTest
    static void testUpdateBillToContact_clear_clearUpdateBillToContact()
    {
        Opportunity opp = [SELECT Id, Name, BillToContact__c FROM Opportunity WHERE Name = 'Test Opportunity'];
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
}