public class ProductSelector extends fflib_SObjectSelector
{
    public Schema.SObjectType getSObjectType()
    {
        return Product2.getSObjectType();
    }
    
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {Product2.Id, Product2.Name, Product2.ProductCode, Product2.Description, Product2.Description, Product2.ProductPrice__c, Product2.QuantityAvilable__c};
    } 
    public List<Product2> getAllProducts()
    {
        String query = newQueryFactory().toSOQL();
        return (List<Product2>) Database.query(query);
    }
    public List<Product2> selectProductById(Set<Id> recordIds)
    {
        if (recordIds.isEmpty()) return new list<Product2>(); // avoid burning SOQL
        fflib_QueryFactory oQf = newQueryFactory().setCondition('Id IN :recordIds');
        return Database.query(oQf.toSOQL() );
    }
    public List<Product2> selectProductForPagination(Integer limitValue, Integer offsetValue)
    {
        fflib_QueryFactory oQf = newQueryFactory().setLimit(limitValue).setOffset(offsetValue);
        return (List<Product2>) Database.query(oQf.toSOQL());
    }
    public List<Product2> selectProductForPaginationWithSerch(Integer limitValue, Integer offsetValue, String searchPrdString)
    {
        fflib_QueryFactory oQf = newQueryFactory().setLimit(limitValue).setOffset(offsetValue).setCondition('Name LIKE \'%' + searchPrdString + '%\'');
        System.debug(oQf.toSOQL());
        return (List<Product2>) Database.query(oQf.toSOQL());
    }
}