import heapq
import threading

from ledger.side_enum import Side
from ledger.order import Order
from ledger.order_status_enum import order_status


class OrderBookPage:
    def __init__(self, ticker: str) -> None:

        self.page_lock = threading.RLock()

        self.ticker = ticker
        self.buy_book = []  #heap  
        heapq._heapify_max(self.buy_book)
        self.sell_book = [] #heap
        heapq.heapify(self.sell_book)

    def __AddOrder(self, order: Order) -> bool:
        with self.page_lock:
            #blindly add the order
            if order.side == Side.Buy:
                heapq.heappush(self.buy_book, order)
            else:
                heapq.heappush(self.sell_book, order)
        return True
    
    def __Match(self, order_buy : Order, order_sell : Order):
        print("Matching " + str(order_buy.id) + " with " + str(order_sell.id))
        with self.page_lock:
            # How many shares are we transacting?
            minVolume = min(order_buy.RemainingSize(), order_sell.RemainingSize())
            # Check which order was first and use that price
            print("Trade volume: " + str(minVolume))
            price = order_buy.price
            if order_sell.dateIn < order_buy.dateIn:
                price = order_sell.price
            print("Priced at: " + str(price))
            # Fill
            order_buy.Fill(minVolume, price, order_sell.id)
            order_sell.Fill(minVolume, price, order_buy.id)

            # Remove filled orders
            if(order_buy.GetStatus() == order_status.filled):
                heapq.heappop(self.buy_book)
            if(order_sell.GetStatus() == order_status.filled):
                heapq.heappop(self.sell_book)
    
    def __Balance(self) -> None:
        with self.page_lock:
            while True:
                if len(self.buy_book) == 0 or len(self.sell_book) == 0:
                    print("buy_book len: " + str(len(self.buy_book)) + "; sell_book len: " + str(len(self.sell_book)) + ".")
                    break

                best_buy = self.buy_book[0]
                best_sell = self.sell_book[0]

                if(best_buy.price >= best_sell.price):
                    self.__Match(best_buy, best_sell)
                else:
                    print("Pricing do not match")
                    break   

    def RemoveOrder(self, order: Order) -> bool:
        #TODO
        pass

    def ModifyOrder(self, order: Order) -> bool:
        #TODO
        pass

    def AppendOrder(self, order: Order) -> None:
        self.__AddOrder(order)
        self.__Balance()    
        self.print_all()

    # Aux methods 

    # Returns best buy (low), sell (high) prices and mid
    def GetPrices(self) -> []:
        best_buy = self.buy_book[0]
        best_sell = self.sell_book[0]
        average = (best_buy.price + best_sell.price ) / 2
        return tuple(best_buy.price, best_sell.price, average)
    
    def __print_list(self, orders: []) -> None:
        for order in orders:
            order.print()

    def print_all(self) -> None:
        print("")
        print("# Product ticker: " + self.ticker)
        print("## Current sell orders:" )
        self.__print_list(self.sell_book)
        print("## Current buy orders:" )
        self.__print_list(self.buy_book)
        print("")
        
        
