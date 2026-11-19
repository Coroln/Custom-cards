Duel.LoadScript("custom_constants.lua")
Duel.LoadScript("proc_trick.lua")
Duel.LoadScript("card_util.lua")
Duel.LoadScript("group_util.lua")

Card.IsCanBeXyzMaterial = (function()
    local oldfunc = Card.IsCanBeXyzMaterial
	return function(c, xyz_monster, player, reason)
        if not xyz_monster or not xyz_monster.token_filter then
            return oldfunc(c, xyz_monster, player, reason)
        end
		return xyz_monster.xyz_filter(c, xyz_monster.token_filter(c, player, xyz_monster, reason), xyz_monster, player)
	end
end)()

Card.IsCanBeLinkMaterial = (function()
    local oldfunc = Card.IsCanBeLinkMaterial
	return function(c, link_monster, player)
        if not link_monster or not link_monster.st_filter then
            return oldfunc(c, link_monster, player)
        end
		return link_monster.link_filter(c, link_monster.st_filter(c, player, link_monster), link_monster, player)
	end
end)()

Link.AddProcedure = (function()
    local oldfunc = Link.AddProcedure
	return function(c, f, min, max, specialchk, desc)
        oldfunc(c, f, min, max, specialchk, desc)
        local mt = c:GetMetatable()
        mt.link_filter = function(mc, allowspelltrap, link, tp)
            if not mc then
                return false
            end
            if mc:IsMonster() then
                return not f or f(mc, link, SUMMON_TYPE_LINK | MATERIAL_LINK, tp)
            end

            return allowspelltrap
        end
	end
end)()

Link.ConditionFilter = (function()
    return function(c, f, lc, tp)
        local res1 = c:IsCanBeLinkMaterial(lc, tp) and (c:IsMonster() and (not f or f(c, lc, SUMMON_TYPE_LINK | MATERIAL_LINK, tp)) or (not c:IsMonster() and lc.st_filter and lc.st_filter(c, lc, tp)))
        local res2 = false
        local formud_eff = c:IsHasEffect(EFFECT_FORMUD_SKIPPER)
        if formud_eff then
            local label = {formud_eff:GetLabel()}
            for i = 1, #label - 1, 2 do
                c:AssumeProperty(label[i], label[i + 1])
            end
            res2 = c:IsCanBeLinkMaterial(lc, tp) and (c:IsMonster() and (not f or f(c, lc, SUMMON_TYPE_LINK | MATERIAL_LINK, tp)) or (not c:IsMonster() and lc.st_filter and lc.st_filter(c, lc, tp)))
        end
        return res1 or res2
    end
end)()

Link.Condition = (function()
    return function(f, minc, maxc, specialchk)
        return function(e, c, must, g, min, max)
            if c == nil then return true end
            if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
            local tp = c:GetControler()
            if not g then
                g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil) + Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_SZONE, 0, nil)
            end
            local mg = g:Filter(Link.ConditionFilter, nil, f, c, tp)
            local mustg = Auxiliary.GetMustBeMaterialGroup(tp, g, tp, c, mg, REASON_LINK)
            if must then mustg:Merge(must) end
            if min and min < minc then return false end
            if max and max > maxc then return false end
            min = min or minc
            max = max or maxc
            if mustg:IsExists(aux.NOT(Link.ConditionFilter), 1, nil, f, c, tp) or #mustg > max then return false end
            local emt, tg = aux.GetExtraMaterials(tp, mustg + mg, c, SUMMON_TYPE_LINK)
            tg:Match(Link.ConditionFilter, nil, f, c, tp)
            local mg_tg = mg + tg
            local res = mg_tg:Includes(mustg) and #mustg <= max
            if res then
                if #mustg == max then
                    local sg = Group.CreateGroup()
                    res = mustg:IsExists(Link.CheckRecursive, 1, sg, tp, sg, mg_tg, c, min, max, f, specialchk, mg, emt)
                elseif #mustg < max then
                    local sg = mustg
                    res = mg_tg:IsExists(Link.CheckRecursive, 1, sg, tp, sg, mg_tg, c, min, max, f, specialchk, mg, emt)
                end
            end
            aux.DeleteExtraMaterialGroups(emt)
            return res
        end
    end
