public with sharing class JSONGenerator 
{
    public String jsonStr {get;set;}
    // constructor outer class
    public JSONGenerator()
    {
        jsonStr = prepareJSON();
    }
    private String prepareJSON() 
    {
        List<Class__c> classList = new  List<Class__c>();
        classList = [SELECT Name, Fee__c, MaxSize__c, MyCount__c FROM class__c];
        // Serialize the list of BillingStatement objects.
        jsonStr = JSON.serialize(classList);	
        // return the JSON string
        return jsonStr;
    }
}