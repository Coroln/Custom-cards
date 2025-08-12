--Silent Striker Spruzzard
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--cannot target
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
	--cannot destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.condition2)
    e1:SetTarget(s.target2)
    e1:SetOperation(s.operation2)
    c:RegisterEffect(e1)
end
s.listed_series={0x132F}
s.listed_names={id}
--cannot target
function s.condition(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x132F) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x132F)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(id,1))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetReset(RESETS_STANDARD_PHASE_END)
        e1:SetValue(aux.tgoval)
        tc:RegisterEffect(e1)
    end
end
--cannot destroy
function s.condition2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x132F) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x132F)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        --Cannot be destroyed by opponent's card effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3060)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
    end
end