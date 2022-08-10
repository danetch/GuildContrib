GuildContrib = LibStub("AceAddon-3.0"):NewAddon("GuildContrib","AceConsole-3.0","AceEvent-3.0", "AceComm-3.0")
local Accountant = LibStub("Accountant-1.0")
local AceGUI = LibStub("AceGUI-3.0")
local user
 
function GuildContrib:OnEnable()
    -- Called when the addon is enabled
end
function GuildContrib:OnDisable()
    -- Called when the addon is disabled
end

-- function getting and setting the minimum guild rank required to propose changes to configuration
function GuildContrib:GetRank()
    return self.db.factionrealm.config.rank
end
function GuildContrib:SetRank(info, value)
    self.db.factionrealm.config.rank = value
end



local function getUser()
    -- GET the guild ranks, then decide if the addon wielder is an officer rank <=1
    -- ddzdz
    --local guid = UnitGuid("player")
    -- user.rankOrder = C_GuildInfo.GetGuildRankOrder(guid)
    if user.status then return end
    user = {}
    user.guild, _, user.rank, user.realm = GetGuildInfo("player")
    _, user.battleTag, user.toonID, _, _, _, _ = BNGetInfo()
    user.status = 1
end
local function showSubscriptionCreationPanel()
end   

-- prefix to broadcast the local ledger version
GuildContrib.mPrefixLedgerVersion = "GC_LV"
-- prefix to require ledger from someone
GuildContrib.mPrefixRequestLedger = "GC_RL"
-- prefix to send the ledger to someone
GuildContrib.mPrefixSendLedger = "GC_SL"
-- prefix to broadcast the contribution configuration version
GuildContrib.mPrefixContConfigVersion = "GC_CCV"
-- prefix to require the new configuration (beware you will need to ensure the configuration is from a trusted party)
GuildContrib.mPrefixRequestCC = "GC_RCC"
-- prefix to send the cc
GuildContrib.mPrefixSendCC = "GC_SCC"
local function createOptions()
    local opt = {
        name = "Guild Contribution Manager",
        handler = GuildContrib, -- how to do this properly (tooo tiiiireeedd)
        type = 'group',
        args = {
            header = {
                type = "header",
                name = "General Options"},
            rank = {
                type = "select",
                name = "Minimum Edit Rank",
                desc = "Allows the rank selected and ranks above to edit the request for contribution, default is 2",
                values = getGuildRanksTable(),
                get = GetRank,
                set = SetRank
            }
        },
        reminder = {name},
        }
    return opt
end

local function getGuildRanksTable() 
-- for the option screen, show the table of indices and names of ranks
    -- this might not be initialized at the start
    message("Got Guild ranks "..user==nil ) 
    local table = {}
    for i = 1, GuildControlGetNumRanks() do
        table[i] = GuildControlGetRankName(i)
    end
    return table
end


end
local function qualifyGBT()
    local tab = GetCurrentGuildBankTab()
    QueryGuildBankTab(tab)-- calling this because GetGuildBankTabInfo is bugged if you don't.
    local name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals, filtered  = GetGuildBankTabInfo(tab)
    local canDeposit = IsGuildLeader() or (numWithdrawals==0 and isViewable and canDeposit)
    return canDeposit

end

function contribute()
end




function displayContributionFrame(GuildBankTabIsOk)
    -- ATTACH ACE ADDON SHIT.
    -- Create a container frame
    local f = AceGUI:Create("Frame")
    f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    f:SetTitle("Contribution Summary")
    f:SetStatusText("Currently completely unable to work out how to make this dynamic")
    f:SetLayout("Flow")
    if GuildBankTabIsOk then
        local btn = AceGUI:Create("Button")
        btn:SetText("Contribute!")
        btn:SetCallback("OnClick",contribute())
        f:addChild(btn)
    end

end


function GuildContrib:GUILD_ROSTER_UPDATE()
    -- This is SUPPOSEDLY ensuring we are ready to get player's info.
    -- Register for opening the guild bank.
    getUser()
end

function GuildContrib:PLAYER_GUILD_UPDATE()
    -- This is SUPPOSEDLY ensuring we are ready to get player's info.
    getUser()
end

function GuildContrib:GUILDBANKFRAME_OPENED()
    -- qualify the bank tab 
    
    displayContributionFrame(qualifyGBT())

end

function GuildContrib:OnCommReceived(prefix, message, distribution, sender)
    -- process the incomming message
    if prefix == mPrefixLedgerVersion qnd distribution =="GUILD" then
        -- we are receiving the ledgerversion from someone
        Accountant:processLedgerVersion(message.version)
    end

