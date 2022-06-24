-- this is the library that takes care of the ledgers.
-- it decrypts them, it sorts which one we will keep
-- the crypto library is the thing that does hashing algorithm
-- the curve library does elliptic curves : private / public keys

local crypto = LibStub("Crypto-1.0")
local curve = LibStub("Ec25519-1.0")
local Addon
local Ledger -- this is the current ledger object.

--[[
local Transaction = {
    id = 0, -- if 0 then it is gold
    q = 0, -- in gold, silver and copper after the dot.
    pSignature, -- previous transaction Hash, for the chain
    tDate, -- the transaction date as a utc timestamp i assume
    bTag, -- the battletag of the owner, probably will need to hash this.
    sig, 
}]]--

local function sign(transaction,sk)
    if (transaction.itemId == 0 and transaction.quantity == 0) or curve == nil then 
        -- if we don't have a curve we should opt out.
        return end
    return curve.scalarmult(crypto.blake3(transaction.asString()), sk)
end
function Ledger:createTransaction(itemId,quantity,previousSignature,transacDate,battleTag)
    local t = {
        id = itemId,
        q = quantity,
        pSig  = previousSignature,
        tDate = transacDate,
        bTag = battleTag,
        sig = sign(self,sk)
    }
    return t
end
function set(self,itemId,quantity,previousHash,transacDate,bTag)
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
function Accountant:initialize(addon)
    if not crypto then return end
    if not curve then return end 
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
    Addon = addon
    Ledger = GetLedger()
    local currentLedgerVersion = GetLedgerVersion()
    -- start asking everyone for his version
    Addon:SendCommMessage(Addon.mPrefixLedgerVersion,currentLedgerVersion,"GUILD")

end
-- decrypt ledger and return it as a nice table
local function GetLedger()
    
    -- the goal is to be only able to read the item by decrypting each transaction using the public key of the owner.
    -- begets the question : how to store the thingy - a lua table?
    -- ledger probably gets a transaction id per transaction, agreed upon by ranks or consensus.
    -- ledger.version = integer.
    -- ledger
    if not Addon.db.global.ledger then return end
    return ledger 
end
local function GetLedgerVersion()
    if not db.global.ledger then return 0
    else
        return db.global.ledger.version
    end
end
-- this should take any ledgers provided by guildies, dedup entries, and recreate a final ledger.
local function SynchronizeLedgers(...)
    local bigmama -- huge table with all transactions
    -- first put them all in ( can we see in advance what is different ?)
    -- directed Cyclic graphs ?

    for EncryptedLedger in ... do
        Ledger = decryptLedger(EncryptedLedger)
        for transaction in ledger.transactions do
            if not bigmama[transaction.id] then bigmama[transaction.id] = transaction
            else 
                -- at this stage normally transactions don't need to be checked, they should have been already checked when they got out of the decryption factory
        -- add each 
            end
        end

    end
end

function Accountant:processLedgerVersion(remoteVersion)
    -- compare both version and decide how to proceed.
    if remoteVersion == self.Ledger.version
end


local Accountant:createIdentity(pwd)
{
    ---- create and save a private key based on a pwd
    ----
}




