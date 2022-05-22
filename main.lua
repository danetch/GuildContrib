GuildContrib = LibStub("AceAddon-3.0"):NewAddon("GuildContrib","AceConsole-3.0","AceEvent-3.0", "AceComm-3.0")

 
function GuildContrib:OnEnable()
    -- Called when the addon is enabled
end
function GuildContrib:OnDisable()
    -- Called when the addon is disabled
end
local function getRankValues()
    -- GET the guild ranks, then decide if the addon wielder is an officer rank <=1
    -- 
end
local function showSubscriptionCreationPanel()
end   

-- prefix to broadcast the local lefger version
local mPrefixLedgerVersion = "GC_LV"
-- prefix to require ledger from someone (if ledger is outdated)
local mPrefixRequestLedger = "GC_RL"
-- prefix to send the ledger to someone
local mPrefixSendLedger = "GC_SL"
-- prefix to broadcast the contribution configuration version
local mPrefixContConfigVersion = "GC_CCV"
-- prefix to require the new configuration (beware you will need to ensure the configuration is from a trusted party)
local mPrefixRequestCC = "GC_RCC"
-- prefix to send the cc
local mPrefixSendCC = "GC_SCC"
local function createOptions()
    local opt = {
        name = "Guild Contribution Manager",
        handler = GuildContrib,
        type = 'group',
        args = {
            header = {
                type = "header",
                name = "General Options"},
            rank = {
                type = "select",
                name = "Minimum Edit Rank",
                desc = "Allows the rank selected and ranks above to edit the request for contribution, default is 2",
                values = getRankValues(),
            }
        },
        reminder = {name},
        


        }
    return opt
end
function GuildContrib:NAME_OF_EVENT()
end
function GuildContrib:OnCommReceived(prefix, message, distribution, sender)
    -- process the incomming message
end
-- register for events 
GuildContrib:RegisterEvent("NAME_OF_EVENT")
--register for communication with the following prefixes
GuildContrib:RegisterComm(mPrefixLedgerVersion)
GuildContrib:RegisterComm(mPrefixRequestLedger)
GuildContrib:RegisterComm(mPrefixSendLedger)
GuildContrib:RegisterComm(mPrefixContConfigVersion)
GuildContrib:RegisterComm(mPrefixRequestCC)
GuildContrib:RegisterComm(mPrefixSendCC)
function GuildContrib:OnCommReceived(prefix, message, distribution, sender)
    -- process the incomming message
    if prefix == mPrefixLedgerVersion then
        -- broadcast your LedgerVersion    
        GuildContrib:SendCommMessage(GuildContrib.db.LedgerVersion)
end
-- process the event "nameofevent"
--function GuildContrib:NAME_OF_EVENT()
--end
-- send comm to a guild addon channel
--GuildContrib:SendCommMessage("MyPrefix", "the data to send", "GUILD")
-- pr!ocess the communication on prefix "prefix"


function GuildContrib:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    -- this code is run only when everything is loaded.
    self.db = LibStub("AceDB-3.0"):New("GuildContribDB")
    -- choisir 
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Guild Contribution Manager", createOptions(), {"gcm"})
    options.var.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    -- send ledger version to the guild addon channel
    GuildContrib:SendCommMessage(mPrefix, GuildContrib.db.LedgerVersion, "GUILD")
end

local BCHelper = LibStub("BCHelper-1.0")


--QuickSpec

--Players can click on a button to contribute for the current timespan, when they get to the guild bank
--Players can see at a glance their contribution status for the current timespan.
--Players can click a button to see a window with players in y axis, timespans on x axis, and contributions.
--A timespan is configured by the guildmaster
--Players have to make the deposit on a deposit only tab, unless rank < X.
--each deposit is a transaction in a ledger
--ledger is a simplistic blockchain. 
--We use ECC : PLC BOX.lua + sha2.
--User enters a password that will be encrypted using his pair of keys :
--Public key is scalarmult(secret,base). Base is random 32 bytes. Secret is NOT-SO-RANDOM 32 Bytes they are the
-- Using this allow for safe keeping of password
-- Base is 9 in EC 22519. Then it is "just" scalar multiplications.
-- the id is: to generate a secret, as for a password, password is hashed. hash is used as a nonce
