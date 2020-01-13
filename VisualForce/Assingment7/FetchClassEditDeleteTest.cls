@isTest
public class FetchClassEditDeleteTest 
{
	@testSetup 
    static void setup() 
    {
        List<Class__c> clsList = new List<Class__c>();
        for(Integer clsCount = 0; clsCount < 4; clsCount++)
        {
            clsList.add(new Class__c(Name = 'TestClass' + clsCount, MaxSize__c = 3, MyCount__c = 0));
        }
        insert clsList;
    }
    @isTest
    static void testFetchClassEditDelete_delete_deleteSelectedClass()
    {
        Class__c cls = [SELECT Id, Name FROM Class__c WHERE Name = 'TestClass0'];
        Test.setCurrentPage(Page.ShowHidePage);
        ApexPages.currentPage().getParameters().put('rowId', cls.Id);
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        pageController.deleteRow();
        List<Class__c> clsList = [SELECT Id, Name FROM Class__c WHERE Name = 'TestClass0'];
        System.assertEquals(0, clsList.size());
    }
    @isTest
    static void testFetchClassEditDelete_edit_editSelectedClass()
    {
        Class__c cls = [SELECT Id, Name FROM Class__c WHERE Name = 'TestClass0'];
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        pageController.editId = cls.Id;
        pageController.className = 'newTestClass0';
        pageController.board = 'Bihar';
        pageController.fee = 500;
        pageController.updateClass();
        List<Class__c> clsList = [SELECT Id, Name FROM Class__c WHERE Name = 'newTestClass0'];
        System.assertEquals(1, clsList.size());
    }
}
