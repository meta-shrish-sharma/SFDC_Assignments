public interface IShoppingCartService 
{
    void createPurchaseOrderLineItems(Map<Id, CartWrapperCls> cartList, Purchaseorder__c pOrder);
    Purchaseorder__c createPurchaseOrder(Decimal orderTotal, Integer randomNumber);
    Decimal cartProductOrderTotal(Map<Id, CartWrapperCls> cartList);
    Map<Id, Product2WrapperCls> loadProductTable(Map<Id, CartWrapperCls> cartList, List<Product2> productList, Map<Id, Product2WrapperCls> productListTable);
    Map<Id, CartWrapperCls> deleteFromCartList(Map<Id, CartWrapperCls> cartList, Id prdId);
    Map<Id, Product2WrapperCls> deleteFromProductList(Map<Id, Product2WrapperCls> productListTable, Id prdId);
    Map<Id, Product2WrapperCls> updatePrdListAfterDelete(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId);
    Map<Id, Product2WrapperCls> updatePrdListAfterUpdate(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId, Decimal maxPrdCount, Boolean checkoutDisable);
    Map<Id, CartWrapperCls> addProductToCart(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId);
    
}