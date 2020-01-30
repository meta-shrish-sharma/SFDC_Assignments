public class PurchaseOrdersSelector extends fflib_SObjectSelector
{
    public Schema.SObjectType getSObjectType()
    {
        return PurchaseOrder__c.getSObjectType();
    }
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {PurchaseOrder__c.Id, PurchaseOrder__c.OrderPrice__c, PurchaseOrder__c.Orderstatus__c};
            } 
    public List<PurchaseOrder__c> getAllPurchaseOrders()
    {
        String query = newQueryFactory().toSOQL();
        System.debug(query);
        return (List<PurchaseOrder__c>) Database.query(query);
    }
    public List<PurchaseOrder__c> getAllPurchaseOrdersSorted(String orderBy, String sortDirection)
    {
        String query = '';
        if(sortDirection == 'ASC')
            query = newQueryFactory().setOrdering(orderBy, fflib_QueryFactory.SortOrder.ASCENDING).toSOQL();
        else
            query = newQueryFactory().setOrdering(orderBy, fflib_QueryFactory.SortOrder.DESCENDING).toSOQL();
        return (List<PurchaseOrder__c>) Database.query(query);
    }
}