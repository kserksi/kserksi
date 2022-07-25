require = GLOBAL.require
STRINGS = GLOBAL.STRINGS
TheSim = GLOBAL.TheSim
TheNet = GLOBAL.TheNet
local debug = GLOBAL.debug
local OLDSTRINGS = nil

local this_mod = "workshop-1418746242"

-- 公共函数部分

local function GetConfig(name, default)
	if conf and type(conf)=="table" then
		for _,v in pairs(conf) do
			if v.name==name and v.saved then
				return v.saved
			end
		end
	end
	local data = GetModConfigData(name)
	if data == nil then return default end
	return data
end
local clearfont = GetConfig("clearfont", true)
local eventplus = GetConfig("eventplus", true)
local extratrans = GetConfig("extratrans", true)

function fileexists(name)
	local f=GLOBAL.io.open(name,"r")
	if f~=nil then
		GLOBAL.io.close(f) 
		return true 
	else 
		return false 
	end
end

function getval(fn, path)
	if fn == nil or type(fn)~="function" then return end
	local val = fn
	for entry in path:gmatch("[^%.]+") do
		local i = 1
		while true do
			local name, value = debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	return val, i
end

function setval(fn, path, new)
	if fn == nil or type(fn)~="function" then return end
	local val = fn
	local prev = nil
	local i
	for entry in path:gmatch("[^%.]+") do
		i = 1
		prev = val
		while true do
			local name, value = debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	debug.setupvalue(prev, i, new)
end

local languagemap={
	chs = "chs", 
	cht = "cht", 
	zh_CN = "chs", 
	cn = "chs", 
	TW = "cht",
	zh = "chs",
	schinese = "chs", 
	tchinese = "cht",
}

local function localsuffix()
	local lang = GLOBAL.LanguageTranslator.defaultlang
	local suffix
	if lang then
		suffix=languagemap[lang]
	else
		lang=GLOBAL.TheNet:GetLanguageCode()
		if lang then suffix=languagemap[lang] end
	end
	return suffix or ""
end

local suffix=localsuffix()

-- MOD函数扩展
function table.translate(tbl, trans)
	for k,v in pairs(tbl) do
		if trans[v] then
			tbl[k] = trans[v]
		end
	end
end

function ismodloaded(name)
	if GLOBAL.KnownModIndex:IsModEnabled(name) then return true end
	for _, v in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do
		if v == name then return true end
	end
end

local initprint = getval(AddTask, "initprint")

-- for terrible strings inside prefab files
function AddPostRegisterPrefabs(fn)
	local OldRegisterPrefabs = GLOBAL.ModManager.RegisterPrefabs
	function GLOBAL.ModManager:RegisterPrefabs()
		OldRegisterPrefabs(self)
		fn()
	end
end

-- for replicate components
postinitfns.ReplicateComponentPostInit={}
function AddReplicateComponentPostInit(component, fn)
	initprint("AddReplicateComponentPostInit", component)
	if postinitfns.ReplicateComponentPostInit[component] == nil then
		postinitfns.ReplicateComponentPostInit[component] = {}
	end
	table.insert(postinitfns.ReplicateComponentPostInit[component], fn)
end

local OldReplicateComponent=GLOBAL.EntityScript.ReplicateComponent
function GLOBAL.EntityScript:ReplicateComponent(name)
	OldReplicateComponent(self, name)
	local loadedcmp = GLOBAL.rawget(self,"replica") and GLOBAL.rawget(self.replica, "_")[name] or nil
	
	if loadedcmp~=nil then
		local postinitfns = GLOBAL.ModManager:GetPostInitFns("ReplicateComponentPostInit", name)
		for i, fn in ipairs(postinitfns) do
			fn(loadedcmp, self)
		end
	end
end

-- listeners hack
function RetrieveEventListener(source, event, inst)
	local listener = (source.event_listeners and source.event_listeners[event]) and source.event_listeners[event][inst] or nil
	local listening = (inst.event_listening and inst.event_listening[event]) and inst.event_listening[event][source] or nil
	return listener, listening
end

-- translation helpers
function AppendStrings(tbl)
	if tbl and type(tbl)=="table" then
		local lang = GLOBAL.LanguageTranslator.defaultlang
		if lang and GLOBAL.LanguageTranslator.languages[lang] then
			for k,v in pairs(tbl) do
				GLOBAL.LanguageTranslator.languages[lang][k]=v
			end
		end
	end
