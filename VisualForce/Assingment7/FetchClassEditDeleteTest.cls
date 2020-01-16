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
        Id clsId = [SELECT Id, Name FROM Class__c WHERE Name = 'TestClass0'].Id;
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        pageController.selectedClassId = clsId;
        pageController.deleteRow();
        List<Class__c> clsList = [SELECT Id, Name FROM Class__c WHERE Name = 'TestClass0'];
        System.assertEquals(0, clsList.size());
    }
    @isTest
    static void testFetchClassEditDelete_editSelect_editSelectedClass()
    {
        Class__c cls = [SELECT Id, Name, Board__c, Fee__c, MyCount__c FROM Class__c WHERE Name = 'TestClass0'];
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        pageController.selectedClassId = cls.Id;
        System.assertEquals(false, pageController.getHideShow());
        pageController.editRow();
        System.assertEquals(true, pageController.getHideShow());
        System.assertEquals(cls.Name, pageController.selectedClass.Name);
        System.assertEquals(cls.Board__c, pageController.selectedClass.Board__c);
        System.assertEquals(cls.Fee__c, pageController.selectedClass.Fee__c);
        System.assertEquals(cls.MyCount__c, pageController.selectedClass.MyCount__c);
    }
    @isTest
    static void testFetchClassEditDelete_edit_editClass()
    {
        Class__c cls = [SELECT Id, Name, Board__c, Fee__c, MyCount__c FROM Class__c WHERE Name = 'TestClass0'];
        cls.Name = 'New Test Class';
        cls.Board__c = 'BIHAR';
        cls.Fee__c = 500;
        cls.MyCount__c = 4;
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        pageController.selectedClass = cls;
        pageController.updateClass();
        Class__c updatedCls = [SELECT Id, Name, Board__c, Fee__c, MyCount__c FROM Class__c WHERE Id = :cls.Id];
        System.assertEquals(cls.Name, updatedCls.Name);
        System.assertEquals(cls.Board__c, updatedCls.Board__c);
        System.assertEquals(cls.Fee__c, updatedCls.Fee__c);
        System.assertEquals(cls.MyCount__c, updatedCls.MyCount__c);
    }
    @isTest
    static void testFetchClassEditDelete_pickListValues_getPickListValues()
    {
        FetchClassEditDelete pageController = new FetchClassEditDelete();
        List<SelectOption> pickListFields = pageController.getBoards();
        System.assertEquals(3, pickListFields.size());
    }
}
