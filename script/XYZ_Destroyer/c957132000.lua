local s,id=GetID()
function s.initial_effect(c)
    -- Quick Effect: Gain ATK, DEF, and Level
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(mg) do
		g:Merge(tc:GetOverlayGroup())
	end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	
    e:SetLabelObject(sc)

	Duel.SendtoGrave(sc,REASON_COST)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetLabelObject()
    if not (c:IsRelateToEffect(e) and tc) then return end
    
    local atk=math.floor((tc:GetAttack()*0.55)/100)*100
    local def=math.floor((tc:GetDefense()*0.55)/100)*100
    local lvl=tc:GetLevel()
    
    if atk>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
    if def>0 then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(def)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2)
    end
    if lvl>0 then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_LEVEL)
        e3:SetValue(lvl)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e3)
    end
end
