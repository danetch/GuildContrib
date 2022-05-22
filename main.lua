GuildContrib = LibStub("AceAddon-3.0"):NewAddon("GuildContrib","AceConsole-3.0","AceEvent-3.0", "AceComm-3.0")
function GuildContrib:NAME_OF_EVENT()
end
function GuildContrib:OnCommReceived(prefix, message, distribution, sender)
    -- process the incomming message
end
-- register for events 
--GuildContrib:RegisterEvent("NAME_OF_EVENT")
--register for communication with the following prefixes
--GuildContrib:RegisterComm("prefix")
-- process the event "nameofevent"

-- send comm to a guild addon channel
--GuildContrib:SendCommMessage("MyPrefix", "the data to send", "GUILD")
-- process the communication on prefix "prefix"


function GuildContrib:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    -- this code is run only when everything is loaded.
    self.db = LibStub("AceDB-3.0"):New("GuildContribDB")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Guild Contribution Manager", createOptions(), {"gcm"})
end
  
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








