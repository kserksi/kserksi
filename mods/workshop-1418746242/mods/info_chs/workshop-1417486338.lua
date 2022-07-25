name = "Refillable Bucket（可装填的桶）"
description =   "你现在可以重新装填你的便便篮了！\n\n" ..
                "你可以用任何原本可用于浇灌的物品来装填它。\n" ..
				"各种物品可恢复便便篮的使用次数如下（可在设置中调节）：\n"..
				"- 鸟屎 (7.5)\n"..
				"- 便便 (5)\n"..
				"- 腐烂食物 (1.25)\n"..
				"- 烂鸡蛋 (1.25)\n"..
				"- 格罗姆的粘液 (5)"
				
configuration_options =
{

	{
		name = "refiller:multiplier_guano",
		label = "鸟屎",
	},	
	{
		name = "refiller:multiplier_poop",
		label = "便便",
	},
	{
		name = "refiller:multiplier_spoiled_food",
		label = "腐烂食物",
	},
	{
		name = "refiller:multiplier_rotten_egg",
		label = "烂鸡蛋",
	},
	{
		name = "refiller:multiplier_glommer_fuel",
		label = "格罗姆的粘液",
	},
	{
		name = "uses:fertilizer",
		label = "便便篮使用次数",
	},
}