--PM Dragon Ascent
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	Ritual.AddProcEqual{handler=c,filter=s.ritualfil,matfilter=s.matfilter,nil}
    --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,id)
	e2:SetCost(aux.SelfDiscardCost)
	e2:SetCondition(s.dircon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
s.listed_names={35777553,41092585}
--Ritual Summon
function s.ritualfil(c)
	return c:IsCode(35777553) and c:IsRitualMonster()
end
function s.matfilter(c)
	return c:IsCode(41092585)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
end
--atkup
function s.cfilter1(c)
	return c:IsFaceup() and (c:IsCode(35777553) or c:IsCode(41092585) or c:IsRace(RACE_DRAGON))
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetOwnerPlayer(tp)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetOwnerPlayer(tp)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(-1000)
		tc:RegisterEffect(e2)
	end
end