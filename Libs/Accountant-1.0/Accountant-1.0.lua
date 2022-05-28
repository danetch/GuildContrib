-- this is the library that takes care of the ledgers.
-- it decrypts them, it sorts which one we will keep
-- the crypto library is the thing that does hashing algorithm
-- the curve library does elliptic curves

local crypto = LibStub("Crypto-1.0")
local curve = LibStub("ec25519-1.0")
local db
local ledger
local Transaction = {
    id = 0,
    q = 0,
    pSignature,
    tDate,
    bTag,
    signature
}

local function SignTransaction(transaction, sk)
    if transaction.itemId == 0 or transaction.quantity == 0 or curve == nil then return end
    return curve.scalarmult(crypto.blake3(transaction.asString()), sk)
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

local Major, Minor = "Accountant-1.0", 1 
local Accountant, oldMinor = LibStub:NewLibrary(Major,Minor)
if not Accountant then return end
-- init ledger !
-- we must create the ledger if it doesn't exists already.
-- we must synchronize the ledgers if need be
-- 
local function Accountant:initialize(database)
    if not crypto then return end
    if not curve then return end 
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
    db = database
    local currentLedgerVersion = GetLedger().version
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

    for EncryptedLedger in ... do
        ledger = decryptLedger(EncryptedLedger)
        for transaction in ledger.transactions do
            if not bigmama[transaction.id] then bigmama[transaction.id] = transaction
            else 
                -- at this stage normally transactions don't need to be checked, they should have been already checked when they got out of the decryption factory
            

        -- add each 
    end
end

local Accountant:createIdentity(pwd)
{
    ---- create and save a private key based on a pwd
    ----

}




