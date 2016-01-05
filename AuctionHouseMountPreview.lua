-- Allows players to preview mounts in the AH dressing room

local addonName, AHMP = ...

-- In the onclick check if a mount was clicked and show it in the dressup frame
function AHMP.OnClick(self, auctionType, index)
    if ( IsModifiedClick("DRESSUP") ) then
        local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemId, _ = GetAuctionItemInfo(auctionType, index)
        
        if AHMP.mounts[itemId] then
            local creatureId = AHMP.mounts[itemId]
            
            -- Not sure why, but negative creatureIds need to be put in as the displayId
            if creatureId < 0 then
                displayId = creatureId * -1
                DressUpBattlePet(nil, displayId)
            else
                DressUpBattlePet(creatureId, 0)
            end
        end
    end
end


function AHMP.BrowseButton_OnClick(self)
    AHMP.OnClick(self, "list", self:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BrowseButtonItem_OnClick(self)
    AHMP.OnClick(self, "list", self:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BidButton_OnClick(self)
    AHMP.OnClick(self, "bidder", self:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.BidButtonItem_OnClick(self)
    AHMP.OnClick(self, "bidder", self:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.AuctionsButton_OnClick(self)
    AHMP.OnClick(self, "owner", self:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end

function AHMP.AuctionsButtonItem_OnClick(self)
    AHMP.OnClick(self, "owner", self:GetParent():GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame))
end


-- Add a posthook to the OnClick of the AH buttons (there are seperate buttons for each tabbed view)
-- The normal call will not work for mounts and my posthooked function only handles mounts so that should work fine together
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
