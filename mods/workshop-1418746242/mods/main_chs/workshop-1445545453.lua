local STRINGS = GLOBAL.STRINGS
local this_mod = "workshop-1445545453"

local str = {
	["STRINGS.NAMES.LASTHOPE_PORTAL"] = "神秘的平台",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_PORTAL"] = "我觉得我们需要其它的东西使它工作。",
	["STRINGS.RECIPE_DESC.LASTHOPE_PORTAL"] = "奇怪的紫色平台。",

	["STRINGS.NAMES.LASTHOPE_LEVER"] = "金色操纵杆",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_LEVER"] = "看起来像是某个东西的一部分。",
	["STRINGS.RECIPE_DESC.LASTHOPE_LEVER"] = "某个更大的东西的一部分。",

	["STRINGS.NAMES.LASTHOPE_FLOWERS"] = "邪恶之花",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_FLOWERS"] = "它们外观看起来像是普通的花，但内部就……",
	["STRINGS.RECIPE_DESC.LASTHOPE_FLOWERS"] = "拥有黑暗内在的美丽花朵。",

	["STRINGS.NAMES.LASTHOPE_RING"] = "金色圆环",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_RING"] = "巨大的金色圆环。",
	["STRINGS.RECIPE_DESC.LASTHOPE_RING"] = "某个更大的东西的金色部分。",

	["STRINGS.NAMES.LASTHOPE_RADIO"] = "神秘的收音机",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_RADIO"] = "它是活的？它会发出毛骨悚然的声音。",
	["STRINGS.RECIPE_DESC.LASTHOPE_RADIO"] = "播放着你希望的旋律。",

	["STRINGS.NAMES.MAD_GHOST"] = "疯狂的诗人",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAD_GHOST"] = "巨大的幽灵……没错。",

	["STRINGS.NAMES.ENDLESSTORCH"] = "不灭的火炬",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENDLESSTORCH"] = "有了这火，我可以一直守望下去……",

	["STRINGS.NAMES.LASTHOPE_SAFE"] = "保险箱",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_SAFE"] = "我们没有钥匙真是太糟了。",

	["STRINGS.NAMES.LASTHOPE_SAFEKEY"] = "金钥匙",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_SAFEKEY"] = "既然有钥匙，那一定也有它能打开的锁。",

	["STRINGS.NAMES.LASTHOPE_CAGEKEY"] = "铁钥匙",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_CAGEKEY"] = "黄金牢笼的铁钥匙……真是讽刺……",

	["STRINGS.NAMES.LASTHOPE_GOLDEN_CAGE"] = "笼中的麦克斯韦",
	["STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_GOLDEN_CAGE"] = "我觉得他需要《越狱》。",

	["STRINGS.NAMES.SHADOW_PORTAL"] = "暗影之门",
	["STRINGS.NAMES.GHOST"] = "诗人的邪恶复制体",
}
AppendStrings(str)

STRINGS.NAMES.LASTHOPE_POND = STRINGS.NAMES.POND
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_POND = STRINGS.CHARACTERS.GENERIC.DESCRIBE.POND
STRINGS.NAMES.LASTHOPE_WORMHOLE = STRINGS.NAMES.WORMHOLE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_WORMHOLE= STRINGS.CHARACTERS.GENERIC.DESCRIBE.WORMHOLE
STRINGS.NAMES.LASTHOPE_LOOTBAG = STRINGS.NAMES.BUNDLE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LASTHOPE_LOOTBAG = STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUNDLE

local announce = {
	["WARNING!!! EVENT DONT CAN BE LOAD!"]="警告！！！活动加载失败！",
	["SERVER REGENERATE MAP IN 10 SECONDS"]="服务器将在10秒内重新生成地图",
	["Waiting second player to start..."]="等待第二个玩家加入……",
	["WARNING!!! THIS GAME MODE ONLY FOR TWO PLAYERS"]="警告！！！该游戏模式仅限两个玩家参与！",
	["You not selected «The last hope» in server game mode. "]="你未在游戏模式中选择《最后的希望》",
	["Please enable mod and in server setings select last hope game mode. "]="请在服务器设置中启用mod，并选择最后的希望游戏模式。",
}
AppendAnnounce(announce)

local TalkArray_trans = 
{
	["Wendy, Abigail, I'm gald you're both okay."] = "温蒂，阿比盖尔，幸好你们都没事。",
	["We don't have much time!"] = "我们没有多少时间了！",
	["We need leave this place..."] = "我们得离开这个地方……",
	["She's... here, and she wants to kill us."] = "她……在这里，她想杀了我们。",
	["But don't worry, we need just..."] = "但别担心，我们只需要……",
	["Oh no!"] = "哦，不！",
	["Charlie, nooo!"] = "查理，不要啊！",
}
local TalkArray = getmoddata(this_mod, "PrefabPostInit", "world", "SpawnNearFlower.SpawnObjectNear.StartDialog.TalkArray")
if TalkArray then table.translate(TalkArray, TalkArray_trans) end

