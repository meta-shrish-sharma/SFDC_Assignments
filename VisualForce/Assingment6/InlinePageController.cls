public class InlinePageController 
{
    public String teacherType{get;set;}
    private Id teachId;
    public InlinePageController(ApexPages.StandardController controller)
    {
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
            teachId = ApexPages.currentPage().getParameters().get('Id');
            teacherType = [SELECT Teacher_Type__c FROM Contact WHERE Id = :teachId][0].Teacher_Type__c;
        }
   }
}