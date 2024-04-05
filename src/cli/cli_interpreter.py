from datetime import datetime

from logger_factory.logger_factory import logger_factory 

from ledger.order import Order
from ledger.order_book import OrderBook
from ledger.side_enum import Side, get_side_from_str

class CLI:
    def __init__(self) -> None:
        self.running = True # Controls the status of the CLI
        self.context = ("main","$")  # Used to inform the user of contextual information (ex: submenu)
        self.logger  = logger_factory().make_logger("cli_logger")

    def __print_help(self) -> None:
        print("add \t Adds an order with the specified characteristics ")
        print("qadd \t Adds two orders for AAPL for quick testing")
        print("quit \t exists from the program")
        print("book_status \t  prints the status of the Order Book (and all orders in it)")
        print("help \t prints this help page")

    def __parse_add_order(self) -> Order:
        print("Additional info required: [side] [ticker] [qty] [price] -> OrderID")
        user_input = input("add_order$ ")
        tokens = user_input.split()
        try:
            side = tokens[0]
            ticker   = tokens[1]
            qty    = tokens[2]
            price  = tokens[3] #Currently a float, eventually a class of its own for precision
            order = Order(ticker, int(qty), float(price), get_side_from_str(side), datetime.now(), "CLI")
            self.logger.info(" new order created with ID: " + str(order.id))
            return order
        except Exception as e:
            self.logger.error("Failed to tokenize the input string")
            self.logger.error(e)
            
    # TODO: move to a map[string][function] and allow for extensions
    def __parse(self,user_input: str):
        self.logger.debug(f"received user input '{user_input}'")
        if(user_input == "help"):
            self.__print_help()
        elif(user_input == "quit"):
            self.running = False
        elif(user_input == "add"):
            order = self.__parse_add_order()
            # Pass the order to the appropriate OrderBookPage
            orderBook = OrderBook()
            orderBook.add_order(order)
        elif(user_input == "qadd"):
            order_buy1 = Order("AAPL", 50, 126.25, Side.Buy, datetime.now(), "CLI_B")
            order_buy2 = Order("AAPL", 20, 126.50, Side.Buy, datetime.now(), "CLI_B")
            OrderBook().add_order(order_buy1)
            OrderBook().add_order(order_buy2)
            order_sell = Order("AAPL", 200, 125.75, Side.Sell, datetime.now(), "CLI_S")
            OrderBook().add_order(order_sell)
        elif(user_input == "book_status"):
            OrderBook().print_all()
        else:
            self.logger.warning(user_input + " is an unknown command")
            self.__print_help();
    
    def MainLoop(self) -> None:
        while(self.running):
            user_input = input("$ ")
            self.__parse(user_input)

        self.logger.info("Shutting down the CLI interpreter")