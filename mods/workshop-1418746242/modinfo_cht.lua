description = "An optimizer for language pack."

configuration_options = 
{
	{
        name = "clearfont",
        label = "高清字體",
		hover = "是否啟用高清字體(思源黑體)",
        options = 
        {
            {description = "開啟", data = true},
            {description = "關閉", data = false},
        },
        default = true
    },	
	{
        name = "eventplus",
        label = "活動增強",
		hover = "是否啟用活動漢化修復功能",
        options = 
        {
            {description = "開啟", data = true},
            {description = "關閉", data = false},
        },
        default = true
    },
	{
        name = "extratrans",
        label = "更多漢化",
		hover = "是否漢化其它MOD",
        options = 
        {
            {description = "開啟", data = true},
            {description = "關閉", data = false},
        },
        default = true
    },
}

local ch_des = "本MOD集成了漢化增強和高清字體MOD的基本功能。除字體文件提取自原高清字體MOD外，代碼完全重寫，以確保對當前版本飢荒的兼容性。另外提供了暴食內容的漢化增強功能。 \n\n注意!!!\n這不是漢化語言包，需要和其它漢化包配合使用！ \n請勿和其它字體或暴食漢化增強MOD同時啟用，否則隨時可能內存不足！"

description = ch_des