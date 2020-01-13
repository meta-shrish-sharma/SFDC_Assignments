public class FetchClassEditDelete
{
    private Boolean showHideVariable = false;//used to render edit section
    private List<Class__c> classDetails;
    public String className{get;set;}
    public String board{get;set;}
    public Decimal fee{get;set;}
    public Decimal myCount{get;set;}
    public Id editId{get;set;}
    public FetchClassEditDelete()
    {
        classDetails = [SELECT Name, Board__c, Fee__c, MyCount__c FROM Class__c];
    }
    public List<Class__c> getClassDetails()
    {
        return classDetails;
    }
    public Pagereference deleteRow()
    {
        String selectedRowId = ApexPages.CurrentPage().getParameters().get('rowId');
        Class__c deletedClass = null;
        for(Class__c cls: classDetails)
        {
            if(cls.Id == selectedRowId) 
            {
                deletedClass = cls;
                break;
            } 
        }
        if(deletedClass != null) 
        {
            delete deletedClass;
        }
        pagereference pg= new PageReference('/apex/ShowHidePage');
        pg.setRedirect(True);
        return pg;
    }
    public Void editRow()
    {
        editId = ApexPages.CurrentPage().getParameters().get('eRowId');
        for(Class__c cls: classDetails)
        {
            if(cls.Id == editId) 
            {
                className = cls.Name;
                board = cls.Board__c;
                fee = cls.Fee__c;
                myCount = cls.MyCount__c;
                break;
            } 
        }
        setHideshow(true);
    }
    public Pagereference updateClass()
    {
        Class__c updClass = [SELECT Name, Board__c, Fee__c, MyCount__c FROM Class__c WHERE Id  = :editId];    
        updClass.Name = className;
        updClass.Board__c = board;	
        updClass.Fee__c = fee;	
        updClass.MyCount__c = myCount;	
        update updClass;
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
    public Boolean getHideshow()
    {
        return this.showHideVariable;
    }
    public void setHideshow(boolean s)
    {
        this.showHideVariable = s;
    }
}