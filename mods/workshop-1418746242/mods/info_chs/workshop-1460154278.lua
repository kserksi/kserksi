name = "The Gorge Extension（暴食扩展）"
description = "将暴食物品带到你的世界里！"

configuration_options =
{
	{
		name = "veg_garden_difficulty",
		label = "菜园配方难度",
        hover = "调整配方的难度",
		options =
		{
			{description = "简单", data = "recipe_easy"},
			{description = "正常", data = "recipe_normal"},
			{description = "困难", data = "recipe_hard"},
		},
		default = "recipe_normal",
	},
	{
		name = "gorge_crops",
		label = "暴食作物",
        hover = "是否加入暴食作物",
		options =
		{
			{description = "是", data = "gorge_crops_yes"},
			{description = "否", data = "gorge_crops_no"},
		},
		default = "gorge_crops_yes",
	}
}