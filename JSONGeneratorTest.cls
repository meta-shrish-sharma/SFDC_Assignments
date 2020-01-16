@isTest
public class JSONGeneratorTest 
{
    @testSetup 
    static void setup() 
    {
        List<Class__c> clsList = new List<Class__c>();
        for(Integer classCounter = 0; classCounter < 3; classCounter++) 
        {
            clsList.add(new Class__c(Name = 'TestClass ' + classCounter, MaxSize__c = 3, MyCount__c = 0));
        }
        insert clsList;
    }
    @isTest 
    static void testJSONGenrator_Json_getClassList() 
    {
        JSONGenerator classList = new JSONGenerator();
        List<Class__c> clsList = (List<Class__c>)System.JSON.deserialize(classList.jsonStr, List<Class__c>.class);
        System.assertEquals(3, clsList.size());  
    }
}