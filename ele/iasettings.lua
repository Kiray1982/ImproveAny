
local AddOnName, ImproveAny = ...

local config = {
	["title"] = format( "ImproveAny |T136033:16:16:0:0|t v|cff3FC7EB%s", "0.5.39" )
}



local font = "Interface\\AddOns\\ImproveAny\\media\\Prototype.ttf"
IAOldFonts = IAOldFonts or {}

local BlizDefaultFonts = {
	"STANDARD_TEXT_FONT",
	"UNIT_NAME_FONT",
	"DAMAGE_TEXT_FONT",
	"NAMEPLATE_FONT",
	"NAMEPLATE_SPELLCAST_FONT"
}

local BlizFontObjects = {
	SystemFont_NamePlateCastBar, SystemFont_NamePlateFixed, SystemFont_LargeNamePlateFixed, SystemFont_World, SystemFont_World_ThickOutline,

	SystemFont_Outline_Small, SystemFont_Outline, SystemFont_InverseShadow_Small, SystemFont_Med2, SystemFont_Med3, SystemFont_Shadow_Med3,
	SystemFont_Huge1, SystemFont_Huge1_Outline, SystemFont_OutlineThick_Huge2, SystemFont_OutlineThick_Huge4, SystemFont_OutlineThick_WTF,
	NumberFont_GameNormal, NumberFont_Shadow_Small, NumberFont_OutlineThick_Mono_Small, NumberFont_Shadow_Med, NumberFont_Normal_Med, 
	NumberFont_Outline_Med, NumberFont_Outline_Large, NumberFont_Outline_Huge, Fancy22Font, QuestFont_Huge, QuestFont_Outline_Huge,
	QuestFont_Super_Huge, QuestFont_Super_Huge_Outline, SplashHeaderFont, Game11Font, Game12Font, Game13Font, Game13FontShadow,
	Game15Font, Game18Font, Game20Font, Game24Font, Game27Font, Game30Font, Game32Font, Game36Font, Game48Font, Game48FontShadow,
	Game60Font, Game72Font, Game11Font_o1, Game12Font_o1, Game13Font_o1, Game15Font_o1, QuestFont_Enormous, DestinyFontLarge,
	CoreAbilityFont, DestinyFontHuge, QuestFont_Shadow_Small, MailFont_Large, SpellFont_Small, InvoiceFont_Med, InvoiceFont_Small,
	Tooltip_Med, Tooltip_Small, AchievementFont_Small, ReputationDetailFont, FriendsFont_Normal, FriendsFont_Small, FriendsFont_Large,
	FriendsFont_UserText, GameFont_Gigantic, ChatBubbleFont, Fancy16Font, Fancy18Font, Fancy20Font, Fancy24Font, Fancy27Font, Fancy30Font,
	Fancy32Font, Fancy48Font, SystemFont_NamePlate, SystemFont_LargeNamePlate, GameFontNormal, 

	SystemFont_Tiny2, SystemFont_Tiny, SystemFont_Shadow_Small, SystemFont_Small, SystemFont_Small2, SystemFont_Shadow_Small2, SystemFont_Shadow_Med1_Outline,
	SystemFont_Shadow_Med1, QuestFont_Large, SystemFont_Large, SystemFont_Shadow_Large_Outline, SystemFont_Shadow_Med2, SystemFont_Shadow_Large, 
	SystemFont_Shadow_Large2, SystemFont_Shadow_Huge1, SystemFont_Huge2, SystemFont_Shadow_Huge2, SystemFont_Shadow_Huge3, SystemFont_Shadow_Outline_Huge3,
	SystemFont_Shadow_Outline_Huge2, SystemFont_Med1, SystemFont_WTF2, SystemFont_Outline_WTF2, 
	GameTooltipHeader, System_IME,
}

local function IASaveOld( ele )
	if IAOldFonts[ ele ] == nil then
		IAOldFonts[ ele ] = _G[ ele ]
	end
end

function IAFonts()
	for i, fontName in pairs( BlizDefaultFonts ) do
		IASaveOld( fontName )
		if IAGV( "fontName", "Default" ) == "Default" then
			_G[fontName] = IAOldFonts[fontName]
		else
			_G[fontName] = font
		end
	end

	local ForcedFontSize = {10, 14, 20, 64, 64}
 
	for i, FontObject in pairs( BlizFontObjects ) do
		if FontObject and FontObject.GetFont then
			local oldFont, oldSize, oldStyle = FontObject:GetFont()
			if IAOldFonts[i] == nil then
				IAOldFonts[i] = oldFont
			end

			oldSize = ForcedFontSize[i] or oldSize
			
			if IAGV( "fontName", "Default" ) == "Default" then
				FontObject:SetFont( IAOldFonts[i], oldSize, oldStyle )
			else
				FontObject:SetFont( font, oldSize, oldStyle )
			end
		end
	end
