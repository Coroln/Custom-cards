--Buzzing Nirocincta
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--give effect (protection)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(s.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(s.addct)
	e4:SetOperation(s.addc)
	c:RegisterEffect(e4)
end
s.listed_names={61517904}
s.counter_list={0x1BEE}
--special summon
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x1BEE,2,REASON_COST)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x1BEE,2,REASON_RULE)
end
--give effect (protection)
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCode(61517904)
end
--counter
function s.costfilter(c)
	return c:IsCode(61517904)
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1BEE)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,1) then
		local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0x1BEE,1)
	end
end
