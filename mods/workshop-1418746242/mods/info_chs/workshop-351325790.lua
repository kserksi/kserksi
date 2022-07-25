name = "Geometric Placement（几何放置）"
description = "在放置物品时将其吸附到网格上，并在周围显示网格线（除非你按住Ctrl）"

local smallgridsizeoptions = {}
for i=0,10 do smallgridsizeoptions[i+1] = {description=""..(i*2).."", data=i*2} end
local medgridsizeoptions = {}
for i=0,10 do medgridsizeoptions[i+1] = {description=""..(i).."", data=i} end
local floodgridsizeoptions = {}
for i=0,10 do floodgridsizeoptions[i+1] = {description=""..(i).."", data=i} end
local biggridsizeoptions = {}
for i=0,5 do biggridsizeoptions[i+1] = {description=""..(i).."", data=i} end

local KEY_A = 65
local keyslist = {}
local string = "" -- can't believe I have to do this... -____-
for i = 1, 26 do
	local ch = string.char(KEY_A + i - 1)
	keyslist[i] = {description = ch, data = ch}
end

local percent_options = {}
for i = 1, 10 do
	percent_options[i] = {description = i.."0%", data = i/10}
end
percent_options[11] = {description = "不限", data = false}

configuration_options =
{
	{
		name = "CTRL",
		label = "CTRL功能翻转",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,
		hover = "当按住CTRL时启用还是禁用MOD。",
	},
    {
        name = "KEYBOARDTOGGLEKEY",
        label = "设置键",
        options = keyslist,
        default = "B",
		-- hover = "A key to open the mod's options. On controllers, open\nthe scoreboard and then use Menu Misc 3 (left stick click).\nI recommend setting this with the Settings menu in DST.",
		hover = "打开MOD设置的按键。使用手柄时，打开计分板并使用菜单杂项3键（点击左侧摇杆）",
    },    
    {
        name = "GEOMETRYTOGGLEKEY",
        label = "切换键",
        options = keyslist,
        default = "V",
		-- hover = "A key to toggle to the most recently used geometry\n(for example, switching between Square and X-Hexagon)\nI recommend setting this with the Settings menu in DST.",
		hover = "切换到最近使用布局的按键（例如，在矩形和X轴六边形间切换）",
    },    
    {
        name = "SHOWMENU",
        label = "游戏内菜单",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
        default = true,
		hover = "如果启用，设置键将打开菜单。\n如果关闭，则它将开启或关闭该MOD。",
    },    
	{
		name = "BUILDGRID",
		label = "显示建造网格",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = true,	
		hover = "是否显示建造网格。",
	},
	{
		name = "GEOMETRY",
		label = "网格布局",
		options =	{
						{description = "矩形", data = "SQUARE", hover = "与世界X-Z坐标系对齐。墙和地皮始终使用该布局。"},
						{description = "菱形", data = "DIAMOND", hover = "旋转45\176的矩形.默认视角下看起来是矩形。"},
						{description = "X轴六边形", data = "X_HEXAGON", hover = "顶边平行于X轴的正六边形"},
						{description = "Z轴六边形", data = "Z_HEXAGON", hover = "顶边平行于Z轴的正六边形"},
						{description = "扁六边形", data = "FLAT_HEXAGON", hover = "默认视角下顶部为边的正六边形"},
						{description = "尖六边形", data = "POINTY_HEXAGON", hover = "默认视角下顶部为角的正六边形"},
					},
		default = "SQUARE",	
		hover = "所使用的网格布局",
	},
	{
		name = "TIMEBUDGET",
		label = "刷新频率",
		options = percent_options,
		default = 0.1,	
		hover = "将多少可用时间用于刷新网格。不限或者设置得太高很可能导致卡顿。",
	},
	{
		name = "HIDEPLACER",
		label = "隐藏占位标记",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "是否隐藏占位标记（你所要防止物品的虚影）。隐藏它可以让网格看得更清楚。",
	},
	{
		name = "HIDECURSOR",
		label = "隐藏光标物品",
		options =	{
						{description = "全部隐藏", data = 1},
						{description = "仅显示数量", data = true},
						{description = "全部显示", data = false},
					},
		default = false,	
		hover = "是否隐藏鼠标所点选的物品，让网格看得更清楚。",
	},
	{
		name = "SMALLGRIDSIZE",
		label = "小网格尺寸",
		options = smallgridsizeoptions,
		default = 10,	
		hover = "使用小网格的物品（建筑，植物等）显示多大的网格。",
	},
	{
		name = "MEDGRIDSIZE",
		label = "墙体网格尺寸",
		options = medgridsizeoptions,
		default = 6,	
		hover = "墙体显示多大的网格。",
	},
	{
		name = "FLOODGRIDSIZE",
		label = "沙袋网格尺寸",
		options = floodgridsizeoptions,
		default = 5,	
		hover = "沙袋显示多大的网格。",
	},
	{
		name = "BIGGRIDSIZE",
		label = "地皮网格尺寸",
		options = biggridsizeoptions,
		default = 2,	
		hover = "地皮/草叉显示多大的网格。",
	},
	{
		name = "COLORS",
		label = "网格颜色",
		options =	{
						{description = "红/绿", data = "redgreen", hover = "正常游戏使用的标准红/绿色。"},
						{description = "红/蓝", data = "redblue", hover = "将绿色替换成蓝色，适合红绿色盲使用。"},
						{description = "黑/白", data = "blackwhite", hover = "被阻挡显示为黑色，可放置则为白色。一般来说看得更清楚。"},
						{description = "描边", data = "blackwhiteoutline", hover = "黑色和白色，但为了看得更清楚而加了描边。"},
					},
		default = "blackwhiteoutline",	
		hover = "网格和占位符的替代配色方案，使它们看起来更清晰。",
	},
	{
		name = "REDUCECHESTSPACING",
		label = "缩小箱子间距",
		options =	{
						{description = "是", data = true},
						{description = "否", data = false},
					},
		default = true,	
		hover = "是否允许箱子比正常放置得更紧密。这在联机版中可能无效。",
	},
	{
		name = "CONTROLLEROFFSET",
		label = "手柄偏移",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "使用手柄时，物品正好被放在你脚下还是偏移一些。",
	},
	{
		name = "HIDEBLOCKED",
		label = "隐藏受阻点",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "直接隐藏受到阻碍的点，而不是显示为红/黑色。",
	},
	{
		name = "SHOWTILE",
		label = "显示最近地皮",
		options =	{
						{description = "开启", data = true},
						{description = "关闭", data = false},
					},
		default = false,	
		hover = "当放置任何东西时，显示最近地皮的轮廓。",
	},
}