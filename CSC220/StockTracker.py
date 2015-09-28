class StockTracker():
# Initializes the StockTrader Class
    def __init__(self):
        self.queue=[]
        self.profit=0.0
# Buys stock and stores amount and value stock was bought at on queue.
    def buy(self,quantity,price):
        assert(quantity>0 and isinstance(quantity, int)),"Invalid quantity."
        assert(price>0 and isinstance(price, float)),"Invalid price."
        tmpNode=_Node(quantity,price)
        self.queue.append(tmpNode)
# Sells stock by removing stock form queue and returns capital gain from this transaction.        
    def sell(self,quantity,price):
        assert(quantity>0 and isinstance(quantity, int)),"Invalid quantity."
        assert(price>0 and isinstance(price, float)),"Invalid price."
        assert(quantity<=self.getQuantityOnHand()),"Not enough items on hand."
        capitalGain=0.0
        tmpQ=quantity
        while (tmpQ>0):
            if (self.queue[0].quantity>tmpQ):
                self.queue[0].quantity=self.queue[0].quantity-tmpQ
                capitalGain=capitalGain+tmpQ*(price-self.queue[0].price)
                self.profit=self.profit+capitalGain
                return capitalGain
            elif(self.queue[0].quantity==tmpQ):
                capitalGain=capitalGain+tmpQ*(price-self.queue[0].price)
                del self.queue[0]
                self.profit=self.profit+capitalGain
                return capitalGain
            else:
                tmpQ=tmpQ-self.queue[0].quantity
                capitalGain=capitalGain+self.queue[0].quantity*(price-self.queue[0].price)
                del self.queue[0]
# Returns the net gain or loss from stock transactions since StockTracker creation. 
    def getProfit(self):
        return self.profit
# Returns the amount of stock on hand.        
    def getQuantityOnHand(self):
        total=0
        for items in self.queue:
            total=total+items.quantity
        return total
# Private helper class that stores a stock's price and amount. 
class _Node():
    def __init__(self,quantity,price):
        self.quantity=quantity
        self.price=price
