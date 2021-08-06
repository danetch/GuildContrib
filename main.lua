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





local sha = LibStub("Sha2-9.0")
local bcHelper = LibStub("BCHelper-1.0"):withSha(sha)




-- Next is : create the config menu where you can set the appropriate items to be proposed.
-- create the user interface that tells you what you have contributed this month, and what is the minimum contribution
-- Make it a rolling month upon completion of a call i.e if i don't complete a call 
-- create the officers interface to make a new call, and validate it.
-- create the interface to show who contributed to which call. (a grid like output probably)
