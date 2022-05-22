------ define transactions ---
local encryptor = LibStub("Sha2-1.0")
local db
local ledger
local Transaction = {
    id = 0,
    q = 0,
    pHash,
    tDate,
    bTag,
    hash
}

local function computeHash(transaction)
    if transaction.itemId == 0 or transaction.quantity == 0 or encryptor == nil then return end
    return encryptor.handler.blake3(transaction.asString())
end
local function Transaction:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end
local function Transaction:set(itemId,quantity,previousHash,transacDate,bTag)
    self.id = itemId
    self.q = quantity
    self.pHash = previousHash
    self.tDate = transacDate
    self.bTag = bTag
    self.hash = computeHash(self)
end
local function Transaction:asString()
    local s = "{id:"..self.id..",q:"..self.q..",pHash:"..self.pHash..",tDate:"..self.tDate..",bTag:"..self.bTag.."}"
    return s
end

local Major, Minor = "BCHelper-1.0", 1 
local Helper, oldMinor = LibStub:NewLibrary(Major,Minor)
if not Helper then return end

-- init blockchain, and encryptor
local function Helper:initialize(database)
    if not encryptor then return end
    if not database then return end
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
    db = database
    
end
-- decrypt ledger and return it as a nice table
local function decryptLedger(EncryptedLedger)
    
    -- the goal is to be only able to read the item by decrypting each transaction using the public key of the owner.
    -- begets the question : how to store the thingy - probably a lua table?
    -- ledger probably gets a transaction id per transaction, agreed upon by ranks or consensus.
    -- ledger.version = integer.
    -- ledger

    return ledger 
end


