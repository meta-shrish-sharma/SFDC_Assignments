public class ShoppingCartServiceImp 
{
    public static void createPurchaseOrderLineItems(Map<Id, CartWrapperCls> cartList, Purchaseorder__c pOrder)
    {
        List<PurchaseOrderLineItems__c> orderLineList = new  List<PurchaseOrderLineItems__c>();
        for(Id cartProducts: cartList.keySet())
        {
            PurchaseOrderLineItems__c POL = new PurchaseOrderLineItems__c();
            POL.Product__c = cartList.get(cartProducts).cProduct.Id;
            POL.ProductQuantity__c = cartList.get(cartProducts).prdCount;
            POL.PurchaseOrder__c = pOrder.Id;
            POL.Name = cartList.get(cartProducts).cProduct.Name + ' Order';
            orderLineList.add(POL);
        }
        upsert orderLineList;
    }
    
    public static Purchaseorder__c createPurchaseOrder(Decimal orderTotal, Integer randomNumber)
    {
        Purchaseorder__c ord = new Purchaseorder__c();
        ord.OrderNumber__c = randomNumber;
        ord.OrderPlaceTime__c = System.Now();
        ord.OrderPrice__c = orderTotal;
        ord.OrderStatus__c = 'Pending';
        ord.User__c = UserInfo.getUserId();
        upsert ord;
        return ord;
    }
    
    public static Decimal cartProductOrderTotal(Map<Id, CartWrapperCls> cartList)
    {
        Decimal totalSum = 0;
        for(Id cartProducts: cartList.keySet())
        {
            if(cartList.get(cartProducts) != null)
                totalSum = totalSum + (cartList.get(cartProducts).cProduct.ProductPrice__c * cartList.get(cartProducts).prdCount);
        }
        return totalSum;
    }
    
    public static Map<Id, Product2WrapperCls> loadProductTable(Map<Id, CartWrapperCls> cartList, List<Product2> productList, Map<Id, Product2WrapperCls> productListTable)
    {
        for(Product2 prd: productList)
        {	
            if(cartList.get(prd.Id) != null)
            {
                if(cartList.get(prd.Id).prdCount > 0)
                {
                    prd.QuantityAvilable__c = prd.QuantityAvilable__c - cartList.get(prd.Id).prdCount;
                }
            }
            productListTable.put(prd.Id, new Product2WrapperCls(prd));
        }
        return productListTable;
    }
    
    public static Map<Id, CartWrapperCls> deleteFromCartList(Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        cartList.remove(prdId);
        return cartList;
    }
    
    public static Map<Id, Product2WrapperCls> deleteFromProductList(Map<Id, Product2WrapperCls> productListTable, Id prdId)
    {
        productListTable.remove(prdId);
        return productListTable;
    }
    
    public static Map<Id, Product2WrapperCls> updatePrdListAfterDelete(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        if(cartList.get(prdId).prdCount > 0)
        {
            productListTable.get(prdId).cProduct.QuantityAvilable__c = productListTable.get(prdId).cProduct.QuantityAvilable__c + cartList.get(prdId).prdCount;
        }
        return productListTable;
    }
    
    public static Map<Id, Product2WrapperCls> updatePrdListAfterUpdate(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId, Decimal maxPrdCount, Boolean checkoutDisable)
    {
        if(checkoutDisable == false)
        {
            productListTable.get(prdId).cProduct.QuantityAvilable__c = maxPrdCount - cartList.get(prdId).prdCount + 1;
        }
        else
        {
            productListTable.get(prdId).cProduct.QuantityAvilable__c = maxPrdCount;
        }
        return productListTable;
    }
    
    public static Map<Id, CartWrapperCls> addProductToCart(Map<Id, Product2WrapperCls> productListTable, Map<Id, CartWrapperCls> cartList, Id prdId)
    {
        if(cartList.get(productListTable.get(prdId).cProduct.Id) != null)
        {
            cartList.get(productListTable.get(prdId).cProduct.Id).prdCount++;
        }
        else
        {
            cartList.put(productListTable.get(prdId).cProduct.Id, new CartWrapperCls(productListTable.get(prdId).cProduct, 1));
        }
        return cartList;
    }
}