end

function getFDOBT()
    -- returns the First Deposit-Only Bank Tab index.
    local index = 8
    
    return index
end

function GuildContrib:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    -- this code is run only when everything is loaded.
    self.db = LibStub("AceDB-3.0"):New("GuildContribDB")
    -- in case config doesn't yet exist on first install.
    if not self.db.factionrealm.config then 
        self.db.factionrealm["config"] ={
            rank = 1,
            timespan = "month",
            -- this comes with an index and a structure that should contain the equivalence between members
            -- for instance an ID for the 1 feast, should have equivalence to X + Y + Z items.
            -- this is obvisouly a tree.
            items = 
            -- feast q is the necessary quantity, each quantity in the children is per unit
            {id=172043,q=11,contains={{id=173036,q=10},{id=173034,q=10},{172053=10,172055=10,173037=5}},
            -- Flask
            {171276={q=,c={}}
            -- Potion
            

                
            },
            banktab = getFDOBT(),
            goldEquivalent = 10000

        }
    end
    -- les options de conf
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Guild Contribution Manager", createOptions(), {"gcm"})
    self.BlizzDialog = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Profiles", "Profiles", "MyApplicationName");
    --register for communication with the following prefixes
    GuildContrib:RegisterComm(mPrefixLedgerVersion)
    GuildContrib:RegisterComm(mPrefixRequestLedger)
    GuildContrib:RegisterComm(mPrefixSendLedger)
    GuildContrib:RegisterComm(mPrefixContConfigVersion)
    GuildContrib:RegisterComm(mPrefixRequestCC)
    GuildContrib:RegisterComm(mPrefixSendCC)
    Accountant:OnInitialize(self)
    -- Register for events here // Will be handle by function addon:name_of_event()
    GuildContrib:RegisterEvent("PLAYER_GUILD_UPDATE")
    GuildContrib:RegisterEvent("GUILD_ROSTER_UPDATE")
    -- Register for opening the guild bank.
    GuildContrib:RegisterEvent("GUILDBANKFRAME_OPENED")
    
end




--QuickSpec

-- Players can click on a button to contribute for the current timespan, when they get to the guild bank
-- Players can see at a glance their contribution status for the current timespan.
-- Players can click a button to see a window with players in y axis, timespans on x axis, and contributions.
-- The contribution frame on the guild bank tab doesn't show if the ledgers haven't been fully synchronized.

-- How to ensure forgery of a transaction is impossible ?
-- anyone can write shit in the ledger, so there must be a mechanism that verifies that the actual action was performed.
-- or can we create signatures based on the when the item was received in the bag? 
-- the addon's code can be compromised, and be changed to create fake transactions that never happened.
-- EASY ! read the number of guild bank items after the transaction ! 
-- and have it read by OTHERS ! so they must also have bad code, which is against the shit ! but that requires that people are at the guild bank to do this
-- OR some variation of this : read the amount of the good present in bank at the moment of the contribution, put it in the transaction, and put the new number in the transaction
-- The next person contributing will be the one validating the previous transaction by ensuring the amount that is advertised in the ledger is less or equal to the amount in the bank.
-- HOORAY it works : it means that there must be a validating mode for officers, to see and reconcile all pending transactions to validate, it means the transactions must be passed onto each others asap
-- if there is a Lonely transaction, then insert it in the ledger where appropriate ? (where ?)
-- ledger is : {{base : items to be tracked + the count in bank},{transaction1 :{items: {id,amountfrom,amountto},validation:{name,publickey,amountinbankwhenvalidatedencryptedbykey}]}
-- 
-- if you don't have a ledger, and there is no one connected, and you are not the guild master, then the addon should ask that you wait for someone 
-- from your guild that has a ledger to show up.
-- A timespan, items to watch for, and a bank tab with deposit only are the options that are configured by the guildmaster or officers
-- each deposit is a transaction in a ledger
-- accountant is the ledger handler, ledgers are transactionchains
-- 




--We use ECC : PLC EC25519 /  Base is 9 in EC 22519. Then it is "just" scalar multiplications. https://github.com/philanc/plc/blob/master/plc/ec25519.lua
        -- generate a 32 bytes random string : this is our secretkey (which is also a 256 bit number :))))
        -- scalarmultiply the base to get the public key.
        -- use private key to sign transactions
        -- show public key in transaction to decrypt them
        -- have the previous transaction signature within the transaction parameters.

-- Using this allows for safe keeping of password
-- 
-- 
-- credits are due to https://github.com/Egor-Skriptunoff/pure_lua_SHA2
