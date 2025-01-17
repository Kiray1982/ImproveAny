
local AddOnName, ImproveAny = ...

local IAGlowAlpha = 0.75

local IAClassIDs = {2, 3, 4, 6, 8}
local IASubClassIDs15 = {5, 6} -- 15
local LEFTSLOTS = { 2, 3, 4, 5, 6, 10, 16, 20, 18 }
local RIGHTSLOTS = { 7, 8, 9, 11, 12, 13, 14, 15, 17 }
local slotbry = 0
local slotbrx = 3
local IACharSlots = {
	"AmmoSlot", -- 0,
	"HeadSlot", -- 1
	"NeckSlot", -- 2
	"ShoulderSlot", -- 3
	"ShirtSlot", -- 4
	"ChestSlot", -- 5
	"WaistSlot", -- 6
	"LegsSlot", -- 7
	"FeetSlot", -- 8
	"WristSlot", -- 9
	"HandsSlot", -- 10
	"Finger0Slot", -- 11
	"Finger1Slot", -- 12
	"Trinket0Slot", -- 13
	"Trinket1Slot", -- 14
	"BackSlot", -- 15
	"MainHandSlot", -- 16
	"SecondaryHandSlot", -- 17
	"RangedSlot", -- 18
	"TabardSlot", -- 19
	--"Bag0Slot",
	--"Bag1Slot",
	--"Bag2Slot",
	--"Bag3Slot"
}

function IAAddIlvl( SLOT, i )
	if SLOT and SLOT.iainfo == nil then
		local name = ""
		if SLOT.GetName then
			name = SLOT:GetName() .. "."
		end

		SLOT.iainfo = CreateFrame( "FRAME", name .. ".iainfo", SLOT )
		SLOT.iainfo:SetSize( SLOT:GetSize() )
		SLOT.iainfo:SetPoint( "CENTER", SLOT, "CENTER", 0, 0 )
		SLOT.iainfo:SetFrameLevel( 50 )
		SLOT.iainfo:EnableMouse( false )

		SLOT.iatext = SLOT.iainfo:CreateFontString(nil, "OVERLAY")
		SLOT.iatext:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
		SLOT.iatext:SetShadowOffset(1, -1)

		SLOT.iatexth = SLOT.iainfo:CreateFontString(nil, "OVERLAY")
		SLOT.iatexth:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
		SLOT.iatexth:SetShadowOffset(1, -1)

		SLOT.iaborder = SLOT.iainfo:CreateTexture("SLOT.iaborder", "OVERLAY")
		SLOT.iaborder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		SLOT.iaborder:SetBlendMode( "ADD" )
		SLOT.iaborder:SetAlpha( 1 )

		SLOT.iatext:SetPoint( "TOP", SLOT.iainfo, "TOP", 0, -slotbry )
		SLOT.iatexth:SetPoint( "BOTTOM", SLOT.iainfo, "BOTTOM", 0, slotbry )

		local NormalTexture = _G[SLOT:GetName() .. "NormalTexture"]
		if NormalTexture then
			local sw, sh = NormalTexture:GetSize()
			SLOT.iaborder:SetWidth(sw)
			SLOT.iaborder:SetHeight(sh)
		end

		SLOT.iaborder:SetPoint("CENTER")
	end
end

