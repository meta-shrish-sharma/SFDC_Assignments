@isTest
public class StudentPDFVFPageControllerTest 
{
    @testSetup 
    static void setup() 
    {
        Class__c cls = new Class__c(Name = 'TestClass', MaxSize__c = 3, MyCount__c = 0);
        insert cls;
        Student__c st = new Student__c(Name = 'TestStudent', Class__c = cls.Id);
        insert st;
    }
    @isTest
    static void testStudentPDFController_attachment_createOrReplaceAttachment()
    {
        Student__c st = [SELECT Id, Name FROM Student__c WHERE Name = 'TestStudent'];
        Test.setCurrentPage(Page.StudentPDFVFPage);
        ApexPages.currentPage().getParameters().put('Id', st.Id);
        StudentPDFVFPageController stPDF = new StudentPDFVFPageController();
        stPDF.returnSavePDF();
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:st.id];
        System.assertEquals(1, attachments.size());
        System.assertEquals('TestStudent', stPDF.getStudents().Name);
    }
}