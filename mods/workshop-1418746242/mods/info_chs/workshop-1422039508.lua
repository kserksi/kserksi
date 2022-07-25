name = "Gorge Crops!（暴食作物）"
description = "添加暴食作物!"

configuration_options =
{

	{
		name = "",
		divider = "Crop Witherability Settings",
		label = "作物枯萎设置",
		options =	{	{description = "", data = 0},	},
	},
	{
		name = "CropWitherability",
		label = "作物是否会枯萎",
		options =	
		{
			{description = "是", data = 1},
			{description = "否", data = 0},
		},
		hover = "是否希望让作物不会在田里枯萎。",
	},
	{
        name = "CropWitherTime",
		label = "枯萎速度",
        options =
        {
            {description = "最慢", data = 480, hover = "一天"},
            {description = "慢", data = 360, hover = "3/4 天"},
            {description = "正常", data = 240, hover = "半天"},
            {description = "快", data = 120, hover = "1/4 天"},
            {description = "最快", data = 60, hover = "1/8 天"},
		},
		hover = "作物成熟后多久会枯萎？",
	},

	{
		name = "",
		divider = "Crop Growth Settings",
		label = "作物生长设置",
		options =	{	{description = "", data = 0},	},
	},
	
	{
        name = "NumberofCropsPerHarvest",
		label = "每次收获的作物数量",
        options =
        {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5", data = 5},
		},
		hover = "每次采摘你希望能获得多少作物？",
	},
	{
        name = "CropGrowthTime",
		label = "生长速率",
        options =
        {
            {description = "最慢", data = 3},
            {description = "更慢", data = 2},
			{description = "慢", data = 1.5},
            {description = "正常", data = 1},
            {description = "快", data = 0.75},
            {description = "更快", data = 0.5},
			{description = "最快", data = 0.25},
		},	
		hover = "作物成熟需要多久？",
	},
	{
        name = "SoilCycles",
		label = "土壤肥力",
        options =
        {
			{description = "是", data = 1},
            {description = "否", data = 0},

		},
		hover = "是否希望土壤需要重新施肥？",
	},
	{
        name = "NumberofHarvests",
		label = "收获次数",
        options =
        {
            {description = "最少", data = -2},
            {description = "较少", data = -1},
            {description = "正常", data = 0},
            {description = "较多", data = 1},
            {description = "最多", data = 2},
		},
		hover = "土壤需要施肥前可以收获多少次？",
	},
	
	{
		name = "",
		divider = "Seed Packet Settings",
		label = "袋装种子设置",
		options =	{	{description = "", data = 0},	},
		hover = "",
	},
	{
        name = "SeedPacketRecipe",
		label = "袋装种子配方",
        options =
        {
			{description = "是", data = 1},
            {description = "否", data = 0},

		},
        default = 1,	
		hover = "是否希望袋装种子可以被制作？",
	},
	{
        name = "SeedPacketRecipeDifficulty",
		label = "袋装种子配方难度",
        options =
        {
            {description = "简单", data = 1},
            {description = "较简单", data = 2},
            {description = "正常", data = 3},
            {description = "较困难", data = 4},
            {description = "困难", data = 5},
		},
        default = 3,	
		hover = "你希望配方难度有多高？",
	},
	{
		name = "",
		divider = "Recipe Settings",
		label = "配方设置",
		options =	{	{description = "", data = 0},	},
		default = 0,
		hover = "",
	},
	{
        name = "FoodSettings",
		label = "更改原有配方",
        options =
        {
			{description = "是", data = 1},
            {description = "否", data = 0},

		},
        default = 0,	
		hover = "你是否希望修改食谱以包含新的作物？",
	},

}