from enum import Enum

#Loosely based on FIX 4.2 tag 39 values
class order_status(Enum):
    new = 0 
    partial_fill = 1 
    filled = 2
    cancelled = 4
    pending_cancel = 6
    stopped = 7
    rejected = 8
