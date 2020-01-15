public class FetchClassEditDelete
{
    private Boolean showHideVariable = false;//used to render edit section
    public Map<ID, Class__c> classDetails{get;set;}
    public Id selectedClassId{get;set;}
    public Class__c selectedClass{get;set;}
    public FetchClassEditDelete()
    {
        classDetails = new Map<ID, Class__c>([SELECT Name, Board__c, Fee__c, MyCount__c FROM Class__c]);
    }
    public Pagereference deleteRow()
    {
        if(classDetails.get(selectedClassId) != null)
        {
            Class__c deleteClass = classDetails.get(selectedClassId);
            delete deleteClass;
        }
        pagereference pg= new PageReference('/apex/ShowHidePage');
        pg.setRedirect(True);
        return pg;
    }
    public Void editRow()
    {
        selectedClass = [SELECT Id, Name, Board__c, Fee__c, MyCount__c FROM Class__c WHERE Id = :selectedClassId];
        if(classDetails.get(selectedClassId) != null)
        {
            Class__c editClass = classDetails.get(selectedClassId);
            selectedClass.Name = editClass.Name;
            selectedClass.Board__c = editClass.Board__c;
            selectedClass.Fee__c = editClass.Fee__c;
            selectedClass.MyCount__c = editClass.MyCount__c;
        }
        setHideshow(true);
    }
    public Pagereference updateClass()
    {
        update selectedClass;
        pageReference pg= new PageReference('/apex/ShowHidePage');
        pg.setRedirect(True);
        return pg;
    }
    //get values for picklist in custom object
    public List<SelectOption> getBoards()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Class__c.Board__c.getDescribe();
        List<Schema.PicklistEntry> pleBoards = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : pleBoards)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    public Boolean getHideShow()
    {
        return this.showHideVariable;
    }
    public void setHideShow(boolean s)
    {
        this.showHideVariable = s;
    }
}