-- enUS English

LANG_IA = LANG_IA or {}

function IAUpdateLanguageTab( tab )
	for i, v in pairs( tab ) do
		LANG_IA[i] = v
	end
end

function IALang_enUS()
	local tab = {
		["MMBTNLEFT"] = "Left Click => Locks/Unlocks + Options",
		["MMBTNRIGHT"] = "Right Click => Hide Minimap Button",

		["GENERAL"] = "General",
		["SHOWMINIMAPBUTTON"] = "Show Minimap Button",

		["QUICKGAMEPLAY"] = "Quick Gameplay",
		["FASTLOOTING"] = "Fast Looting",

		["CHAT"] = "Chat",
		["SHORTCHANNELS"] = "Short Chat Channels",
		["ITEMICONS"] = "Item Icons",
		["CLASSICONS"] = "Class Icons",
		["RACEICONS"] = "Race/BodyType Icons",
		["CHATLEVELS"] = "Player Levels",

		["MINIMAP"] = "Minimap",
		["MINIMAPHIDEBORDER"] = "Minimap Hide Border",
		["MINIMAPHIDEZOOMBUTTONS"] = "Minimap Hide Zoom Buttons",
		["MINIMAPSCROLLZOOM"] = "Minimap Zoom with Mousewheel",
		["MINIMAPSHAPESQUARE"] = "Square Minimap",

		["ITEMLEVEL"] = "ItemLevel",
		["ITEMLEVELNUMBER"] = "ItemLevel Number",
		["ITEMLEVELBORDER"] = "ItemLevel Border",

		["XPBAR"] = "XPBar",
		["XPLEVEL"] = "Character Level",
		["XPNUMBER"] = "XP Nummer",
		["XPPERCENT"] = "XP Percent",
		["XPMISSING"] = "Missing XP",
		["XPEXHAUSTION"] = "XP Exhaustion",
		["XPXPPERHOUR"] = "XP/Hour",
		["XPHIDEARTWORK"] = "XPBar Hide Artwork",

		["REPBAR"] = "Reputation Bar",
		["REPNUMBER"] = "Reputation Nummer",
		["REPPERCENT"] = "Reputation Percent",
		["REPHIDEARTWORK"] = "Reputation Bar Hide Artwork",

		["EXTRAS"] = "Extras",
		["MONEYBAR"] = "Money Bar",
		["TOKENBAR"] = "Token Bar",
		["SKILLBARS"] = "Skillbars (Professions, Weaponskills)",
		["CASTBAR"] = "Castbar",
		["DURABILITY"] = "Durability (Shows ItemLevel, Repaircosts)",
		["BAGS"] = "Show Freespace for each Bag",
		["WORLDMAP"] = "WorldMap Zoom with Mousewheel",
	}

	IAUpdateLanguageTab( tab )
end