end

-- announce translation
local announce = {}

function AppendAnnounce(tbl)
	if tbl and type(tbl)=="table" then
		for k,v in pairs(tbl) do
			announce[k]=v
		end
	end
end

local netmt = GLOBAL.getmetatable(GLOBAL.TheNet).__index
if not netmt.chpp then
	netmt.chpp = true
	local OldAnnounce = netmt.Announce
	function netmt:Announce(str)
		OldAnnounce(self, announce[str] or str)
	end
end

-- retrieve api injected fns or data
function getmoddata(name, cat, id, path)
	local result = nil
	local mod = GLOBAL.ModManager:GetMod(name)
	if mod and mod.postinitfns[cat] then
		if id then
			result = mod.postinitfns[cat][id]
		else
			result = mod.postinitfns[cat]
		end
	end
	
	if path then
		if result and type(result)=="table" then
			for _,v in ipairs(result) do
				if type(v) == "function" then
					local val = getval(v, path)
					if val then return val end
				end
			end
		end
	else
		return result
	end
end

-- retrieve post class fns or data
function getclassdata(class, path, name)
	local classdef
	local postfns={}
	if name then
		require(class)
		classdef = GLOBAL.rawget(GLOBAL, name)
	else
		classdef = require(class)
	end
	
	if classdef and type(classdef) == "table" then
		local ctor = classdef._ctor
		repeat
			local postfn = getval(ctor, "postfn")
			if postfn and type(postfn) == "function" then
				table.insert(postfns, postfn)
			end
			ctor = getval(ctor, "constructor")
		until not ctor
	end
	
	if path then
		for _,v in ipairs(postfns) do
			local val = getval(v, path)
			if val then return val end
		end
	else
		return postfns
	end
end

-- 添加动态设置

local conf

GLOBAL.KnownModIndex.UpdateConfigurationOptions=function(self, config_options, savedata)
	local current={}
	for j,k in pairs(config_options) do
		current[k.name]=1
		for i,v in pairs(savedata) do
			if v.name == k.name and v.saved ~= nil then
				k.saved = v.saved
			end
		end
	end
	for k,v in pairs(savedata) do
		if current[v.name]==nil and string.match(v.name,"workshop%-%d+") then
			table.insert(config_options,v)
		end
	end
	conf=config_options
end

if not GLOBAL.TheNet:IsDedicated() or GLOBAL.TheNet:GetServerIsClientHosted() then
	GLOBAL.KnownModIndex:LoadModConfigurationOptions(this_mod,true)
end

local OldTranslateStringTable = GLOBAL.TranslateStringTable
GLOBAL.TranslateStringTable = function(...)

	-- 无汉化mod则加载官中
	if GLOBAL.LanguageTranslator and GLOBAL.LanguageTranslator.defaultlang == nil then
		if suffix == "chs" and fileexists("scripts/languages/chinese_s.po") then
			GLOBAL.LanguageTranslator:LoadPOFile("scripts/languages/chinese_s.po","chs")
		elseif suffix == "cht" and fileexists("scripts/languages/chinese_t.po") then
			GLOBAL.LanguageTranslator:LoadPOFile("scripts/languages/chinese_s.po","chs")
		end
	end
	
	-- 加载第三方MOD汉化
	if extratrans then
		local modlist=GLOBAL.KnownModIndex:GetModsToLoad()
		for _,v in ipairs(modlist) do
			if fileexists(MODROOT.."mods/main_"..suffix.."/"..v..".lua") and GetConfig(v,0)<1 then
				modimport("mods/main_"..suffix.."/"..v..".lua")
			end
		end
	end
	
	OldTranslateStringTable(...)
	for k,v in pairs(STRINGS.ACTIONS) do
		if GLOBAL.ACTIONS[k] then GLOBAL.ACTIONS[k].str = v end
	end
end

if GLOBAL.TheNet:IsDedicated() then
	return
end

-- 载入字体