local buyrpc = GetModRPCHandler("LASTHOPE", "BUY")
if buyrpc then
	local OldTalkWithKeeper = getval(buyrpc,"TalkWithKeeper")
	if OldTalkWithKeeper then
		setval(buyrpc,"TalkWithKeeper", function(inst, text, keeper, text2)
			local trans = 
			{
				["Thank you!"] = "谢谢你！",
				["Orgh..too expensive."] = "额……太贵了。",
				["You need more coints."] = "你需要更多金币。",
			}
			text = (text and trans[text]) or text
			text2 = (text2 and trans[text2]) or text2
			OldTalkWithKeeper(inst, text, keeper, text2)
		end)
	end
end

AddClassPostConstruct("widgets/tminibadge", function(inst)
	if not getval(inst.AddName, "OldAddName") then
		local OldAddName = inst.AddName

		function inst:AddName(name, ...)
			if self.prefab then
				if self.prefab:match("_blueprint") and GLOBAL.STRINGS.NAMES[self.prefab:gsub("_blueprint",""):upper()] then
					name = GLOBAL.STRINGS.NAMES[self.prefab:gsub("_blueprint",""):upper()]..GLOBAL.STRINGS.NAMES.BLUEPRINT
				else
					name = GLOBAL.STRINGS.NAMES[self.prefab:upper()] or name
				end
			end
			OldAddName(self, name, ...)
		end
	end
end)

AddClassPostConstruct("widgets/inventorybar", function(inst)
	if inst.cointtip then
		inst.cointtip:SetString("点击丢弃")
	end
end)

local function Syn(inst)
	local seconds = GLOBAL.TheWorld.lasthope_seconds
	local minutes = GLOBAL.TheWorld.lasthope_minutes
	local eventstate = GLOBAL.TheWorld.lasthope_world_state
	local wavenum = GLOBAL.TheWorld.lasthope_wavenum
	local enemysnum = GLOBAL.TheWorld.lasthope_enemynum
	local boss = GLOBAL.TheWorld.lasthope_nextbosswave
	local ready = GLOBAL.TheWorld.lasthope_portalready
	local coints = tostring(inst.lasthope_coints)
	local full_string = ""
	local s_string = ""
	local m_string = ""
	local state_string = ""
	local hp = inst.components.health.currenthealth
	if seconds and minutes and eventstate and wavenum and enemysnum and coints and boss ~= nil then
	    if seconds < 10 then
		    s_string = "0"..seconds
	    elseif seconds >= 10 then
		    s_string = seconds
		end
	    if minutes < 10 then
		    m_string = "0"..minutes
	    elseif minutes >= 10 then
		    m_string = minutes
		end
		if eventstate == "intermission" then
		    if boss then
			    state_string = "Boss"
			else
			    state_string = "敌人"
			end
			full_string = "将在 "..m_string..":"..s_string.." 后遇到"..state_string
		elseif eventstate == "wave" then
		    state_string = "第 "..wavenum.." 波"
			full_string = state_string.." "..m_string..":"..s_string
		elseif eventstate == "enemysleft" then
		    full_string = "剩余 "..enemysnum.." 个敌人"   
		elseif eventstate == "death" then
		    full_string = "在 "..seconds.." 秒后重置服务器" 	
		elseif eventstate == "timetoportal" then
		    full_string = "是时候建造大门了！" 	
		elseif eventstate == "escape" then
		    full_string = "在 "..seconds.." 秒后显示奖励" 		
		elseif eventstate == "findkey" then
		    full_string = ""
		elseif eventstate == "moon" then
		    full_string = "大门充能 "..ready.."%"			
		end
		
		inst.lasthope_timeless_client:set(wavenum)
		inst.lasthope_coints_client:set(coints)
	end
	inst.lasthope_time_client:set(full_string)
	inst.lasthope_hp_client:set(math.floor(hp))
end
local fns = getmoddata(this_mod, "PrefabPostInitAny")
for _,v in ipairs(fns) do
	if getval(v, "fn.Syn") then
		setval(getval(v, "fn"), "Syn", Syn)
	end
end

