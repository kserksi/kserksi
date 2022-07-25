name = "Automatic Gardener（自动务农机）"
description = "能自动处理玩家的作物。"

configuration_options =
{
	{
		name = "auto_gardener_difficulty",
		label = "自动务农机配方难度",
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
		name = "auto_effect_range",
		label = "自动务农机作用范围",
        hover = "自动务农机能处理多远范围内玩家的作物？",
		options =
		{
			{description = "正常", data = 50},
			{description = "远", data = 75},
			{description = "非常远", data = 100},
		},
		default = 50,
	}
}