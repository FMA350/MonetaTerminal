#Generates ID for securities and orders
class IDGenerator:
    sid: int = 1000
    oid: int = 0
    def GetNewSecurityId() -> int:
        sid = IDGenerator.sid
        IDGenerator.sid += 1
        return sid
    
    def GetNewOrderId() -> int:
        oid = IDGenerator.oid
        IDGenerator.oid += 1
        return oid
    

