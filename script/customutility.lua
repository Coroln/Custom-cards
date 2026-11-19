--This file contains a useful list of functions which can be used for a lot of things.

function Auxiliary.ForceExtraRules(c,card,init,...)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(Auxiliary.ForceExtraRulesOperation(card,init,...))
    Duel.RegisterEffect(e1,0)
end

function Auxiliary.ForceExtraRulesOperation(card,init,...)
    local arg = {...}
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c = e:GetOwner()
        local p = c:GetControler()
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(c,nil,-2,REASON_RULE)
        local ct = Duel.GetMatchingGroupCount(nil,p,LOCATION_HAND+LOCATION_DECK,0,c)
        if (Duel.IsDuelType(DUEL_MODE_SPEED) and ct < 20 or ct < 40) and Duel.SelectYesNo(1-p, aux.Stringid(4014,5)) then
            Duel.Win(1-p,0x55)
        end
        if c:IsPreviousLocation(LOCATION_HAND) then Duel.Draw(p, 1, REASON_RULE) end
        if not card.global_active_check then
            --Duel.ConfirmCards(1-p, c)
                --Duel.Hint(HINT_CARD,tp,c:GetCode())
                --Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(4014,7))
                --Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(4014,7))
                init(c,table.unpack(arg))
            card.global_active_check = true
        end
        e:Reset()
    end
end
function Auxiliary.doccost(min,max,label,cost,order)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ct,eff,set,label=c:GetOverlayCount(),Duel.IsPlayerAffectedByEffect(tp,CARD_NUMERON_NETWORK),c:IsSetCard(0x14b),label or false
		local min=min or ct
		local max=max or min
			if chk==0 then 
				if cost then
					return (c:CheckRemoveOverlayCard(tp,min,REASON_COST) or (eff and set)) and cost(e,tp,eg,ep,ev,re,r,rp,0)
					else return c:CheckRemoveOverlayCard(tp,min,REASON_COST) or (eff and set)
				end
			end
			if cost then
				if order==0 then
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						return true
							else
								cost(e,tp,eg,ep,ev,re,r,rp,1)
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
					end
				elseif order==1 then
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
								cost(e,tp,eg,ep,ev,re,r,rp,1)
					end
				else
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
					end
				end
			else
				if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
				end
			end
		if label==true then 
			e:SetLabel(#Duel.GetOperatedGroup())
		end
	end
end

function Auxiliary.spfilter(e,tp,sumtype,nocheck,nolimit,f,...)
	local params={...}
	return function(c)
		if f then return c:IsCanBeSpecialSummoned(e,sumtype,tp,nocheck,nolimit) and f(c,table.unpack(params))
		else return c:IsCanBeSpecialSummoned(e,sumtype,tp,nocheck,nolimit) end
	end
end

Auxiliary.MultiRegister=aux.FunctionWithNamedArgs(
	function(c,codes,desc,cat,prop,typ,range,con,cost,tg,op,opt,flags)
	local effs,flags={},flags or {}
	local e=Effect.CreateEffect(c)
	if desc then e:SetDescription(desc) end
	if cat then e:SetCategory(cat) end
	if prop then e:SetProperty(prop) end
	if range then e:SetRange(range) end
	e:SetType(typ)
	if con then e:SetCondition(con) end
	if cost then e:SetCost(cost) end
	if tg then e:SetTarget(tg) end
	e:SetOperation(op)
	if opt then
		if opt=="sopt" then e:SetCountLimit(1)
		elseif type(opt)=="number" and opt>0 then e:SetCountLimit(opt)
		elseif opt=="hopt" then e:SetCountLimit(1,c:GetOriginalCode())
		end
	end
	for i=1,#codes do
		e:SetCode(codes[i])
		c:RegisterEffect(e:Clone(),false,flags[i])
	end
	e:Reset()
end,"handler","codes","desc","cat","prop","typ","range","con","cost","tg","op","opt","flags")

function Auxiliary.SumtypeCon(c,st,con)
	return function(e,tp,eg,ep,ev,re,r,rp) 
		return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and c:IsSummonType(st)
	end
end

function Auxiliary.GetMinMaxMaterialCount(i,...)
	local params={...}
	local min,max=0,0
	for _,t in ipairs(params) do
		for _,val in ipairs(t) do
			min,max=min+val[i],max+val[i+1]
		end
	end
	return min,max
end

function Auxiliary.GetLinkMonstersPointingToSequence(tp, seq, f)
    local g = Group.CreateGroup()
    local tc

    if seq == 0 then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_LEFT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
            g:AddCard(tc)
        end
    end
    if seq == 1 then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 0)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_RIGHT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_LEFT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM) then
            g:AddCard(tc)
        end
    end
    if seq == 2 then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_RIGHT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_LEFT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
            g:AddCard(tc)
        end
    end
    if seq == 3 then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_RIGHT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 4)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_LEFT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM) then
            g:AddCard(tc)
        end
    end
    if seq == 4 then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_RIGHT) then
            g:AddCard(tc)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
        if tc and tc:IsLinkMonster() and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
            g:AddCard(tc)
        end
    end

	if f then
    	return g:Filter(f, nil)
	end
	return g
end

function Auxiliary.GetLinkMonstersPointingToMonster(c, f)
	if not c:IsMonster() then
		return Group.CreateGroup()
	end

	return aux.GetLinkMonstersPointingToSequence(c:GetControler(), c:GetSequence(), f)
end

--Hilfsfunktion, um Effekte zu registrieren, die feuern, wenn die Karte als Material benutzt wird.
--c: Die Karte
--tpe: Der Beschwörungstyp als Grund (REASON_FUSION, REASON_SYNCHRO, ...)
--cl: Ein optionales Countlimit als table
--f: Ein optionaler Filter den das Monster, für das die Karte als Material verwendet wird, erfüllen muss
--tg: Eine optionale Target-Funktion
--op: Die Operation-Funktion
function Auxiliary.RegisterUsedAsMaterialEffect(c, tpe, cl, f, tg, op)
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e:SetCode(EVENT_BE_MATERIAL)
    e:SetProperty(EFFECT_FLAG_DELAY)
    e:SetCountLimit(table.unpack(cl))
    e:SetCondition(aux.UsedAsMaterialCondition(c, tpe, f))
    if tg then
        e:SetTarget(tg)
    end
    e:SetOperation(op)
    c:RegisterEffect(e)
end

function Auxiliary.UsedAsMaterialCondition(c, tpe, f)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local rc = c:GetReasonCard()
        return (not f or f(rc, e, tp, eg, ep, ev, re, r, rp)) and (r & (tpe + REASON_MATERIAL)) > 0
    end
end
