local s,id=GetID()
function s.initial_effect(c)
	--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15939448,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--no battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Boost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.condtion)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,ct)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetDecktopGroup(1-tp,ct)
		if #g==0 then return end
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function s.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_BASE_DEFENSE)
		e1:SetValue(s.vald)
		e1:SetTarget(s.tg)
		e1:SetTargetRange(LOCATION_MZONE,0)
		Duel.RegisterEffect(e1,tp)
end
function s.tg(e,c)
	return c:IsRace(RACE_INSECT)
end
function s.vald(e,c)
return c:GetBaseDefense()+300 end