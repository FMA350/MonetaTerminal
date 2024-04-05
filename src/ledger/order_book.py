from threading import Lock

from helper_methods.singleton_meta import SingletonMeta
from ledger.order_book_page import OrderBookPage
from ledger.order import Order



# The OrderBook is the single holder of the state of this trading venue.
class OrderBook (metaclass=SingletonMeta):

    def __init__(self) -> None:
        self.pages = {} # list of securities tracked by the book
                        # with relative buy and sell heaps
        self.create_page_lock = Lock()  # Used only for creating new pages
                                        # Every other operation is asynch in this context

    def __has_book_for_security(self, ticker: str) -> bool:
        if ticker in self.pages:
            return True
        else:
            return False
        
    def __create_page(self, ticker) -> None:
        with self.create_page_lock:
            if self.__has_book_for_security(ticker):
                print("Warning: attempting to create an order book page for a security that already exists; returning...")
                return # Another process has created the security already 
            page = OrderBookPage(ticker)
            self.pages[ticker] = page

    def print_all(self) -> None:
        for page in self.pages.values():
            page.print_all()

    
    def add_order(self, new_order: Order) -> bool:
        # Check if an order page already exists in the book
        if self.__has_book_for_security(new_order.ticker):
            print("Page is present for " + new_order.ticker)
        else:
            print("Page not present for " + new_order.ticker + ". Creating...")
            self.__create_page(new_order.ticker)

        print("Adding order")
        self.pages[new_order.ticker].AppendOrder(new_order)