end

local searchStr = ""
local posy = -4
local cas = {}
local cbs = {}
local dds = {}
local ebs = {}
local sls = {}

local function IASetPos( ele, key, x )
	ele:ClearAllPoints()
	if strfind( strlower( key ), strlower( searchStr ) ) then
		ele:Show()

		if posy < -4 then
			posy = posy - 10
		end
		ele:SetPoint( "TOPLEFT", IASettings.SC, "TOPLEFT", x or 6, posy )
		posy = posy - 24
	else
		ele:Hide()
	end
end

local function AddCategory( key )
	if cas[key] == nil then
		cas[key] = CreateFrame( "Frame", key .. "_Category", IASettings.SC )
		local ca = cas[key]
		ca:SetSize( 24, 24 )

		ca.f = ca:CreateFontString( nil, nil, "GameFontNormal" )
		ca.f:SetPoint( "LEFT", ca, "LEFT", 0, 0 )
		ca.f:SetText( IAGT( key ) )
	end

	IASetPos( cas[key], key )
end

local function AddCheckBox( x, key, val, func )
	if val == nil then
		val = true
	end
	if cbs[key] == nil then
		cbs[key] = CreateFrame( "CheckButton", key .. "_CB", IASettings.SC, "UICheckButtonTemplate" ) --CreateFrame( "CheckButton", "moversettingsmove", mover, "UICheckButtonTemplate" )
		local cb = cbs[key]
		cb:SetSize( 24, 24 )
		cb:SetChecked( ImproveAny:IsEnabled( key, val ) )
		cb:SetScript( "OnClick", function( self )
			ImproveAny:SetEnabled( key, self:GetChecked() )

			if func then
				func()
			end

			if IASettings.save then
				IASettings.save:Enable()
			end
		end)

		cb.f = cb:CreateFontString( nil, nil, "GameFontNormal" )
		cb.f:SetPoint( "LEFT", cb, "RIGHT", 0, 0 )
		cb.f:SetText( IAGT( key ) )
	end

	cbs[key]:ClearAllPoints()
	if strfind( strlower( key ), strlower( searchStr ) ) or strfind( strlower( IAGT( key ) ), strlower( searchStr ) ) then
		cbs[key]:Show()

		cbs[key]:SetPoint( "TOPLEFT", IASettings.SC, "TOPLEFT", x, posy )
		posy = posy - 24
	else
		cbs[key]:Hide()
	end
end

local function AddEditBox( x, key, val, func )
	if ebs[key] == nil then
		ebs[key] = CreateFrame( "EditBox", "ebs[" .. key .. "]", IASettings.SC, "InputBoxTemplate" )
		ebs[key]:SetPoint( "TOPLEFT", IASettings.SC, "TOPLEFT", x, posy )
		ebs[key]:SetSize( 360, 24 )
		ebs[key]:SetAutoFocus( false )
		ebs[key].text = IAGV( key, val )
		ebs[key]:SetText( IAGV( key, val ) )
		ebs[key]:SetScript( "OnTextChanged", function( self, ... )
			if self.text ~= ebs[key]:GetText() then
				IASV( key, ebs[key]:GetText() )

				if func then
					func()
				end
			end
		end )

		ebs[key].f = ebs[key]:CreateFontString( nil, nil, "GameFontNormal" )
		ebs[key].f:SetPoint( "LEFT", ebs[key], "LEFT", 0, 16 )
		ebs[key].f:SetText( IAGT( key ) )
	end
	IASetPos( ebs[key], key, x + 8 )
end

local function AddSlider( x, key, val, func, vmin, vmax, steps )
	if sls[key] == nil then
		sls[key] = CreateFrame( "Slider", "sls[" .. key .. "]", IASettings.SC, "OptionsSliderTemplate" )

		sls[key]:SetWidth( IASettings.SC:GetWidth() - 30 - x )
		sls[key]:SetPoint( "TOPLEFT", IASettings.SC, "TOPLEFT", x + 5, posy )

		sls[key].Low:SetText(vmin)
		sls[key].High:SetText(vmax)

		sls[key].Text:SetText(IAGT(key) .. ": " .. IAGV( key, val ) )

		sls[key]:SetMinMaxValues(vmin, vmax)
		sls[key]:SetObeyStepOnDrag(true)
		sls[key]:SetValueStep(steps)

		sls[key]:SetValue( IAGV( key, val ) )

		sls[key]:SetScript("OnValueChanged", function(self, val)
			--val = val - val % steps
			val = tonumber( string.format( "%" .. steps .. "f", val ) )
			if val and val ~= IAGV( key ) then
				IASV( key, val )
				sls[key].Text:SetText( IAGT( key ) .. ": " .. val )

				if func then
					func()
				end

				if IASettings.save then
					IASettings.save:Enable()
				end
			end
		end)
		posy = posy - 10
	end
	IASetPos( sls[key], key, x )