function ImproveAny:InitItemLevel()
	if PaperDollFrame then
		PDThink = CreateFrame("FRAME")

		PaperDollFrame.ilvl = PaperDollFrame:CreateFontString(nil, "ARTWORK")
		PaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
		PaperDollFrame.ilvl:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 24, -15)
		PaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")

		for i, slot in pairs(IACharSlots) do
			IAAddIlvl( _G["Character" .. slot], i )
		end

		function PDThink.UpdateItemInfos()
			local count = 0
			local sum = 0
			for i, slot in pairs(IACharSlots) do
				local id = i
				i = i - 1
				local SLOT = _G["Character" .. slot]
				if SLOT and SLOT.iatext ~= nil and GetInventoryItemLink and SLOT.GetID and SLOT:GetID() then
					local ItemID = GetInventoryItemLink("PLAYER", SLOT:GetID()) or GetInventoryItemID("PLAYER", SLOT:GetID())
					if ItemID ~= nil and GetDetailedItemLevelInfo then
						local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
						local ilvl, _, baseilvl = GetDetailedItemLevelInfo(ItemID)
						local color = ITEM_QUALITY_COLORS[rarity]
						local current, maximum = GetInventoryItemDurability(i)
						if current and maximum then
							local per = current / maximum
							if current == maximum then -- 100%
								SLOT.iatexth:SetTextColor(0,	1,		0,	1)
							elseif per == 0.0 then -- = 0%, black
								SLOT.iatexth:SetTextColor(0,	0,		0,	1)
							elseif per < 0.1 then -- < 10%, red
								SLOT.iatexth:SetTextColor(1,	0,		0,	1)
							elseif per < 0.3 then -- < 30%, orange
								SLOT.iatexth:SetTextColor(1,	0.65,	0,	1)
							elseif per < 1 then -- < 100%, red
								SLOT.iatexth:SetTextColor(1,	1,		0,	1)
							end
							if current ~= maximum then
								SLOT.iatexth:SetText( string.format("%0.0f", current / maximum * 100) .. "%" )
							else
								SLOT.iatexth:SetText( "" )
							end
						else
							SLOT.iatexth:SetText( "" )
						end
						if ilvl and color then
							if slot == "AmmoSlot" then
								local COUNT = _G["Character" .. slot .. "Count"]
								if COUNT.hooked == nil then
									COUNT.hooked = true
									COUNT:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
									SLOT.maxDisplayCount = 999999
									COUNT:SetText( COUNT:GetText() )
								end
							end
							if i ~= 4 and i ~= 19 and i ~= 20 then -- ignore: shirt, tabard, ammo
								if ilvl and ilvl > 1 then
									count = count + 1
									sum = sum + ilvl
								end
							end
							if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
								if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) and ilvl and ilvl > 1 then
									SLOT.iatext:SetText( color.hex .. ilvl )
								end
								local alpha = IAGlowAlpha
								if color.r == 1 and color.g == 1 and color.b == 1 then
									alpha = alpha - 0.2
								end
								if rarity and rarity > 1 and ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
									SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
								else
									SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
								end
							else
								SLOT.iatext:SetText("")
								SLOT.iatexth:SetText("")
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						else
							SLOT.iatext:SetText("")
							SLOT.iatexth:SetText("")
							SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
						end
					else
						SLOT.iatext:SetText("")
						SLOT.iatexth:SetText("")
						SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
					end
				end
			end
			
			if count > 0 then
				local max = 16 -- when only IAnhand
				if GetInventoryItemID("PLAYER", 17) then
					local t1, t2, rarity, ilvl, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo( GetInventoryItemLink("PLAYER", 17) )
					if t1 then -- when 2x 1handed
						max = 17
					end
				end
				if IABUILD == "RETAIL" then
					max = max - 1
				end

				IAILVL = string.format("%0.2f", sum / max)
				if true then
					PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVL)
				else
					PaperDollFrame.ilvl:SetText("")
				end
			else
				PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
			end
		end

		function PDThink.Loop()
			PDThink.UpdateItemInfos()
			C_Timer.After(1, PDThink.Loop)
		end
		C_Timer.After(1, PDThink.Loop)

		PDThink:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		PDThink:SetScript("OnEvent", function(self, event, slotid, ...)
			PDThink.UpdateItemInfos()
		end)

		PaperDollFrame.btn = CreateFrame("CheckButton", "PaperDollFrame" .. "btn", PaperDollFrame, "UICheckButtonTemplate")
		PaperDollFrame.btn:SetSize(20, 20)
		PaperDollFrame.btn:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 6, -10)
		PaperDollFrame.btn:SetChecked( ImproveAny:IsEnabled( "ITEMLEVEL", true ) )
		PaperDollFrame.btn:SetScript("OnClick", function(self)
			local newval = self:GetChecked()
			ImproveAny:SetEnabled( "ITEMLEVEL", newval )
			PDThink.UpdateItemInfos()
			if IFThink and IFThink.UpdateItemInfos then
				IFThink.UpdateItemInfos()
			end
			if IAUpdateBags then
				IAUpdateBagsIlvl()
			end
		end)

		-- Inspect
		function IAWaitForInspectFrame()
			if InspectPaperDollFrame then
				IFThink = CreateFrame("FRAME")

				InspectPaperDollFrame.ilvl = InspectPaperDollFrame:CreateFontString(nil, "ARTWORK")
				InspectPaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
				InspectPaperDollFrame.ilvl:SetPoint("TOPLEFT", InspectWristSlot, "BOTTOMLEFT", 24, -15)
				InspectPaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")

				for i, slot in pairs(IACharSlots) do
					IAAddIlvl(_G["Inspect" .. slot], i )
				end

				function IFThink.UpdateItemInfos()
					local count = 0
					local sum = 0
					for i, slot in pairs(IACharSlots) do
						local SLOT = _G["Inspect" .. slot]
						if SLOT and SLOT.iatext ~= nil and GetInventoryItemLink then
							local ItemID = GetInventoryItemLink("TARGET", SLOT:GetID()) --GetInventoryItemID("PLAYER", SLOT:GetID())
							if ItemID and GetDetailedItemLevelInfo then
								local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
								local ilvl, _, baseilvl = GetDetailedItemLevelInfo(ItemID)
								local color = ITEM_QUALITY_COLORS[rarity]

								if ImproveAny:IsEnabled( "ITEMLEVEL", true ) and ilvl and color then
									if i ~= 4 and i ~= 19 and i ~= 20 then -- ignore: shirt, tabard, ammo
										if ilvl and ilvl > 1 then
											count = count + 1
											sum = sum + ilvl
										end
									end
									if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
										if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) and ilvl and ilvl > 1 then
											SLOT.iatext:SetText(color.hex .. ilvl)
										end
										local alpha = IAGlowAlpha
										if color.r == 1 and color.g == 1 and color.b == 1 then
											alpha = alpha - 0.2
										end
										if rarity and rarity > 1 and ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
											SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
										else
											SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
										end
									else
										SLOT.iatext:SetText("")
										SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
									end
								else
									SLOT.iatext:SetText("")
									SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
								end
							else
								SLOT.iatext:SetText("")
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						end
					end
					if count > 0 then
						local max = 16 -- when only IAnhand
						local ItemID = GetInventoryItemLink("TARGET", 17)
						if GetItemInfo and GetInventoryItemID and ItemID ~= nil then
							local t1, t2, rarity, ilvl, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
							if t1 then -- when 2x 1handed
								max = 17
							end
						end
						if IABUILD == "RETAIL" then
							max = max - 1
						end
						IAILVLINSPECT = string.format("%0.2f", sum / max)
						if ImproveAny:IsEnabled( "ITEMLEVEL", true ) and ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) then
							InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVLINSPECT)
						else
							InspectPaperDollFrame.ilvl:SetText("")
						end
					else
						InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
					end
				end
				C_Timer.After(0.5, IFThink.UpdateItemInfos)
		
				IFThink:RegisterEvent("INSPECT_READY")
				IFThink:SetScript("OnEvent", function(self, event, slotid, ...)
					C_Timer.After(0.1, IFThink.UpdateItemInfos)
				end)
			else
				C_Timer.After(0.1, IAWaitForInspectFrame)
			end
		end
		IAWaitForInspectFrame()
		
		function IAGetContainerNumSlots( bagID )
			if C_Container and C_Container.GetContainerNumSlots then
				return C_Container.GetContainerNumSlots( bagID )
			end
			return GetContainerNumSlots( bagID )
		end

		function IAGetContainerItemLink( bagID, slotID )
			if C_Container and C_Container.GetContainerItemLink then
				return C_Container.GetContainerItemLink( bagID, slotID )
			end
			return GetContainerItemLink( bagID, slotID )
		end
		
		-- BAGS
		local once = true
		function ImproveAny:UpdateBag( bag, id )
			local name = bag:GetName()
			local bagID = bag:GetID()
			if GetCVarBool( "combinedBags" ) then
				bagID = id
			end

			local size = IAGetContainerNumSlots( bagID )

			for i = 1, size do
				local SLOT = _G[name .. "Item" .. i]
				if GetCVarBool( "combinedBags" ) then
					SLOT = _G[name .. "Item" .. i]
				end
				if SLOT then
					local slotID = size - i  + 1
					local slotLink = IAGetContainerItemLink( bagID, slotID )
					IAAddIlvl( SLOT, slotID )

					if slotLink and GetDetailedItemLevelInfo then
						local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, classID, subclassID = GetItemInfo( slotLink )
						local ilvl, _, baseilvl = GetDetailedItemLevelInfo(slotLink)
						local color = ITEM_QUALITY_COLORS[rarity]

						if ilvl and color then
							if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
								if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) and tContains(IAClassIDs, classID) or (classID == 15 and tContains(IASubClassIDs15, subclassID)) and ilvl and ilvl > 1 then
									SLOT.iatext:SetText(color.hex .. ilvl)
								else
									SLOT.iatext:SetText("")
								end
								local alpha = IAGlowAlpha
								if color.r == 1 and color.g == 1 and color.b == 1 then
									alpha = alpha - 0.2
								end

								if rarity and rarity > 1 and ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
									SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
								else
									SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
								end
							else
								SLOT.iatext:SetText("")
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						else
							SLOT.iatext:SetText("")
							SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
						end
					else
						SLOT.iatext:SetText("")
						SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
					end
				end
			end
		end
		function IAUpdateBagsIlvl()
			local tab = {}
			for i = 1, 20 do
				tinsert( tab, _G["ContainerFrame" .. i] )
			end

			if ContainerFrameCombinedBags and ContainerFrameCombinedBags.iasetup == nil then
				ContainerFrameCombinedBags.iasetup = true
				ContainerFrameCombinedBags:HookScript( "OnShow", function( self )
					IAUpdateBagsIlvl()
				end )
			end

			for x, bag in pairs( tab ) do
				if bag.iasetup == nil then
					bag.iasetup = true

					bag:HookScript( "OnShow", function( self )
						ImproveAny:UpdateBag( bag, x - 1 )
					end )
				end
				ImproveAny:UpdateBag( bag, x - 1 )
			end
		end
		
		local frame = CreateFrame("FRAME")
		frame:RegisterEvent("BAG_OPEN")
		frame:RegisterEvent("BAG_CLOSED")
		frame:RegisterEvent("QUEST_ACCEPTED")
		frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
		frame:RegisterEvent("BAG_UPDATE")
		frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
		frame:RegisterEvent("ITEM_LOCK_CHANGED")
		frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
		frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
		frame:RegisterEvent("INVENTORY_SEARCH_UPDATE")
		frame:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
		frame:RegisterEvent("BAG_SLOT_FLAGS_UPDATED")
		frame:SetScript( "OnEvent", function( self, event )
			IAUpdateBagsIlvl()
		end )
		IAUpdateBagsIlvl()
	end

	if IABUILD ~= "RETAIL" then
		-- Bag Searchbar
		BagItemSearchBox = CreateFrame("EditBox", "BagItemSearchBox", ContainerFrame1, "BagSearchBoxTemplate")
		BagItemSearchBox:SetSize(110, 18)
		BagItemSearchBox:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 50, -30)
		
		-- Bag SortButton
		BagItemAutoSortButton = CreateFrame("Button", "BagItemAutoSortButton", ContainerFrame1)
		BagItemAutoSortButton:SetSize(16, 16)
		BagItemAutoSortButton:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 164, -30)

		--[[
		BagItemAutoSortButton:SetNormalTexture("bags-button-autosort-up")
		BagItemAutoSortButton:SetPushedTexture("bags-button-autosort-down")
		BagItemAutoSortButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		]]

		BagItemAutoSortButton:SetScript("OnClick", function(self, ...)
			PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
			if SortBags then
				SortBags()
			elseif C_Container and C_Container.SortBags then
				C_Container.SortBags()
			end
		end)
		BagItemAutoSortButton:SetScript("OnEnter", function(self, ...)
			GameTooltip:SetOwner(self)
			GameTooltip:SetText(BAG_CLEANUP_BAGS)
			GameTooltip:Show()
		end)
		BagItemAutoSortButton:SetScript("OnLeave", function(self, ...)
			GameTooltip_Hide()
		end)
		
	end
end
