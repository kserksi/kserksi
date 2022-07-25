name = "Chinese++"
description = "An optimizer for language pack."
author = "EvenMr"
version = "1.2.1"
forumthread = ""
api_version = 10
priority = -9999

dst_compatible = true

server_only_mod = false
all_clients_require_mod = false
client_only_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = 
{
	{
        name = "clearfont",
        label = "高清字体",
		hover = "是否启用高清字体(思源黑体)",
        options = 
        {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true
    },	
	{
        name = "eventplus",
        label = "活动增强",
		hover = "是否启用活动汉化修复功能",
        options = 
        {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true
    },
	{
        name = "extratrans",
        label = "更多汉化",
		hover = "是否汉化其它MOD",
        options = 
        {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true
    },
}

local ch_des = "本MOD集成了汉化增强和高清字体MOD的基本功能。除字体文件提取自原高清字体MOD外，代码完全重写，以确保对当前版本饥荒的兼容性。另外提供了暴食内容的汉化增强功能。\n\n注意!!!\n这不是汉化语言包，需要和其它汉化包配合使用！\n请勿和其它字体或暴食汉化增强MOD同时启用，否则随时可能内存不足！"

description = ch_des