import random
from helper_methods.id_generator import IDGenerator

#likely to remove
class Security:
    def __init__(self, name: str, ticker: str):
        self.id = IDGenerator.GetNewSecurityId()
        self.name = name
        self.ticker = ticker
        # add SEDOL and other identifiers

