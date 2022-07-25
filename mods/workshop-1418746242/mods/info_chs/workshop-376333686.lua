name = "Combined Status（综合状态显示）"

description = "显示血量、饥饿值、精神值、温度、季节、月相和天数。"

local hud_scale_options = {}
for i = 1,21 do
	local scale = (i-1)*5 + 50
	hud_scale_options[i] = {description = ""..(scale*.01), data = scale}
end

configuration_options =
{
	{
		name = "SHOWTEMPERATURE",
		label = "温度",
		hover = "显示玩家的温度。",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "SHOWWORLDTEMP",
		label = "显示世界温度",
		hover = "显示世界的温度（不包含火等热源的因素）",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = false,
	},	
	{
		name = "SHOWTEMPBADGES",
		label = "显示温度图标",
		hover = "显示指示两个温度分别是哪个的图片。",
		options =	{
						{description = "显示", data = true, hover = "只有当两个温度都显示的时候图标才会显示。"},
						{description = "隐藏", data = false, hover = "图标始终都不会显示。"},
					},
		default = true,
	},	
	{
		name = "UNIT",
		label = "温度单位",
		hover = "选择你所需要的，剩下的交给游戏",
		options =	{
						{description = "游戏单位", data = "T",
							hover = "游戏所使用的数字。0\176过冷，70\176过热，差5\176警告。"},
						{description = "摄氏度", data = "C",
							hover = "游戏所使用的数字，但折半而使它更合常理。\n0\176C过冷，35\176C过热，差2.5\176C警告。"},
						{description = "华氏度", data = "F",
							hover = "你所喜欢却没有意义的单位。32\176F过冷，158\176F过热，差9\176F警告"},
					},
		default = "T",
	},
	{
		name = "SHOWWANINGMOON",
		label = "显示朔月",
		hover = "分别显示朔月和满月的月相，在已经显示两者的联机版中没有任何作用。",
		options =	{
						{description = "显示", data = true},
						{description = "不显示", data = false},
					},
		default = true,
	},
	{
		name = "SHOWMOON",
		label = "显示月亮",
		hover = "是否在白天和傍晚显示月相。",
		options =	{
						{description = "只有晚上", data = 0, hover = "和正常一样只在晚上显示月亮。"},
						{description = "傍晚", data = 1, hover = "在傍晚和夜里都显示月亮。"},
						{description = "总是", data = 2, hover = "一直都显示月亮"},
					},
		default = 1,
	},
	{
		name = "SHOWNEXTFULLMOON",
		label = "预测满月",
		hover = "预测下次满月的天数，将鼠标移到月亮图标上查看。",
		options =	{
						{description = "是", data = true},
						{description = "否", data = false},
					},
		default = true,
	},
	{
		name = "FLIPMOON",
		label = "翻转月亮",
		hover = "翻转月相（选是恢复以前的样式，将变成从南半球看上去的样子）",
		options =	{
						{description = "是", data = true, hover = "月亮显示为从南半球看上去的样子。"},
						{description = "否", data = false, hover = "月亮显示为从北半球看上去的样子。"},
					},
		default = false,
	},
	{
		name = "SEASONOPTIONS",
		label = "季节时钟",
		hover = "添加一个显示季节的时钟，并重新布局其它图标。\n或者也可以添加一个，当鼠标移上去显示当前季节已过和剩余天数的图标。",
		options =	{
						{description = "微型", data = "Micro"},
						{description = "紧凑", data = "Compact"},
						{description = "时钟", data = "Clock"},
						{description = "否", data = ""},
					},
		default = "Clock",
	},
	{
		name = "SHOWNAUGHTINESS",
		label = "淘气值",
		hover = "显示玩家的淘气值。在联机版中无效。",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "SHOWBEAVERNESS",
		label = "木头值",
		hover = "当伍迪是人形的时候显示木头值。在联机版中无效。",
		options =	{
						{description = "总是", data = true},
						{description = "仅海狸", data = false},
					},
		default = true,
	},	
	{
		name = "HIDECAVECLOCK",
		label = "洞穴时钟",
		hover = "在洞穴中显示时钟。仅单人游戏有效。",
		options =	{
						{description = "显示", data = false},
						{description = "隐藏", data = true},
					},
		default = false,
	},	
	{
		name = "SHOWSTATNUMBERS",
		label = "状态数值",
		hover = "显示血量，饥饿和精神值。",
		options =	{
						{description = "总是", data = true},
						{description = "仅鼠标悬停", data = false},
					},
		default = true,
	},	
	{
		name = "SHOWMAXONNUMBERS",
		label = "显示最大数值",
		hover = "在数值前显示\"最大值:\"，从而让它更易理解",
		options =	{
						{description = "显示", data = true},
						{description = "隐藏", data = false},
					},
		default = true,
	},	
	{
		name = "HUDSCALEFACTOR",
		label = "界面缩放",
		hover = "你可以在这里单独调整图标和时钟的尺寸，而不改变其它界面元素。",
		options = hud_scale_options,
		default = 100,
	},	
}