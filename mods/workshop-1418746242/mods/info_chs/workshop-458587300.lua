name = "Fast Travel（快速旅行）"
description = "构造一个快速旅行网络，在标记点和标记点之间瞬间传送。"

configuration_options =
{
	{
        name = "Travel_Cost",
        label = "旅行消耗",
        options =
        {
            {description = "极低", data = 128},
            {description = "低", data = 64},
            {description = "正常", data = 32},
            {description = "高", data = 22.6}
        },
        default = 32,
    },
	{
        name = "Ownership",
        label = "所有权限制？",
        options =
        {
            {description = "启用", data = true},
            {description = "禁用", data = false}
        },
        default = false,
    },
}