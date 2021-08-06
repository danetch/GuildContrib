------ define transactions ---
local sha
function withSha(sha)
    sha = sha
end

local Transaction = {
    id = 0,
    q = 0,
    pHash,
    tDate,
    bTag,
    hash
}
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
    self.computeHash()
end
function Transaction:asString()
    local s = "{id:"..self.id..",q:"..self.q..",pHash:"..self.pHash..",tDate:"..self.tDate..",bTag:"..self.bTag.."}"
    return s
end
function Transaction:computeHash()

    if self.itemId == 0 or self.quantity == 0 or sha == nil then return end
    self.hash = sha.new256(self.asString())
    
    
end

local Helper = {}

function Helper:initializeBlocks ()
    local presenceID, battleTag, toonID, currentBroadcast, bnetAFK, bnetDND, isRIDEnabled  = BNGetInfo()
end

