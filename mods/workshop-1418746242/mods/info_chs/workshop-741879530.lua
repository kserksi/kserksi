name = "Rezecib's Rebalance（再平衡）"
description = "对游戏进行了许多修改，以平衡较弱或者烦人的机制，并调弱部分过强的内容。"

configuration_options = {}
local on_off_options = {
	{description = "启用", data = true},
	{description = "禁用", data = false},
}
local function AddPatch(name, label)
	configuration_options[#configuration_options + 1] = {
		name = name,
		label = label,
		options = on_off_options,
		default = true,
		hover = "注意：设置选项在公共服务器上将被忽略。",
	}
end

AddPatch("beefalodomestication", "修改皮弗洛牛")
AddPatch("maxwellminions",       "修改麦斯威尔")
AddPatch("willowrework",         "修改薇洛")
AddPatch("wolfgangrework",       "修改沃尔夫冈")
AddPatch("woodierework",         "修改伍迪")
AddPatch("wx78rework",           "修改WX-78")
AddPatch("ancientguardian",      "修改远古守卫")
AddPatch("ancientmagic",         "修改魔法物品")
AddPatch("giantitems",           "修改巨人物品")
AddPatch("lavaebuff",            "修改熔岩虫")
AddPatch("diseaseregrowth",      "修改疾病/再生")
AddPatch("thermalmeasurer",      "修改温度计")
AddPatch("shadowcreatures",      "修复梦魇生物")
AddPatch("lanternhaunt",         "修复作祟提灯")
AddPatch("attackfixes",          "修复攻击")
