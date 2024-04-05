from helper_methods.id_generator import IDGenerator
from ledger.side_enum import Side
from ledger.order_status_enum import order_status
import datetime
#Container structure for orders
class Order:

    # Method to enable Order to be used in heapq 
    # return True if self is less than other, False otherwise
    def __lt__(self, other) -> bool:
        return self.price < other.price

    def __init__(self, ticker : str, size : int, price : float, side: Side, dateIn : datetime, senderID : str) -> None:
        self.id = IDGenerator.GetNewOrderId()
        self.ticker = ticker
        self.size = size
        self.filled_size = 0
        self.price = price
        self.side = side
        self.dateIn = dateIn
        self.senderID = senderID
        self.__status = order_status.new
        self.__associated_orders = []

    def print(self) -> None:
        print("ID       : " + str(self.id))
        print("ticker   : " + str(self.ticker))
        print("Size     : " + str(self.size))
        print("Filled   : " + str(self.filled_size))
        print("Price    : " + str(self.price))
        print("Date in  : " + str(self.dateIn))

    def RemainingSize(self) -> int:
        return self.size - self.filled_size

    def GetStatus(self) -> order_status:
        return self.__status
    
    def Fill(self, size: int, price: float, otherOID):
        #TODO: finish and correct
        self.filled_size += size
        if self.filled_size == self.size:
            self.__status = order_status.filled
        else:
            self.__status = order_status.partial_fill
        #Notify watchers
        

