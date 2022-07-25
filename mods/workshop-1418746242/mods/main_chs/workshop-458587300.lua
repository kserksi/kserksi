local trans_table={
	["Private property."] = "私人领地。",
	["This post is a private property."] = "该站点属于私人领地。",
	["There is no available destination."] = "无可用的目的地。",
	["There is nowhere to go."] = "无处可去。",
	["The destination is no longer reachable."] = "目的地已经无法前往。",
	["We don't ship dead bodies."] = "我们不运送尸体。",
	["It's not safe to travel."] = "现在旅行并不安全。",
	["Private destination. No visitors."] = "私人目的地。禁止参观。",
	["The destination is private."] = "目的地为私人领地",
	["I won't make it."] = "我做不到。",
	["You won't make it."] = "你做不到。",
	["Stay close."] = "请靠近。",
	["The destination is unreachable."]= "目的地无法前往。",
}
AddComponentPostInit("talker",function(self)
	local oldfn=self.mod_str_fn
	self.mod_str_fn=function(str)
		local t= string.match(str,"Travel in (%d) seconds*%.")
		if t then
			return "在"..t.."秒内传送"
		elseif string.match(str,"To:.+Hunger Cost:.+Sanity Cost:.+") then
			str = string.gsub(str,"To: ", "前往: ")
			str = string.gsub(str,"Hunger Cost: ", "饥饿消耗: ")
			str = string.gsub(str,"Sanity Cost: ", "精神消耗: ")
			str = string.gsub(str,"Unknown Destination", "未知目的地")
		elseif trans_table[str] then
			return trans_table[str]
		end
		if oldfn and type(oldfn)=="function" then
			return oldfn(str)
		end
		return str
	end
end)
AddPrefabPostInit("world",function()
	if GLOBAL.STRINGS.ACTIONS["DESTINATION"]=="Select Destination" then
		GLOBAL.STRINGS.ACTIONS["DESTINATION"]="选择目的地"
	end
end)