AddClassPostConstruct("screens/lasthopeendscreen", function(self)
	local menu_trans = 
	{
		["Disconnect"] = "断开连接",
		["Sisters Runited?"] = "关于《姐妹重聚》",
	}
	for _,v in ipairs(self.menu.items) do
		if v.prompt then
			local text = v.prompt:GetString()
			text = text and menu_trans[text] or text
			v.prompt:SetString(text)
			v.prompt_shadow:SetString(text)
		else
			local text = v:GetString()
			text = text and menu_trans[text] or text
			v:SetString(text)
		end
	end
	self.title:SetString("你做到了！")
	self.line:SetString("我想对屏幕前的你和《姐妹重聚》社区说声感谢，")
	self.line2:SetString("没有你们的支持，《姐妹重聚》就不会像现在做得这么好，谢谢你们。")
	self.line3:SetString("经过这次活动，你得到了《姐妹重聚》中阿比盖尔的感谢。") 
end)

AddClassPostConstruct("screens/deathscreen", function(self)
	local title_trans =
	{
		["You are dead."] = "你死了。",
		["You are escaped."] = "你逃脱了。",
		["Your sister has abandoned you."] = "你的姐妹抛弃了你。",
	}
	local text = self.title:GetString()
	text = text and title_trans[text] or text
	self.title:SetString(text)
	self.t1:SetString("你存活了 "..tostring(GLOBAL.ThePlayer.lasthope_timeless_client:value()).." 波攻击！")
	self.rewardtext:SetString("你们的称号：最糟的队伍")
	
	local OldSetStatus = self.SetStatus
	function self:SetStatus(xp, ignore_image)
		OldSetStatus(self, xp, ignore_image)
		if self.leveltext then
			local text = self.leveltext:GetString()
			print(text:gsub("Level","等级"))
			self.leveltext:SetString(text:gsub("Level","等级"))
		end
		
		local rank_trans =
		{
			["Your rank: Worst team."] = "你们的称号：最糟的队伍",
			["Your rank: Weak team."] = "你们的称号：弱小的队伍",
			["Your rank: Good team."] = "你们的称号：不错的队伍",
			["Your rank: Cooperative mind."] = "你们的称号：心灵相通",
			["Your rank: Twins."] = "你们的称号：双胞胎",
			["Your rank: Best sisters."] = "你们的称号：最好的姐妹",
			["Your rank: True sisters."] = "你们的称号：真正的姐妹",
		}
		if self.rewardtext then
			local text = self.rewardtext:GetString()
			text = text and rank_trans[text] or text
			self.rewardtext:SetString(text)
		end
	end
end)

AddPrefabPostInit("pig_corpse", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName("遗体")
		inst.components.inspectable:SetDescription("等等，我会帮助你的")
	end
end)

AddPrefabPostInit("groundbag", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName("睡袋")
		inst.components.inspectable:SetDescription("我睡在这？")
	end
end)

AddPrefabPostInit("lasthope_coint", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst:DoTaskInTime(0, function()	
			if inst.coutvalue ~= nil then
				if inst.coutvalue > 1 then
					inst.components.named:SetName(inst.coutvalue.." 铜币")
				else
					inst.components.named:SetName("铜币")
				end
			else
				inst.components.named:SetName("铜币")
			end
		end)
		inst.components.inspectable:SetDescription("小小的铜币。它会很有用的。")
	end
end)

AddPrefabPostInit("basalt", function(inst)
	if inst.components.inspectable then
		inst.components.inspectable.nameoverride = "玄武岩"
	end
end)

local name_trans = 
{
	["Bill"] = "比尔",
	["Stanford"] = "斯坦福",
	["Craig"] = "克雷格",
	["Sammy"] = "萨米",
	["Pipton"] = "皮普顿",
}

AddPrefabPostInit("lasthope_weaposnkeeper", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName(name_trans[inst.pigname] or inst.pigname)
		inst.components.inspectable:SetDescription("我需要一些锋利的东西。")
	end
end)

AddPrefabPostInit("lasthope_refineskeeper", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName(name_trans[inst.pigname] or inst.pigname)
		inst.components.inspectable:SetDescription("你卖些陷阱？它们应该很有用。")
	end
end)

AddPrefabPostInit("lasthope_fisherman", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName(name_trans[inst.pigname] or inst.pigname)
		inst.components.inspectable:SetDescription("你卖些陷阱？它们应该很有用。")
	end
end)

AddPrefabPostInit("lasthope_plantskeeper", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName(name_trans[inst.pigname] or inst.pigname)
		inst.components.inspectable:SetDescription("我需要一些种子？你有些什么？")
	end
end)

AddPrefabPostInit("lasthope_printskeeper", function(inst)
	if inst.components.named and inst.components.inspectable then
		inst.components.named:SetName(name_trans[inst.pigname] or inst.pigname)
		inst.components.inspectable:SetDescription("你可以卖给我些蓝图吗？")
	end
end)