--Savage Feral Imp
--Coroln
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
	--Send 1 Normal Monster card to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
end
--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsMonster()
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
--Send 1 Normal Monster card to the GY
function s.filter(c,tp)
	return c:IsType(TYPE_NORMAL) and c:IsMonster() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace(),c:GetAttribute())
end
function s.tgfilter(c,rac,att)
	return c:IsType(TYPE_NORMAL) and c:IsMonster() and not (c:IsRace(rac) and c:IsAttribute(att)) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetRace(),g:GetFirst():GetAttribute())
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
--atk up
function s.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsMonster()
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end