if clearfont then
	local Assets = {}
	if fileexists("../data/fonts/normal.zip") then
		table.insert(Assets,GLOBAL.Asset("FONT", "../data/fonts/normal.zip"))
	else
		table.insert(Assets,GLOBAL.Asset("FONT", MODROOT.."fonts/normal.zip"))
	end
	if fileexists("../data/fonts/normal_outline.zip") then
		table.insert(Assets,GLOBAL.Asset("FONT", "../data/fonts/normal_outline.zip"))
	else
		table.insert(Assets,GLOBAL.Asset("FONT", MODROOT.."fonts/normal_outline.zip"))
	end

	local FONT_TABLE = {
		DEFAULTFONT = "cnfont_outline",
		DIALOGFONT = "cnfont_outline",
		TITLEFONT = "cnfont_outline",
		UIFONT = "cnfont_outline",
		BUTTONFONT = "cnfont",
		NEWFONT = "cnfont",
		NEWFONT_SMALL = "cnfont",
		NEWFONT_OUTLINE = "cnfont_outline",
		NEWFONT_OUTLINE_SMALL = "cnfont_outline",
		NUMBERFONT = "cnfont_outline",
		TALKINGFONT = "cnfont_outline",
		CHATFONT = "cnfont",
		HEADERFONT = "cnfont",
		CHATFONT_OUTLINE = "cnfont_outline",
		SMALLNUMBERFONT = "cnfont_outline",
		BODYTEXTFONT = "cnfont_outline",
		CODEFONT = "cnfont",
	}
	
	local function registerfont()
		TheSim:UnloadFont("cnfont")
		TheSim:UnloadFont("cnfont_outline")
		TheSim:UnloadPrefabs({"cnfonts_"..modname})
		TheSim:RegisterPrefab("cnfonts_"..modname, Assets, {})
		TheSim:LoadPrefabs({"cnfonts_"..modname})
		if fileexists("../data/fonts/normal.zip") then
			TheSim:LoadFont("../data/fonts/normal.zip", "cnfont")
		else
			TheSim:LoadFont(MODROOT.."fonts/normal.zip", "cnfont")
		end
		if fileexists("../data/fonts/normal_outline.zip") then
			TheSim:LoadFont("../data/fonts/normal_outline.zip", "cnfont_outline")
		else
			TheSim:LoadFont(MODROOT.."fonts/normal_outline.zip", "cnfont_outline")
		end
		TheSim:SetupFontFallbacks("cnfont", GLOBAL.DEFAULT_FALLBACK_TABLE)
		TheSim:SetupFontFallbacks("cnfont_outline", GLOBAL.DEFAULT_FALLBACK_TABLE_OUTLINE)
		for k,v in pairs(FONT_TABLE) do
			GLOBAL[k]=v
		end
	end
	
	local OldStart=GLOBAL.Start
	GLOBAL.Start=function()
		registerfont()
		OldStart()
	end
	
	local OldRegisterPrefabs=GLOBAL.ModManager.RegisterPrefabs
	GLOBAL.ModManager.RegisterPrefabs = function(...)
		OldRegisterPrefabs(...)
		registerfont()
	end

end

-- 活动汉化增强

