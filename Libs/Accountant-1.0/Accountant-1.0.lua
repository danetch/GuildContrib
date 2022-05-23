-- this is the library that takes care of the ledgers.
-- 




------ define transactions ---
local encryptor = LibStub("Crypto-1.0")
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

local Major, Minor = "Ledger-1.0", 1 
local Ledger, oldMinor = LibStub:NewLibrary(Major,Minor)
if not Ledger then return end
-- init ledger !
-- we must create the ledger if it doesn't exists already.
-- we must synchronize the ledgers if need be
-- 
local function Ledger:initialize(database)
    if not encryptor then return end
    if not database then return end
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
    db = database
    
end
-- decrypt ledger and return it as a nice table
local function GetLedger()
    
    -- the goal is to be only able to read the item by decrypting each transaction using the public key of the owner.
    -- begets the question : how to store the thingy - probably a lua table?
    -- ledger probably gets a transaction id per transaction, agreed upon by ranks or consensus.
    -- ledger.version = integer.
    -- ledger
    if not db.global.ledger then return end

    return ledger 
end
local function GetledgerVersion()
    if not db.global.ledger then return 0
    else
        return db.global.ledger.version
    end
end
-- this should take any ledgers provided by guildies, dedup entries, and recreate a final ledger.
local function SynchronizeLedgers(...)
    local bigmama -- huge table with all transactions
    -- first put them all in ( can we see in advance what is different ?)

    for eLedger in ... do
        ledger = decryptLedger(eLedger)
        for transaction in ledger.transactions do
            if not bigmama[transaction.id] then bigmama[transaction.id] = transaction
            else 
                -- at this stage normally transactions don't need to be checked, they should have been already checked when they got out of the decryption factory
            

        -- add each 
    end
end





