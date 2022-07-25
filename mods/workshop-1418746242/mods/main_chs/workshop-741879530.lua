local this_mod = "workshop-741879530"
local overrides = {
	maxwellminions = ismodloaded("workshop-741272188"),
	woodierework = ismodloaded("workshop-888197520"),
}

local IS_PUBLIC = not (
		TheNet:GetServerLANOnly()
	or	TheNet:GetServerFriendsOnly()
	or	TheNet:GetServerClanOnly()
	or	TheNet:GetServerHasPassword()
)

local function trans(name, fn)
	if (IS_PUBLIC or (GLOBAL.GetModConfigData(name, this_mod) ~= false)) and not overrides[name] then
		fn()
	end
end

local function thermalmeasurer()
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINTEROMETER = {
		"我最好穿得暖和些！",
		"我大概需要一件毛衣。",
		"有点冷。",
		"不错的天气。",
		"有点热。",
		"我应该找个阴凉的地方。",
		"我最好带点冷的东西。",
	}
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.WINTEROMETER = {
		"让我们来点把大火保暖吧！",
		"好冷啊，该点堆篝火了。",
		"风有些冷。",
		"这天气真好。",
		"风有点热。",
		"我可能会晒伤……我比较喜欢其它形式的火。",
		"太热了，即使想到火都会觉得热。",
	}
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WINTEROMETER = {
		"需要非常保暖的帽子！",
		"需要保暖的帽子！",
		"有些冷。",
		"很好的天气。",
		"有点热。",
		"今天太阳比沃尔夫冈还要强。",
		"天空就像一团火！",
	}
	STRINGS.CHARACTERS.WENDY.DESCRIBE.WINTEROMETER = {
		"这空气比我的心还凉……",
		"我需要一些衣物来躲避这寒冷。",
		"我觉得有点冷。",
		"相当无聊的天气。",
		"有点过暖了。",
		"极度的炎热。",
		"没东西降温我可能会热死……",
	}
	STRINGS.CHARACTERS.WX78.DESCRIBE.WINTEROMETER = {
		"温度：极低",
		"温度：低",
		"温度：较低",
		"温度：适宜",
		"温度：较高",
		"温度：高",
		"温度：极高",
	}
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WINTEROMETER = {
		"我需要一堆火和足够的保暖衣物！",
		"应该准备一件温暖的毛衣。",
		"相当的冷。",
		"美好的天气。",
		"相当的热.",
		"这天气很明显相当闷热。",
		"我们需要一些吸热反应来在这高温下生存。",
	}
	--TODO
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.WINTEROMETER = {
		"噗！好冷。",
		"今天我需要比这衬衫更暖的衣服。",
		"对于这温度，这件衬衫已经足够暖和。",
		"不错的天气，嗯哼？",
		"外面有点热。",
		"我需要一些东西来挡住头顶上的太阳。",
		"比失火的森林还要热！",
	}
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WINTEROMETER = {
		"冰冷的温度。",
		"当亲自面对时，这寒冷就不是什么有趣的事了。",
		"比我想要的温度冷。",
		"完全正常的天气。",
		"比我想要的温度热。",
		"极其的热。",
		"地狱的热度。",
	}
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WINTEROMETER = {
		"我应该用激烈的战斗让自己暖和起来！",
		"我们正在承受寒冬的力量",
		"寒冬女神为我们送来了寒冷的警告。",
		"真是打斗的好天气！",
		"有一点炙热",
		"即使对于战士来说，这温度也难以承受。",
		"这个世界还没准备好承受炎巨人之王的烈焰！",
	}
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.WINTEROMETER = {
		"如果我有我父亲的毛皮大衣就好了！",
		"蛛网胡须应该足够承受了。",
		"寒冷。",
		"最好的天气",
		"有点热。",
		"我们的毛发对于这天气来说太热了。",
		"天哪，好热！",
	}
end

local function willowrework()
	STRINGS.CHARACTER_DESCRIPTIONS.willow = ""
	.."*对于火焰知道的太多了 \n"
	.."*可以制作可爱的熊和称心的打火机 \n"
	.."*当失去理智时无法保暖"

	STRINGS.NAMES.SHADOWLIGHTER = "暗影打火机"
	STRINGS.RECIPE_DESC.SHADOWLIGHTER = "烧它们！把它们全部烧掉！"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWLIGHTER = "看起来我用不了它……"
	STRINGS.CHARACTERS.WX78.DESCRIBE.SHADOWLIGHTER = "暗影魔法无效"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHADOWLIGHTER = "一个战士应该崇尚光明，而不是阴暗！"
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHADOWLIGHTER = "微小可怕的火焰盒子无法为沃尔夫冈提供光亮。"
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHADOWLIGHTER = "哦，她惹上了什么……"
	STRINGS.CHARACTERS.WENDY.DESCRIBE.SHADOWLIGHTER = "盒子中孕育着更为黑暗的死亡……"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHADOWLIGHTER = "它是个吓人的打火机。我们离它远一点。"
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHADOWLIGHTER = "我不理解或信任它的机理。"
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHADOWLIGHTER = "暗影的打火机？我猜这就是它不发光的原因了？"
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHADOWLIGHTER = "我在王座上的时候学到了那么一两招。"
	
	AppendStrings({["STRINGS.ACTIONS.STARTSHADOWFIRE"]="点燃暗影之火"})
	STRINGS.CHARACTERS.WILLOW.ANNOUNCE_WANTFIRE = "我不记得我上次烧东西是什么时候了……"
	STRINGS.CHARACTERS.WILLOW.ANNOUNCE_REALLYWANTFIRE = "我感觉手痒，很想烧点什么……"
