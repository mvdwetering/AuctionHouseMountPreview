-- Allows players to preview mounts in the AH dressing room

local addonName, AHMP = ...

-- ## General 

-- Show the dressup frame when the item is a mount
function AHMP.ShowItem(itemId)
    -- Mounts
    if AHMP.mounts[itemId] then
        local creatureId = AHMP.mounts[itemId].creatureId
        
        -- Not sure why, but negative creatureIds need to be put in as the displayId
        if creatureId < 0 then
            displayId = creatureId * -1
            DressUpBattlePet(nil, displayId)
        else
            DressUpBattlePet(creatureId, 0)
        end
    end
end

-- ## AH related functions

-- In the onclick check if a mount was clicked and show it in the dressup frame
function AHMP.OnClickAh(auctionType, index)
    if ( IsModifiedClick("DRESSUP") ) then
        local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemId = GetAuctionItemInfo(auctionType, index)
        
        AHMP.ShowItem(itemId)
    end
end

function AHMP.BrowseButton_OnClick(button)
    AHMP.OnClickAh("list", button:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BrowseButtonItem_OnClick(button)
    AHMP.OnClickAh("list", button:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BidButton_OnClick(button)
    AHMP.OnClickAh("bidder", button:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BidButtonItem_OnClick(button)
    AHMP.OnClickAh("bidder", button:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.AuctionsButton_OnClick(button)
    AHMP.OnClickAh("owner", button:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.AuctionsButtonItem_OnClick(button)
    AHMP.OnClickAh("owner", button:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

-- ## Itemlinks (handles previews of chatlinks and BMAH)

function AHMP.DressUpItemLink(itemLink)
    -- Check for itemLink and extract itemID
    local itemId = string.match(itemLink, "item:(%d+)")
    if (itemId) then
        AHMP.ShowItem(tonumber(itemId))
        return
    end

    -- Check for spellLink and extract spellID (in case mount linked from the mount journal)
    local spellId = string.match(itemLink, "spell:(%d+)")
    if (spellId) then
        spellId = tonumber(spellId)
        for key,value in pairs(AHMP.mounts) do 
            if value.spellId == spellId then
                AHMP.ShowItem(key)
                return
            end
        end
    end
    
end

hooksecurefunc("DressUpItemLink", AHMP.DressUpItemLink)


-- ## Frame for eventhandling
AHMP.frame = CreateFrame("Frame", addonName.."Frame")
AHMP.frame:SetScript("OnEvent", function (self, event, ...)
        if ( event == "ADDON_LOADED") then
            local name = ...

            if (name == "Blizzard_AuctionUI") then
                -- Add a posthook to the OnClick of the AH buttons (there are seperate buttons for each tabbed view)
                -- The normal call will not work for mounts and the posthooked function only handles mounts so that should work fine together
                local i = 1
                while _G["BrowseButton"..i] do
                    _G["BrowseButton"..i]:HookScript("OnClick", AHMP.BrowseButton_OnClick)
                    _G["BrowseButton"..i.."Item"]:HookScript("OnClick", AHMP.BrowseButtonItem_OnClick)
                    _G["BidButton"..i]:HookScript("OnClick", AHMP.BidButton_OnClick)
                    _G["BidButton"..i.."Item"]:HookScript("OnClick", AHMP.BidButtonItem_OnClick)
                    _G["AuctionsButton"..i]:HookScript("OnClick", AHMP.AuctionsButton_OnClick)
                    _G["AuctionsButton"..i.."Item"]:HookScript("OnClick", AHMP.AuctionsButtonItem_OnClick)

                    i = i + 1
                end
            end
        end
    end)
AHMP.frame:RegisterEvent("ADDON_LOADED");