end

function ImproveAny:UpdateILVLIcons()
	PDThink.UpdateItemInfos()
	if IFThink and IFThink.UpdateItemInfos then
		IFThink.UpdateItemInfos()
	end
	if IAUpdateBags then
		IAUpdateBagsIlvl()
	end
end

function ImproveAny:UpdateRaidFrameSize()
	for i = 1, 40 do
		local frame = _G["CompactRaidFrame" .. i]
		if frame then
			local options = DefaultCompactMiniFrameSetUpOptions
			if ImproveAny:IsEnabled( "OVERWRITERAIDFRAMESIZE", false ) and IAGV( "RAIDFRAMEW", options.width ) and IAGV( "RAIDFRAMEH", options.height ) then
				frame:SetSize( IAGV( "RAIDFRAMEW", options.width ), IAGV( "RAIDFRAMEH", options.height ) )
			end

			if true then
				local index = 1
				local frameNum = 1
				local filter = nil
				
				while ( frameNum <= 10 ) do
					if frame.displayedUnit then
						local buffName = UnitBuff(frame.displayedUnit, index, filter)
						if ( buffName ) then
							local buffFrame = _G[frame:GetName() .. "Buff" .. i]
							if buffFrame then
								buffFrame:SetScale( IAGV( "BUFFSCALE", 0.8 ) )
							end
							frameNum = frameNum + 1
						else
							break
						end
					else
						break
					end
					index = index + 1
				end
			end

			if true then
				local index = 1
				local frameNum = 1
				local filter = nil
				
				while ( frameNum <= 10 ) do
					if frame.displayedUnit then
						local debuffName = UnitDebuff(frame.displayedUnit, index, filter)
						if ( debuffName ) then
							local debuffFrame = _G[frame:GetName() .. "Debuff" .. i]
							if debuffFrame then
								debuffFrame:SetScale( IAGV( "DEBUFFSCALE", 1 ) )
							end
							frameNum = frameNum + 1
						else
							break
						end
					else
						break
					end
					index = index + 1
				end
			end
		end
	end
end

function ImproveAny:UpdateUIParentAttribute()
	local topOffset = IAGV( "TOP_OFFSET", 116 )
	local leftOffset = IAGV( "LEFT_OFFSET", 16 )
	local panelSpacingX = IAGV( "PANEl_SPACING_X", 32 )
	UIParent:SetAttribute( "TOP_OFFSET", -topOffset )
	UIParent:SetAttribute( "LEFT_OFFSET", leftOffset )
	--UIParent:SetAttribute("CENTER_OFFSET", 400)
	--UIParent:SetAttribute("RIGHT_OFFSET", 400)
	UIParent:SetAttribute( "PANEl_SPACING_X", panelSpacingX )
end

function ImproveAny:ToggleSettings()
	ImproveAny:SetEnabled( "SETTINGS", not ImproveAny:IsEnabled( "SETTINGS", false ) )
	if ImproveAny:IsEnabled( "SETTINGS", false ) then
		IASettings:Show()
	else
		IASettings:Hide()
	end
end

