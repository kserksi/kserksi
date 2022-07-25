local string = GLOBAL.string
local STRINGS = GLOBAL.STRINGS
AddComponentPostInit("hounded", function(self)
	local defaultPhrase
	if GLOBAL.TheWorld:HasTag("cave") then
	  defaultPhrase = STRINGS.CHARACTERS.GENERIC.ANNOUNCE_WORMS
	else
	  defaultPhrase = STRINGS.CHARACTERS.GENERIC.ANNOUNCE_HOUNDS
	end
	STRINGS.CHARACTERS.GENERIC.ANNOUNCE_HOUNDS = "我的天，那是啥！！"
	
	local function getDumbString(num)
    if num == 1 then return "一只！"
		elseif num == 2 then return "两只！"
		elseif num == 3 then return "三只！"
		elseif num == 4 then return "四只！"
		else return "太多了！" end
	end
	
	setval(self.OnUpdate, "updateWarningString", function(index)
		local updateWarningString = getval(self.OnUpdate, "updateWarningString")
		local warningCount = getval(updateWarningString, "warningCount")
		local MOB_LIST = getval(updateWarningString, "MOB_LIST")
		for i,v in ipairs(GLOBAL.AllPlayers) do
			local character = string.upper(v.prefab)
			if character == nil or character == "WILSON" then
				character = "GENERIC"
			end
			
			-- If this is a mod character (or wes)...or just doesn't have
			-- this string defined...don't say anything.
			if STRINGS.CHARACTERS[character] == nil then
			   return
			end
			
			if not index then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "我……不确定那声音是什么……"
				return
			end
				
			local prefab = MOB_LIST[index].prefab
			if prefab == nil then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = defaultPhrase
			elseif prefab == "merm" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "哦天哪，它闻起来像腐烂的鱼。"
			elseif prefab == "spider" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "听起来像是上万只小腿踏在地上。"
			elseif prefab == "tallbird" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "听起来像是谋杀了……一群高脚鸟。"
			elseif prefab == "pigman" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "那是猪哼哼么？"
			elseif prefab == "killerbee" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "是蜜蜂啊啊啊啊啊！！！"
			elseif prefab == "mosquito" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "我听到了上万个微小的吸血鬼。"
			elseif prefab == "lightninggoat" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "这些巨大的乌云看起来像是某种不详的预兆。"
			elseif prefab == "beefalo" then
				if warningCount == 1 then
					STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "你感受到了吗？"
				else
					STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "大地在震动！"
				end
			elseif prefab == "bat" then
				-- TODO: Increment the count each warning lol
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = getDumbString(warningCount) .. "啊啊啊！"
			elseif prefab == "knight" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "骑兵正在接近！"
			elseif prefab == "perd" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "咯咯咯！！！"
			elseif prefab == "penguin" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "摇摇晃晃摇摇晃晃……"
			elseif prefab == "walrus" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "猎人成了狩猎目标。"
			elseif prefab == "warg" then
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = "这只听起来要比别的大……"
			elseif prefab == "spider_hider" then
				STRINGS.CHARACTERS[character].ANNOUNCE_WORMS = "蜘蛛？！？！"
			else
				STRINGS.CHARACTERS[character].ANNOUNCE_HOUNDS = defaultPhrase
			end
		end
	end)
end)