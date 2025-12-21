--Shaman's Staff
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCanAddCounter,0xFF,1,false,LOCATION_MZONE))
    --Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
    --counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE|PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.addct)
	e3:SetOperation(s.addc)
	c:RegisterEffect(e3)
end
s.counter_place_list={0xFF}
--counter
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xFF)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetEquipTarget()
	tc:AddCounter(0xFF,1)
end