end

local function maxwellminions()
	STRINGS.NAMES.SHADOWTORCHBEARER = "暗影火炬手"
	STRINGS.RECIPE_DESC.SHADOWTORCHBEARER = "把查理逼入绝境。"
	STRINGS.NAMES.SHADOWPORTER = "暗影搬运工"
	STRINGS.RECIPE_DESC.SHADOWPORTER = "先生，您想让我帮忙搬它吗？"
	STRINGS.NAMES.SHADOWLUMBER = "暗影伐木工"
	STRINGS.NAMES.SHADOWMINER = "暗影矿工"
	STRINGS.NAMES.SHADOWDIGGER = "暗影掘地工"
	STRINGS.NAMES.SHADOWDUELIST = "暗影斗士"
	
	AppendStrings({["STRINGS.ACTIONS.IMBUE"]="召唤"})
	
	STRINGS.ACTIONS.IMBUETOGGLEACTIVE = { STOPWORKING = "停止", STARTWORKING = "工作" }
end

local function attackfixes()
	STRINGS.ACTIONS.TOGGLEAGGRO = { STOPAGGRO = "停止", STARTAGGRO = "唤醒" }
end

local function beefalodomestication()
	local kinds = getval(require("writeables").makescreen, "kinds")
	if kinds.beefalo then
		kinds.beefalo.prompt = "你想给你的牛起什么名字？"
		kinds.beefalo.cancelbtn.text = "取消"
		kinds.beefalo.middlebtn.text = "随机"
		kinds.beefalo.acceptbtn.text = "命名！"
	end
	
	STRINGS.NAMES.BEEFALOCOLLAR = "牛项圈"
	STRINGS.RECIPE_DESC.BEEFALOCOLLAR = "如果你喜欢它，就给它套个项圈吧。"
	
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALOCOLLAR = "它可能味道比较大，但它将成为我的了。"
	STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALOCOLLAR = "该肉囊将永远从属与我。"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALOCOLLAR = "一个与野兽灵魂缔结契约的护身符。"
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALOCOLLAR = "它给毛牛加上了名字。"
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALOCOLLAR = "这不会使它看上去不那么蠢，但会使它变成我的。"
	STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALOCOLLAR = "这会把野兽绑定到我身上，就像艾比盖尔之花对于她一样。"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALOCOLLAR = "这意味着我们能让它成为我们私有的吗？"
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALOCOLLAR = "它看起来不仅仅是一个项圈。"
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALOCOLLAR = "把一只皮弗娄牛称作我自己的，嗯哼？"
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALOCOLLAR = "这可能让它的热情持续地更久。"

	STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFALO.NEARDEATH = "不帮它，它就活不下去了。"
	STRINGS.CHARACTERS.WX78.DESCRIBE.BEEFALO.NEARDEATH = "该肉囊即将死亡。哈。"
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BEEFALO.NEARDEATH = "这个野兽很快就要去英烈祠了……T"
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BEEFALO.NEARDEATH = "毛牛很快就要死了。"
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BEEFALO.NEARDEATH = "我几乎要为这个垂死的野兽感到遗憾了。"
	STRINGS.CHARACTERS.WENDY.DESCRIBE.BEEFALO.NEARDEATH = "这个野兽并不渴望这个世界。"
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.BEEFALO.NEARDEATH = "我们觉得它需要药物，很急。"
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BEEFALO.NEARDEATH = "它需要立刻得到医疗救助。"
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.BEEFALO.NEARDEATH = "这个动物的一生就要走到尽头了。"
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.BEEFALO.NEARDEATH = "它的生命之火就要熄灭了！"
	
	AddPrefabPostInit("beefalo", function(inst)
		if TheNet:GetIsServer() then
			local TENDENCY_NAMES = getval(inst.SetTendency, "TENDENCY_NAMES")
			if TENDENCY_NAMES then
				TENDENCY_NAMES[GLOBAL.TENDENCY.DEFAULT] = "普通的"
				TENDENCY_NAMES[GLOBAL.TENDENCY.ORNERY] = "暴躁的"
				TENDENCY_NAMES[GLOBAL.TENDENCY.RIDER] = "迅捷的"
				TENDENCY_NAMES[GLOBAL.TENDENCY.PUDGY] = "胖乎乎的"
			end
			inst.UpdateName = function (inst)
				local name = inst.components.writeable:GetText()
				name = name and inst.owner_name .. name or inst.owner_name .. inst.tendency_name .. GLOBAL.STRINGS.NAMES.BEEFALO
				inst.components.named:SetName(name)
			end
			inst:DoTaskInTime(0, inst.UpdateName)
		end
	end)
end

trans("thermalmeasurer", thermalmeasurer)
trans("willowrework", willowrework)
trans("maxwellminions", maxwellminions)
trans("attackfixes", attackfixes)
trans("beefalodomestication", beefalodomestication)