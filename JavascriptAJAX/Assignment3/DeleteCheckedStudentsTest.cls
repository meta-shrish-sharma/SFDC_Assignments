@isTest
public class DeleteCheckedStudentsTest 
{
    @testSetup 
    static void setup() 
    {
        Class__c cls = new Class__c(Name = 'Test Class', MaxSize__c = 3, MyCount__c = 0);
        insert cls;
        List<Student__c> stdnt = new List<Student__c>();
        for(Integer i = 0;i < 3; i++) 
        {
            stdnt.add(new Student__c(Name = 'Test Student ' + i, Sex__c = 'F', LastName__c = 'Lastname ' + i, Class__c = cls.Id));
        }
        insert stdnt;
    }
    @isTest
    static void deleteCheckedStudentsTest_testDeleteStudent_deleteStudents()
    {
        List<Student__c> stListDelete = [SELECT Name FROM Student__c WHERE Name LIKE '%Test Student%'];
        List<String> studentIds = new List<String>();
        for(Student__c st: stListDelete)
            studentIds.add(st.Id);
        System.assertEquals(3, stListDelete.size());
        DeleteCheckedStudents.deleteStudents(studentIds);
        stListDelete = [SELECT Name FROM Student__c WHERE Name LIKE '%Test Student%'];
        System.assertEquals(0, stListDelete.size());
    }
}