function ImproveAny:InitIASettings()
	IASettings = CreateFrame( "Frame", "IASettings", UIParent, "BasicFrameTemplate" )
	IASettings:SetSize( 420, 420 )
	IASettings:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 )

	IASettings:SetFrameStrata( "HIGH" )
	IASettings:SetFrameLevel( 999 )

	IASettings:SetClampedToScreen( true )
	IASettings:SetMovable( true )
	IASettings:EnableMouse( true )
	IASettings:RegisterForDrag( "LeftButton" )
	IASettings:SetScript( "OnDragStart", IASettings.StartMoving )
	IASettings:SetScript( "OnDragStop", function()
		IASettings:StopMovingOrSizing()

		local p1, p2, p3, p4, p5 = IASettings:GetPoint()
		ImproveAny:SetElePoint( "IASettings", p1, _, p3, p4, p5 )
	end )
	if ImproveAny:IsEnabled( "SETTINGS", false ) then
		IASettings:Show()
	else
		IASettings:Hide()
	end

	IASettings.TitleText:SetText( config.title )

	IASettings.CloseButton:SetScript( "OnClick", function()
		ImproveAny:ToggleSettings()
	end )

	function IAUpdateElementList()
		local _, class = UnitClass( "PLAYER" )
		
		local sh = 24
		posy = -4

		if dds["FONT"] == nil then
			local fontNames = {
				["name"] = "fontNames",
				["parent"]= IASettings.SC,
				["title"] = "Ui Font",
				["items"]= { "Default", "Prototype" },
				["defaultVal"] = IAGV( "fontName", "Default" ), 
				["changeFunc"] = function( dropdown_frame, dropdown_val )
					IASV( "fontName", dropdown_val )
					IAFonts()
				end
			}
			dds["FONT"] = IACreateDropdown( fontNames, posy )
		end
		
		AddCategory( "GENERAL" )
		AddCheckBox( 4, "SHOWMINIMAPBUTTON", true, ImproveAny.UpdateMinimapButton )
		IASetPos( dds["FONT"], "FONT" )
		AddSlider( 4, "WORLDTEXTSCALE", 1.0, ImproveAny.UpdateWorldTextScale, 0.1, 2.0, 0.1 )
		AddSlider( 4, "MAXZOOM", ImproveAny:GetMaxZoom(), ImproveAny.UpdateMaxZoom, 1, ImproveAny:GetMaxZoom(), 0.1 )
		AddCheckBox( 4, "HIDEPVPBADGE", false )

		AddSlider( 4, "TOP_OFFSET", 116, ImproveAny.UpdateUIParentAttribute, 0.0, 600.0, 1 )
		AddSlider( 4, "LEFT_OFFSET", 16, ImproveAny.UpdateUIParentAttribute, 16.0, 400.0, 1 )
		AddSlider( 4, "PANEl_SPACING_X", 32, ImproveAny.UpdateUIParentAttribute, 10.0, 300.0, 1 )
		
		AddCheckBox( 4, "BAGSAMESIZE", true )
		AddSlider( 24, "BAGSIZE", 30, BAGThink.UpdateItemInfos, 20.0, 80.0, 1 )
		
		AddCategory( "QUICKGAMEPLAY" )
		AddCheckBox( 4, "FASTLOOTING", true )

		AddCategory( "COMBAT" )
		AddCheckBox( 4, "COMBATTEXTICONS", true )

		AddCategory( "CHAT" )
		AddCheckBox( 4, "CHAT", true )
		AddCheckBox( 24, "SHORTCHANNELS", true )
		AddCheckBox( 24, "ITEMICONS", true )
		AddCheckBox( 24, "CLASSICONS", true )
		AddCheckBox( 24, "RACEICONS", false )
		AddCheckBox( 24, "CHATLEVELS", true )

		AddCategory( "MINIMAP" )
		AddCheckBox( 4, "MINIMAP", true, ImproveAny.UpdateMinimapSettings )
		AddCheckBox( 24, "MINIMAPHIDEBORDER", true, ImproveAny.UpdateMinimapSettings )
		if IABUILDNR < 100000 then
			AddCheckBox( 24, "MINIMAPHIDEZOOMBUTTONS", true, ImproveAny.UpdateMinimapSettings )
		end
		AddCheckBox( 24, "MINIMAPSCROLLZOOM", true, ImproveAny.UpdateMinimapSettings )
		AddCheckBox( 24, "MINIMAPSHAPESQUARE", true, ImproveAny.UpdateMinimapSettings )
		AddCheckBox( 4, "MINIMAPMINIMAPBUTTONSMOVABLE", true, ImproveAny.UpdateMinimapSettings )
		
		AddCategory( "ITEMLEVEL" )
		AddCheckBox( 4, "ITEMLEVELNUMBER", true, ImproveAny.UpdateILVLIcons )
		AddCheckBox( 4, "ITEMLEVELBORDER", true, ImproveAny.UpdateILVLIcons )

		AddCategory( "XPBAR" )
		AddCheckBox( 4, "XPBAR", true )
		AddCheckBox( 24, "XPLEVEL", false )
		AddCheckBox( 24, "XPNUMBER", true )
		AddCheckBox( 24, "XPPERCENT", true )
		AddCheckBox( 24, "XPMISSING", true )
		AddCheckBox( 24, "XPEXHAUSTION", true )
		AddCheckBox( 24, "XPXPPERHOUR", true )
		AddCheckBox( 24, "XPHIDEARTWORK", true )

		AddCategory( "REPBAR" )
		AddCheckBox( 4, "REPBAR", true )
		AddCheckBox( 24, "REPNUMBER", true )
		AddCheckBox( 24, "REPPERCENT", true )
		AddCheckBox( 24, "REPHIDEARTWORK", true )

		if IABUILD ~= "RETAIL" then
			AddCategory( "UNITFRAMES" )
			AddEditBox( 4, "RFHIDEBUFFIDSINCOMBAT", "", ImproveAny.ShowMsgForBuffs )
			AddEditBox( 4, "RFHIDEBUFFIDSINNOTCOMBAT", "", ImproveAny.ShowMsgForBuffs )
			AddCheckBox( 4, "RAIDFRAMEMOREBUFFS", true )
			AddSlider( 24, "BUFFSCALE", 0.8, ImproveAny.UpdateRaidFrameSize, 0.4, 1.6, 0.1 )
			AddSlider( 24, "DEBUFFSCALE", 1.0, ImproveAny.UpdateRaidFrameSize, 0.4, 1.6, 0.1 )
			local options = DefaultCompactMiniFrameSetUpOptions
			AddCheckBox( 4, "OVERWRITERAIDFRAMESIZE", false )
			AddSlider( 24, "RAIDFRAMEW", options.width, ImproveAny.UpdateRaidFrameSize, 20, 300, 10 )
			AddSlider( 24, "RAIDFRAMEH", options.height, ImproveAny.UpdateRaidFrameSize, 20, 300, 10 )
		end

		AddCategory( "EXTRAS" )
		AddCheckBox( 4, "MONEYBAR", true )
		AddCheckBox( 4, "TOKENBAR", true )
		AddCheckBox( 4, "SKILLBARS", true )
		AddCheckBox( 4, "CASTBAR", true )
		AddCheckBox( 4, "DURABILITY", true )
		AddSlider( 24, "SHOWDURABILITYUNDER", 100, nil, 5, 100, 5 )
		AddCheckBox( 4, "BAGS", true )
		AddCheckBox( 4, "WORLDMAP", true )
	end

	IASettings.Search = CreateFrame( "EditBox", "IASettings_Search", IASettings, "InputBoxTemplate" )
	IASettings.Search:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", 12, -26 )
	IASettings.Search:SetSize( 400, 24 )
	IASettings.Search:SetAutoFocus( false )
	IASettings.Search:SetScript( "OnTextChanged", function( self, ... )
		searchStr = IASettings.Search:GetText()
		IAUpdateElementList()
	end )

	IASettings.SF = CreateFrame( "ScrollFrame", "IASettings_SF", IASettings, "UIPanelScrollFrameTemplate" )
	IASettings.SF:SetPoint( "TOPLEFT", IASettings, 8, -30 - 24 )
	IASettings.SF:SetPoint( "BOTTOMRIGHT", IASettings, -32, 24 + 8 )

	IASettings.SC = CreateFrame( "Frame", "IASettings_SC", IASettings.SF )
	IASettings.SC:SetSize( 400, 400 )
	IASettings.SC:SetPoint( "TOPLEFT", IASettings.SF, "TOPLEFT", 0, 0 )

	IASettings.SF:SetScrollChild( IASettings.SC )

	IASettings.SF.bg = IASettings.SF:CreateTexture( "IASettings.SF.bg", "ARTWORK" )
	IASettings.SF.bg:SetAllPoints( IASettings.SF )
	IASettings.SF.bg:SetColorTexture( 0.03, 0.03, 0.03, 0.5 )

	IASettings.save = CreateFrame( "BUTTON", "IASettings" .. ".save", IASettings, "UIPanelButtonTemplate" )
	IASettings.save:SetSize( 120, 24 )
	IASettings.save:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", 4, -IASettings:GetHeight() + 24 + 4 )
	IASettings.save:SetText( SAVE )
	IASettings.save:SetScript("OnClick", function()
		C_UI.Reload()
	end)
	IASettings.save:Disable()

	IASettings.reload = CreateFrame( "BUTTON", "IASettings" .. ".reload", IASettings, "UIPanelButtonTemplate" )
	IASettings.reload:SetSize( 120, 24 )
	IASettings.reload:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", 4 + 120 + 4, -IASettings:GetHeight() + 24 + 4 )
	IASettings.reload:SetText( RELOADUI )
	IASettings.reload:SetScript("OnClick", function()
		C_UI.Reload()
	end)



	local dbp1, dbp2, dbp3, dbp4, dbp5 = ImproveAny:GetElePoint( "IASettings" )
	if dbp1 and dbp3 then
		IASettings:ClearAllPoints()
		IASettings:SetPoint( dbp1, UIParent, dbp3, dbp4, dbp5 )
	end
end
