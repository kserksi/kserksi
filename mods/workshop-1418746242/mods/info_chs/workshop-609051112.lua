name = "ActionQueue（DST行为排队论）"

description = "原作者: simplex。我更新了它以兼容联机版"..
"\n现在应该能在关闭行为预测的情况下工作了，感谢rezecib的帮助"..
"\n按住SHIFT点击制作，可自动重复制作物品（默认开启，可修改配置关闭）"..
"\nMOD设置中可激活自动拾取，SHIFT+右键框选自动种植,建墙"..
"\n按住SHIFT键框选可执行重复性工作（比如砍树，采矿等）"

configuration_options = {

    {
        name = "autoCollect",
        label = "自动采集",
        options = 
        {
            {description = "是", data = "yes"},
            {description = "否", data = "no"},
        },
        default = "no"
    },
    {
        name = "repeatMake",
        label = "重复制作",
        options = 
        {
            {description = "是", data = "yes"},
            {description = "否", data = "no"},
        },
        default = "yes"
    },
    {
        name = "aqKey",
        label = "替代SHIFT键",
        options = 
        {
            {description = "SHIFT", data = "SHIFT"},
            {description = "ALT", data = "ALT"},
            {description = "Z", data = "Z"},
            {description = "X", data = "X"},
            {description = "C", data = "C"},
            {description = "V", data = "V"},
            {description = "B", data = "B"},
        },
        default = "SHIFT"
    },
}



