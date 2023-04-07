--Alkdrache John das Tonic
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x14EC),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_DRAGON),1,99)
	c:EnableReviveLimit()
	--Must first be synchro summoned
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.remcon)
	e1:SetTarget(s.remtg)
	e1:SetOperation(s.remop)
	c:RegisterEffect(e1)
end
--remove
function s.remcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 and Duel.IsPlayerCanDraw(tp) then
		if Duel.IsPlayerAffectedByEffect(1-tp,69832741) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x0e,1,nil)
		else
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x1e,1,nil)
		end
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,69832741) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0x0e)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0x1e)
	end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if #g1>0 and ((#g2==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if #g2>0 and ((#sg==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if #g3>0 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	local ct1=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct1==0 then return end
	local ct2=Duel.Draw(tp,ct1,REASON_EFFECT)
end
