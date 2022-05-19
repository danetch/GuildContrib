------ define transactions ---
local encryptor
function withEncryptor(encrypter)
    encryptor = encrypter
end

local Transaction = {
    id = 0,
    q = 0,
    pHash,
    tDate,
    bTag,
    hash
}

function computeHash(transaction)
    if transaction.itemId == 0 or transaction.quantity == 0 or encryptor == nil then return end
    return encryptor.handler.blake3(transaction.asString())
end
function Transaction:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end
function Transaction:set(itemId,quantity,previousHash,transacDate,bTag)
    self.id = itemId
    self.q = quantity
    self.pHash = previousHash
    self.tDate = transacDate
    self.bTag = bTag
    self.hash = computeHash(self)
end
function Transaction:asString()
    local s = "{id:"..self.id..",q:"..self.q..",pHash:"..self.pHash..",tDate:"..self.tDate..",bTag:"..self.bTag.."}"
    return s
end
local Major, Minor = "BCHelper-1.0", 1 
local Helper, oldMinor = LibStub:NewLibrary(Major,Minor)
if not Helper then return end
 
function Helper:initializeBlocks ()
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
end

