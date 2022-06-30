GuildContrib = LibStub("AceAddon-3.0"):NewAddon("GuildContrib","AceConsole-3.0","AceEvent-3.0", "AceComm-3.0")
local Accountant = LibStub("Accountant-1.0")
local AceGUI = LibStub("AceGUI-3.0")
 
function GuildContrib:OnEnable()
    -- Called when the addon is enabled
end
function GuildContrib:OnDisable()
    -- Called when the addon is disabled
end
local function getRankValues()
    -- GET the guild ranks, then decide if the addon wielder is an officer rank <=1
    -- ddzdz

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

function qualifyGBT()
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
    -- les options de conf
    LibStub("AceConfig-3.0"):RegisterOptionsTable("Guild Contribution Manager", createOptions(), {"gcm"})
    --- chelou : options.var.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    --register for communication with the following prefixes
    GuildContrib:RegisterComm(mPrefixLedgerVersion)
    GuildContrib:RegisterComm(mPrefixRequestLedger)
    GuildContrib:RegisterComm(mPrefixSendLedger)
    GuildContrib:RegisterComm(mPrefixContConfigVersion)
    GuildContrib:RegisterComm(mPrefixRequestCC)
    GuildContrib:RegisterComm(mPrefixSendCC)
    Accountant:OnInitialize(self)
    -- Register for events here // Will be handle by function addon:name_of_event()
    -- Register for opening the guild bank.
    GuildContrib:RegisterEvent("GUILDBANKFRAME_OPENED")
end




--QuickSpec

-- Players can click on a button to contribute for the current timespan, when they get to the guild bank
-- Players can see at a glance their contribution status for the current timespan.
-- Players can click a button to see a window with players in y axis, timespans on x axis, and contributions.
-- The contribution frame on the guild bank tab doesn't show if the ledgers haven't been fully synchronized.
-- I nneed to understand directed acyclic graphs to understand how to implement one simply : I need to recognize individual items, and their place in the hierarchy.
-- If an item is entirely orphanned, for instance Alan Boris and Conrad are excahnging files, then they log off, 
-- and only Conrad logs back in (or not) when Daniel, Eve and Fernand get in the game
-- Then Daniel Eve and Fernand will start out of Conrad's version (or no version at all), and will add to that version.

-- if you don't have a ledger, and there is no one connected, and you are not the guild master, then the addon should ask that you wait for someone 
-- from your guild that has a ledger to show up.
-- A timespan is configured by the guildmaster
-- Players have to make the deposit on a deposit only tab, unless rank < X.
-- each deposit is a transaction in a ledger
-- accountant is the ledger handler, ledgers are transactionchains
-- We use ECC : PLC EC25519 /  Base is 9 in EC 22519. Then it is "just" scalar multiplications. https://github.com/philanc/plc/blob/master/plc/ec25519.lua
        -- generate a 32 bytes random string : this is our secretkey (which is also a 256 bit number :))))
        -- scalarmultiply the base to get the public key.
        -- use private key to sign transactions
        -- show public key in transaction to decrypt them
        -- have the previous transaction signature within the transaction parameters.

-- Using this allows for safe keeping of password
-- 
-- 
-- credits are due to https://github.com/Egor-Skriptunoff/pure_lua_SHA2
