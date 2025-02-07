local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WYRM),aux.FilterBoolFunctionEx(Card.IsRace,RACE_ILLUSION))
		--atk down
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e1:SetValue(s.val)
        c:RegisterEffect(e1)
        --def down
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e2:SetValue(s.val)
        c:RegisterEffect(e2)

        --Increase Level
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(id,1))
        e3:SetCategory(CATEGORY_LVCHANGE)
        e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCountLimit(1,{id,2})
        e3:SetCost(s.lvcost)
        e3:SetOperation(s.lvop)
        c:RegisterEffect(e3)
end

--e1/e2

function s.val(e,c)
    if c:IsType(TYPE_XYZ) then return c:GetRank()*-300
    else
        return c:GetLevel()*-300
    end
end

--e3
function s.cfilter(c,tp)
	return (not c:IsOnField() or c:IsFaceup()) and c:IsLevelBelow(4)
		and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(aux.AND(Card.IsFaceup,Card.HasLevel),tp,LOCATION_MZONE,0,1,c)
		and aux.SpElimFilter(c,true,true)
end
function s.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(-g:GetFirst():GetLevel())
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
		--Increase Level
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
end