end)()

Link.Target = (function()
    return function(f, minc, maxc, specialchk)
       return function(e, tp, eg, ep, ev, re, r, rp, chk, c, must, g, min, max)
            if not g then
                g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil) + Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_SZONE, 0, nil)
            end
            if min and min < minc then return false end
            if max and max > maxc then return false end
            min = min or minc
            max = max or maxc
            local mg = g:Filter(Link.ConditionFilter, nil, f, c, tp)
            local mustg = Auxiliary.GetMustBeMaterialGroup(tp, g, tp, c, mg, REASON_LINK)
            if must then mustg:Merge(must) end
            local emt, tg = aux.GetExtraMaterials(tp, mustg + mg, c, SUMMON_TYPE_LINK)
            tg:Match(Link.ConditionFilter, nil, f, c, tp)
            local sg = Group.CreateGroup()
            local finish=false
            local cancel=false
            sg:Merge(mustg)
            local mg_tg = mg + tg
            while #sg < max do
                local filters = {}
                if #sg > 0 then
                    Link.CheckRecursive2(sg:GetFirst(), tp, Group.CreateGroup(), sg, mg_tg, mg_tg, c, min, max, f, specialchk, mg, emt, filters)
                end
                local cg = mg_tg:Filter(Link.CheckRecursive, sg, tp, sg, mg_tg, c, min, max, f, specialchk, mg, emt, {table.unpack(filters)})
                if #cg == 0 then break end
                finish = #sg >= min and #sg <= max and Link.CheckGoal(tp, sg, c, min, f, specialchk, filters)
                cancel = Duel.IsSummonCancelable() and #sg == 0
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_LMATERIAL)
                local tc = Group.SelectUnselect(cg, sg, tp, finish, cancel, 1, 1)
                if not tc then break end
                if #mustg == 0 or not mustg:IsContains(tc) then
                    if not sg:IsContains(tc) then
                        sg:AddCard(tc)
                    else
                        sg:RemoveCard(tc)
                    end
                end
            end
            if #sg > 0 then
                local filters = {}
                Link.CheckRecursive2(sg:GetFirst(), tp, Group.CreateGroup(), sg, mg_tg, mg_tg, c, min, max, f, specialchk, mg, emt, filters)
                sg:KeepAlive()
                e:SetLabelObject({sg, filters, emt})
                return true
            else
                aux.DeleteExtraMaterialGroups(emt)
                return false
            end
        end 
    end
end)()

Link.GetLinkCount = (function()
    return function(c, tp, lc, sg)
        if c:IsLinkMonster() and c:GetLink() > 1 then
		    return 1 + 0x10000 * c:GetLink()
	    end
        local e = c:IsHasEffect(EFFECT_LINK_COUNT)
        if e and e:GetValue() then
            return 1 + 0x10000 * e:GetValue()(tp, lc, sg)
        end
        return 1
    end 
end)()

Link.CheckGoal = (function()
    return function(tp, sg, lc, minc, f, specialchk, filt)
        for _, filt in ipairs(filt) do
            if not sg:IsExists(filt[2], 1, nil, filt[3], tp, sg, Group.CreateGroup(), lc, filt[1], 1) then
                return false
            end
        end
	    return #sg >= minc and sg:CheckWithSumEqual(Link.GetLinkCount, lc:GetLink(), #sg, #sg, tp, lc, sg) and (not specialchk or specialchk(sg, lc, SUMMON_TYPE_LINK | MATERIAL_LINK, tp)) and Duel.GetLocationCountFromEx(tp, tp, sg, lc) > 0
    end
end)()
