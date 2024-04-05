from enum import Enum

class Side(Enum):
    Buy = 0
    Sell = 1

def get_side_from_str(input: str) -> Side :
        if input in ("B", "BUY", "Buy", "buy", "b"):
            return Side.Buy
        elif input in ("S", "SELL", "Sell", "sell", "s"):
            return Side.Sell
        else:
            raise ValueError( input + " cannot be parsed to Buy or Sell")
        
def get_str_from_side(input: Side) -> str:
        if input == Side.Buy:
            return "Buy"
        else:
             return "Sell"