public class DeleteCheckedStudents
{
    webservice static String deleteStudents(List<String> stId) 
    {
        List<Student__c> st = [SELECT Id, Name FROM Student__c WHERE Id IN :stId];
        try 
        {
            delete st;
            return 'Success';
        } 
        catch(DmlException e) 
        {
            system.debug(e.getmessage());
            return 'Fail';
        }
    }
}