
local AddOnName, ImproveAny = ...

local tab = {}
function GetTokenList()
	tab = {}
	local max = 1
	if GetCurrencyListSize then
		max = GetCurrencyListSize()
	elseif C_CurrencyInfo.GetCurrencyListSize then
		max = C_CurrencyInfo.GetCurrencyListSize()
	end

	for  index = 1, max do
		local name, _, _, _, isWatched, count, icon, maxCount, _, _ = nil
		if GetCurrencyListInfo then
			name, _, _, _, isWatched, count, icon, maxCount, _, _ = GetCurrencyListInfo( index )
		elseif C_CurrencyInfo.GetCurrencyListInfo then
			info = C_CurrencyInfo.GetCurrencyListInfo( index )
			name = info.name
			isWatched = info.isShowInBackpack
			icon = info.iconFileID
			count = info.quantity
		end
		if name then
			if isWatched then
				tinsert( tab, {
					["name"] = name,
					["count"] = count,
					["icon"] = icon
				} )
			end
		else
			break
		end
	end

	if IATokenBar and IATokenBar.text then
		local text = ""
		for i, token in pairs( tab ) do
			if text ~= "" then
				text = text .. " "
			end
			text = text .. token.count .. "|T" .. token.icon .. ":0:0:0:0:64:64:2:38:2:38|t"
		end

		IATokenBar.text:SetText( text )
	end
end

IATokenBar = CreateFrame( "FRAME", "IATokenBar", UIParent )
IATokenBar:SetSize( 180, 20 )
IATokenBar:SetPoint( "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 130 )

function ImproveAny:InitTokenBar()
	if ImproveAny:IsEnabled( "TOKENBAR", true ) then
		IATokenBar.text = IATokenBar:CreateFontString( nil, "ARTWORK" )
		IATokenBar.text:SetFont( STANDARD_TEXT_FONT, 12, "THINOUTLINE" )
		IATokenBar.text:SetPoint( "CENTER", IATokenBar, "CENTER", 0, 0 )

		IATokenBar:RegisterEvent( "CURRENCY_DISPLAY_UPDATE" )
		IATokenBar:SetScript("OnEvent", function(self, ...)
			GetTokenList()
		end)
		if TokenFrame_Update then
			hooksecurefunc( "TokenFrame_Update", function()
				GetTokenList()
			end )
		end
		GetTokenList()
	end
end