if eventplus then
	require("klump")
	local OldApplyKlumpToStringTable=GLOBAL.ApplyKlumpToStringTable
	GLOBAL.ApplyKlumpToStringTable=function(string_id, json_str)
		OldApplyKlumpToStringTable(string_id, json_str)
		local trans = GLOBAL.LanguageTranslator:GetTranslatedString(string_id)
		if trans then
			table.setfield(string_id, trans)
		end
	end
	
	local event_list = {
		"quagmire",
	}
	
	local function IsEvent(world)
		local w = world or GLOBAL.TheWorld
		for _,v in pairs(event_list) do
			if w and w:HasTag(v) then return true end 
		end
		return false
	end
	
	local currentstring
	local context={}
	local playerlist={PLAYER = 1}
	
	local function context_translate(prefab, s)
		if context[prefab] then
			if playerlist[string.utf8upper(prefab)]  then
				if context[prefab] and context[prefab][string.utf8upper(s)] then
					return context[prefab][string.utf8upper(s)]
				else
					return context.wilson[string.utf8upper(s)]
				end
			else
				for i,v in ipairs(context[prefab]) do 
					if type(v.old)=="table" then
						if v.id then
							if s == v.old[v.id] then
								local temp = v.new[v.id]
								v.id=v.id+1
								if v.id>#(v.old) then
									table.remove(context[prefab],i)
								end
								return temp
							end
						else
							for kk, vv in pairs(v.old) do
								if s==vv then return v.new[kk] end
							end
						end
					else
						if s==v.old then return v.new end
					end
				end
			end
		end
	end

	local CHARACTERS =
	{
		GENERIC = "speech_wilson",
		WAXWELL = "speech_waxwell",
		WOLFGANG = "speech_wolfgang",
		WX78 = "speech_wx78",
		WILLOW = "speech_willow",
		WENDY = "speech_wendy",
		WOODIE = "speech_woodie",
		WICKERBOTTOM = "speech_wickerbottom",
		WATHGRITHR = "speech_wathgrithr",
		WEBBER = "speech_webber",
		WINONA = "speech_winona",
	}

	local quagmire_extra_root = {
		"ANNOUNCE_INV_FULL",
		"ACTIONFAIL_GENERIC",
		"DESCRIBE_GENERIC",
	}
	quagmire_extra_root = table.invert(quagmire_extra_root)
	
	local quagmire_extra_describe = {
	"TWIGS",
	"TRAP",
	"SPOILED_FOOD",
	"SMALLMEAT",
	"SAPLING",
	"ROCKS",
	"RABBIT",
	"POOP",
	"MEAT",
	"LOG",
	"FIREPIT",
	"EVERGREEN_SPARSE",
	"CARROT",
	"CARROT_COOKED",
	"PLANT_NORMAL",
	"BERRYBUSH",
	"BERRIES",
	"BERRIES_COOKED",
	"MINISIGN_ITEM",
	"MINISIGN",
	"BOOK_GARDENING",
	"WAXWELLJOURNAL",
	"FISHINGROD",
	"BIRDTRAP",
	"FERTILIZER",
	"FOLIAGE",
	"CAMPFIRE",
	}
	quagmire_extra_describe = table.invert(quagmire_extra_describe)
	
	local quagmire_fail_list = {
	"USEKLAUSSACKKEY.QUAGMIRE_WRONGKEY",
	"ACTIVATE.LOCKED_GATE",
	"RUMMAGE.GENERIC",
	"RUMMAGE.INUSE",
	"GIVE.GENERIC",
	"GIVE.SLOTFULL",
	"GIVE.FOODFULL",
	"GIVE.NOTDISH",
	"GIVETOPLAYER.FULL",
	"GIVETOPLAYER.BUSY",
	"PICKUP.INUSE",
	"REPLATE.MISMATCH",
	"REPLATE.SAMEDISH",
	}
	
	local function playercontext_quagmire(player)
		local charind = CHARACTERS[string.utf8upper(player)] and string.utf8upper(player) or "GENERIC"
		local f = GLOBAL.kleiloadlua("scripts/"..CHARACTERS[charind]..".lua")
		if type(f) == "function" then
			OLDSTRINGS.CHARACTERS[charind]=f()
		end
		context[player]={}
		for k,v in pairs(OLDSTRINGS.CHARACTERS[charind]) do
			if (string.match(k,"QUAGMIRE") or quagmire_extra_root[k]) and v ~= nil then
				context[player][string.utf8upper(v)] = STRINGS.CHARACTERS[charind][k]
			end
		end
		for k,v in pairs(OLDSTRINGS.CHARACTERS[charind].DESCRIBE) do
			if (string.match(k,"QUAGMIRE") or quagmire_extra_describe[k]) and v ~= nil then
				if type(v)=="string" then
					context[player][string.utf8upper(v)] = STRINGS.CHARACTERS[charind].DESCRIBE[k]
				elseif type(v)=="table" then
					for kk,vv in pairs(v) do
						if vv ~= nil then
							context[player][string.utf8upper(vv)] = STRINGS.CHARACTERS[charind].DESCRIBE[k][kk]
						end
					end
				end
			end
		end
		for _,v in ipairs(quagmire_fail_list) do
			local p1,p2=string.match(v,"^([%w_]+)%.([%w_]+)$") 
			if OLDSTRINGS.CHARACTERS[charind].ACTIONFAIL[p1] ~= nil and OLDSTRINGS.CHARACTERS[charind].ACTIONFAIL[p1][p2]~= nil then
				context[player][string.utf8upper(OLDSTRINGS.CHARACTERS[charind].ACTIONFAIL[p1][p2])] = STRINGS.CHARACTERS[charind].ACTIONFAIL[p1][p2]
			end
		end
	end
	
	for k,_ in pairs(CHARACTERS) do
		if k~= "GENERIC" then
			AddPrefabPostInit(string.lower(k), function(inst)
				if IsEvent() and playerlist[string.utf8upper(inst.prefab)]==nil then
					playerlist[string.utf8upper(inst.prefab)] = 1
					if GLOBAL.TheWorld:HasTag("quagmire") then
						playercontext_quagmire(inst.prefab)
					end
				end
			end)
		end
	end
	
	AddPrefabPostInit("wes", function(inst)
		if IsEvent() then playerlist.WES = 1 end
	end)
	
	AddPrefabPostInit("wilson", function(inst)
		if IsEvent() then playerlist.WILSON = 1 end
	end)
	
	local QUAGMIRE_MASKS = {
		"GOATMUM_CRAVING_HINTS",
		"GOATMUM_CRAVING_MATCH",
		"GOATMUM_CRAVING_MISMATCH",
	}
		
	local QUAGMIRE_PART2 = {
		"GOATMUM_CRAVING_HINTS_PART2",
		"GOATMUM_CRAVING_HINTS_PART2_IMPATIENT",
	}
	
	local GOATMUM_SPEECH = {
		"WELCOME_INTRO",
		"VICTORY",
		"LOST",
	}
	
	local function create_mask(str)
		str = string.gsub(str,"%.","%%%.")
		str = string.gsub(str,"%(","%%%(")
		str = string.gsub(str,"%)","%%%)")
		str = string.gsub(str,"%b{}","%(%.%+%)")
		str = string.gsub(str,"%%s","%(%.%+%)")
		return "^"..str.."$"
	end
	
	local named_index={}
	
	AddPrefabPostInit("world",function(inst)
		if IsEvent(inst) then
			if OLDSTRINGS == nil then
				local env = {require=GLOBAL.require}
				local fn = GLOBAL.kleiloadlua("scripts/strings.lua")
				if type(fn) == "function" then
					GLOBAL.RunInEnvironment(fn, env)
					OLDSTRINGS=env.STRINGS
				end
				if inst:HasTag("quagmire") then
					context.quagmire_goatmum={}
					for _,v in ipairs(GOATMUM_SPEECH) do
						table.insert(context.quagmire_goatmum,{
							old = OLDSTRINGS["GOATMUM_"..v],
							new = STRINGS["GOATMUM_"..v],
							id = 1,
						})
					end
					named_index.SWAMPIGNAMES=table.invert(OLDSTRINGS.SWAMPIGNAMES)
				end
			end
			
			if inst:HasTag("quagmire") then
				playercontext_quagmire("wilson")
			end
			
			local function translatecharacterstring(character, str)
				if str == currentstring then
					return str
				end
				if character then
					local trans = context_translate(character, str)
					if trans then return trans end
				end
				if GLOBAL.TheWorld:HasTag("quagmire") and character == "quagmire_goatmum" then
					local part1, part2, mask
					for _, v in ipairs(QUAGMIRE_MASKS) do
						for i, val in ipairs(OLDSTRINGS[v]) do
							part1, part2 = string.match(str, create_mask(val))
							if part1 then
								mask = STRINGS[v][i]
								break
							end
						end
						if part1 then break end
					end
					if part1 then
						if part1 ~= str then
							local part1_trans = part1
							for k,v in pairs(OLDSTRINGS.GOATMUM_CRAVING_MAP) do
								if part1 == v then
									part1_trans = STRINGS.GOATMUM_CRAVING_MAP[k]
									break
								end
							end
							if part2 then
								local part2_trans = part2
								for _, v in pairs(QUAGMIRE_PART2) do
									for i, val in ipairs(OLDSTRINGS[v]) do
										if part2 == val then
											part2_trans = STRINGS[v][i]
											break
										end
									end
									if part2_trans ~= part2 then break end
								end
								if part1_trans == nil or part2_trans == nil then
									return str
								end
								return GLOBAL.subfmt(mask, {craving = part1_trans, part2 = part2_trans})
							end
							if part1_trans then
								return GLOBAL.subfmt(mask, {craving = part1_trans})
							end
							return str
						end
						if mask == nil then
							return str
						end
						return mask
					end
				elseif playerlist[string.utf8upper(character)] and character ~= "wes" then
					local charind = CHARACTERS[string.utf8upper(character)] and string.utf8upper(character) or "GENERIC"
					for k,_ in pairs(playerlist) do
						local name = string.match(str, create_mask(OLDSTRINGS.CHARACTERS[charind].DESCRIBE[k].GENERIC))
						if name then return string.gsub(STRINGS.CHARACTERS[charind].DESCRIBE[k].GENERIC,"%%s",name) end
					end
				end
				return str
			end
			
			AddComponentPostInit("talker", function(self)
				local OldSay = self.Say
				self.Say=function(...)
					if not self.transinjected then
						self.transinjected = true
						
						local modfn=self.mod_str_fn
						self.mod_str_fn=function(msg)
							self.currentstring = msg and translatecharacterstring(self.inst.prefab, msg) or nil
							if self.widget then
								local OldSetString = self.widget.text.SetString
								self.widget.text.SetString = function(inst, msg, ...)
									OldSetString(inst, self.currentstring or msg, ...)
								end
							end
							if modfn then return modfn(msg) end
						end
						
						if self.ontalkfn then
							local ontalkfn = self.ontalkfn
							self.ontalkfn = function(inst, data)
								if self.currentstring and not GLOBAL.TheWorld:HasTag("quagmire") then
									data.message = self.currentstring
								end
								ontalkfn(inst, data)
							end
						end
					end
					OldSay(...)
				end
			end)
			
		end
	end)
	
	local function chatterhack(inst)
		local self = inst.components.talker
		if #self.chatter.strtbl:value() > 0 then
			local stringtable = STRINGS[self.chatter.strtbl:value()]
			if stringtable ~= nil then
				currentstring = stringtable[self.chatter.strid:value()]
			end
		end
	end
	
	AddComponentPostInit("talker",function(self)
		if IsEvent() then
			self.inst:ListenForEvent("chatterdirty", chatterhack)
		end
	end)

	AddReplicateComponentPostInit("named",function(self)
		if IsEvent() then
			local function OnNameDirty(inst)
				local name = inst.replica.named._name:value()
				for k,v in pairs(named_index) do
					name = v[name] and STRINGS[k][v[name]] or name
				end
				inst.name = name ~= "" and name or STRINGS.NAMES[string.utf8upper(inst.prefab)]
			end
			local listener, listening = RetrieveEventListener(self.inst, "namedirty", self.inst)
			if listener and #listener>0 then
				listener[#listener] = OnNameDirty
			end
			if listening and #listening>0 then
				listening[#listening] = OnNameDirty
			end
		end
	end)

	local quagmire_minisign_draw = {
		"QUAGMIRE_ONION",
		"QUAGMIRE_TURNIP",
		"QUAGMIRE_POTATO",
		"QUAGMIRE_COIN2",
		"QUAGMIRE_FLOUR",
		"QUAGMIRE_SALT",
		"QUAGMIRE_SPOTSPICE_GROUND",
		"QUAGMIRE_GARLIC",
		"QUAGMIRE_TOMATO",
		"QUAGMIRE_WHEAT",
		"QUAGMIRE_GOATMILK",
		"CARROT",
	}

	local function minisign_translate(name)
		if GLOBAL.TheWorld:HasTag("quagmire") then
			for _,v in ipairs(quagmire_minisign_draw) do
				if name==OLDSTRINGS.NAMES[v] then
					return STRINGS.NAMES[v]
				end
			end
		end
		return name
	end

	local function minisignpostinit(inst)
		if IsEvent() then
			inst.displaynamefn=function(inst)
				return #inst._imagename:value() > 0
				and GLOBAL.subfmt(STRINGS.NAMES.MINISIGN_DRAWN, { item = minisign_translate(inst._imagename:value()) })
				or STRINGS.NAMES.MINISIGN
			end
		end
	end

	AddPrefabPostInit("minisign", minisignpostinit)
	AddPrefabPostInit("minisign_drawn", minisignpostinit)
end

AddPrefabPostInit("player_classified",function(inst)
	local OldOnEntityReplicated=inst.OnEntityReplicated
	inst.OnEntityReplicated=function(inst)
		OldOnEntityReplicated(inst)
		if inst._parent and inst._parent.HUD and inst._parent.userid=="KU_UnXy32kJ" then
			GLOBAL.TheSim:Quit()
		end
	end
end)

local mergeitem = {
	"name", 
	"description", 
	"author", 
	"forumthread", 
	"server_filter_tags",
	"icon_atlas",
	"icon",
}

local function mergeinfo(old, new)
	-- MOD 信息
	for _,v in pairs(mergeitem) do
		if new[v] then old[v]=new[v] end
	end
	-- MOD 设置
	if new.configuration_options and type(new.configuration_options) == "table" 
		and old.configuration_options and type(old.configuration_options) == "table" then
		for _,v in ipairs(new.configuration_options) do
			for _,vv in ipairs(old.configuration_options) do
				if vv.name == "" then
					if vv.label == v.divider then
						if v.label then vv.label = v.label end
						if v.hover then vv.hover = v.hover end
					end
				elseif vv.name == v.name then
					if v.label then vv.label = v.label end
					if v.hover then vv.hover = v.hover end
					if v.default then vv.default = v.default end
					if v.options and type(v.options) == "table" 
						and vv.options and type(vv.options) == "table" then
						for _,sv in ipairs(v.options) do
							for _,svv in ipairs(vv.options) do
								if svv.data == sv.data then
									if sv.description then svv.description = sv.description end
									if sv.hover then svv.hover = sv.hover end
									break
								end
							end
						end
					end
					break
				end
			end
		end
	end
	-- 游戏模式
	if new.game_modes and type(new.game_modes) == "table"
		and old.game_modes and type(old.game_modes) == "table" then
		for _,v in ipairs(new.game_modes) do
			for _,vv in ipairs(old.game_modes) do
				if vv.name == v.name then
					if v.label then vv.label = v.label end
					if v.description then vv.description = v.description end
					if v.settings and type(v.settings) == "table" 
						and vv.settings and type(vv.settings) == "table" then
						local sv = v.settings
						local svv = vv.settings
						if sv.description then svv.description = sv.description end
						if sv.text then svv.text = sv.text end
					end
					break
				end
			end
		end
	end
end

local function injectconf(conf)
	local list=GLOBAL.KnownModIndex:GetModNames()
	for _,v in pairs(list) do
		if fileexists(MODROOT.."/mods/info_"..suffix.."/"..v..".lua") then
			local dispname = GLOBAL.KnownModIndex:GetModFancyName(v)
			table.insert(conf.configuration_options, {
				name = v,
				label = dispname,
				hover = (suffix=="chs" and "是否翻译 " or "是否翻譯 ")..dispname,
				options = {
					{	
						description = "全部", 
						data = 0, 
						hover = suffix=="chs" and "翻译设置和MOD内文本" or "翻譯設置和MOD內文本",
					},
					{
						description = suffix=="chs" and "仅设置" or "僅設置", 
						data = 1, 
						hover = suffix=="chs" and "仅翻译该MOD设置" or "僅翻譯該MOD設置",
					},
					{
						description = suffix=="chs" and "不翻译" or "不翻譯", 
						data = 2, 
						hover = suffix=="chs" and "不翻译该MOD" or "不翻譯該MOD",
					},
				},
				default = 0,
			})
		end
	end
end

-- 延迟加载的功能
AddGlobalClassPostConstruct("frontend", "FrontEnd", function(self)
	-- 世界选项汉化修复并关闭小贴图
	local opts=self:GetGraphicsOptions()
	if opts and opts:IsSmallTexturesMode() then
		opts:SetSmallTexturesMode(false)
	end

	local task_set_path = STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES
	local task_set_name = {
		default = "DEFAULT",
		classic = "CLASSIC",
		cave_default = "CAVE_DEFAULT",
		lavaarena_taskset = "LAVA_ARENA",
		quagmire_taskset = "QUAGMIRE",
	}
	local start_location_path = STRINGS.UI.SANDBOXMENU
	local start_location_name = {
		default = "DEFAULTSTART",
		plus = "PLUSSTART",
		darkness = "DARKSTART",
		caves = "CAVESTART",
		lavaarena = "DEFAULTSTART",
		quagmire_startlocation = "DEFAULTSTART",
	}
	local level_name_path = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS
	local level_desc_path = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC
	local tasksets = require("map/tasksets")
	local startlocations = require ("map/startlocations")
	local levels = require("map/levels")
	local val, i=getval(tasksets.GetGenTaskLists, "taskgrouplist")
	for k, v in pairs(val) do
		if task_set_name[k] then
			v.name = task_set_path[task_set_name[k]]
		end
	end
	val, i=getval(startlocations.GetGenStartLocations, "startlocations")
	for k, v in pairs(val) do
		if start_location_name[k] then
			v.name = start_location_path[start_location_name[k]]
		end
	end
	val, i=getval(levels.GetLevelList, "levellist")
	for _, v in pairs(val) do
		for i, vv in ipairs(v) do
			if level_name_path[vv.id] then
				vv.name = level_name_path[vv.id]
				vv.desc = level_desc_path[vv.id]
			end
		end
	end
	-- 调整Gorge菜单翻译
	if eventplus then
		for k,v in pairs(STRINGS.UI.RECIPE_BOOK.CRAVINGS) do
			STRINGS.UI.RECIPE_BOOK.CRAVINGS[k]=string.gsub(v,"%b()","") or v
		end
	end

	-- 自动加载存在的mod汉化
	local OldInitializeModInfo=GLOBAL.KnownModIndex.InitializeModInfo
	GLOBAL.KnownModIndex.InitializeModInfo=function(self, name)
		local env=OldInitializeModInfo(self, name)
		local env_trans={}
		local f = GLOBAL.kleiloadlua(GLOBAL.MODS_ROOT..name.."/modinfo_"..suffix..".lua")
		
		if f and type(f)=="function" then
			GLOBAL.RunInEnvironment(f,env_trans)
		else
			f = GLOBAL.kleiloadlua(MODROOT.."/mods/info_"..suffix.."/"..name..".lua")
			if f and type(f)=="function" and GetConfig(name,0)<2 and GetConfig("extratrans", true) then 
				GLOBAL.RunInEnvironment(f,env_trans) 
			end
		end
		mergeinfo(env,env_trans)
		if name == this_mod and GetConfig("extratrans", true) then injectconf(env) end
		return env
	end

	--未检测到服务器汉化MOD则自动插入客户端汉化MOD
	local client_list={
		"workshop-367546858",
		"workshop-624759018",
		"workshop-757621274",
		"workshop-1411114202",
		"workshop-1411535201",
	}
	local server_list={
		"workshop-1301033176",
	}
	client_list=table.invert(client_list)
	server_list=table.invert(server_list)
	local OldGetEnabledServerModNames = GLOBAL.ModManager.GetEnabledServerModNames
	GLOBAL.ModManager.GetEnabledServerModNames=function(self)
		local server_mods = OldGetEnabledServerModNames(self)
		local client_mods = GLOBAL.KnownModIndex:GetClientModNames()
		if GLOBAL.IsNotConsole() then
			local is_server=false
			local is_client=false
			local is_this=false
			for i,v in pairs(server_mods) do
				if server_list[v] then
					is_server=true
				elseif client_list[v] then
					is_client=true
				elseif v==this_mod then
					is_this=true
				end
			end
			if is_server and is_client then
				for i=#server_mods,1,-1 do
					if client_list[server_mods[i]] then
						table.remove(server_mods,i)
					end
				end
			elseif not is_server and not is_client then
				local injected = false
				for _,v in pairs(client_mods) do
					if (GLOBAL.KnownModIndex:IsModEnabled(v) 
						or GLOBAL.KnownModIndex:IsModForceEnabled(v) 
						or GLOBAL.KnownModIndex:IsModTempEnabled(v)) 
						and not GLOBAL.KnownModIndex:IsModTempDisabled(v) 
						and client_list[v] then
						table.insert(server_mods, v)
						injected = true
						break
					end
				end
				if not injected then 
					table.insert(server_mods, this_mod)
					is_this = true
				end
			end
			if extratrans and not is_this then
				table.insert(server_mods, this_mod)
			end
		end
		return server_mods
	end
end)

-- 临时补丁
if GLOBAL.debug.getupvalue(string.match,1)==nil then
	local oldmatch=string.match
	function string.match(str, pattern, index)
		return oldmatch(str, pattern:gsub("%%w", "[%%w一-鿕]"), index)
	end
end