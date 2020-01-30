public class ShoppingCartService implements IShoppingCartService
{
    public static void createPurchaseOrderLineItems(Map<Id, CartWrapperCls> cartList, Purchaseorder__c pOrder)
    {
        ShoppingCartServiceImp.createPurchaseOrderLineItems(cartList, pOrder);
    }
    
    public static Purchaseorder__c createPurchaseOrder(Decimal orderTotal, Integer randomNumber)
    {
        return ShoppingCartServiceImp.createPurchaseOrder(orderTotal, randomNumber);
    }
    
    public static Decimal cartProductOrderTotal(Map<Id, CartWrapperCls> cartList)
    {
        return ShoppingCartServiceImp.cartProductOrderTotal(cartList);
    }
    
    public static Map<Id, Product2WrapperCls> loadProductTable(Map<Id, CartWrapperCls> cartList, List<Product2> productList, Map<Id, Product2WrapperCls> productListTable)
    {
        return ShoppingCartServiceImp.loadProductTable(cartList, productList, productListTable);
    }
    
    public static Map<Id, CartWrapperCls> deleteFromCartList(Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        return ShoppingCartServiceImp.deleteFromCartList(cartList, prdId);
    }
    
    public static Map<Id, Product2WrapperCls> deleteFromProductList(Map<Id, Product2WrapperCls> productListTable, Id prdId)
    {
        return ShoppingCartServiceImp.deleteFromProductList(productListTable, prdId);
    }
    
    public static Map<Id, Product2WrapperCls> updatePrdListAfterDelete(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        return ShoppingCartServiceImp.updatePrdListAfterDelete(productListTable, cartList, prdId);
    }
    
    public static Map<Id, Product2WrapperCls> updatePrdListAfterUpdate(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId, Decimal maxPrdCount, Boolean checkoutDisable)
    {
        return ShoppingCartServiceImp.updatePrdListAfterUpdate(productListTable, cartList, prdId, maxPrdCount, checkoutDisable);
    }
    
    public static Map<Id, CartWrapperCls> addProductToCart(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        return ShoppingCartServiceImp.addProductToCart(productListTable, cartList, prdId);
    }
    
}