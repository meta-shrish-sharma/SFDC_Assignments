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
        fflib_QueryFactory oQf = newQueryFactory()
            .setCondition('Id IN :recordIds');
        return Database.query(oQf.toSOQL() );
    }
    public List<Product2> selectProductForPagination(Integer limitValue, Integer offsetValue)
    {
        String query = String.format(
            'SELECT {0} FROM {1} ' +
            ' LIMIT {2} OFFSET {3}',
            new List<String> {
                getFieldListString(),
                    getSObjectName(),
                    String.valueOf(limitValue),
                    String.valueOf(offsetValue)
                    }
        );
        return (List<Product2>) Database.query(query);
    }
    public List<Product2> selectProductForPaginationWithSerch(Integer limitValue, Integer offsetValue, String searchPrdString)
    {
        String query = 'SELECT Id, Name, ProductCode, Description, ProductPrice__c, QuantityAvilable__c FROM Product2 WHERE Name LIKE \'%' + searchPrdString + '%\' ORDER BY Name LIMIT ' + limitValue + ' OFFSET ' + offsetValue;
        return (List<Product2>) Database.query(query);
    }
}