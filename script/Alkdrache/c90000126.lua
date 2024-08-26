--Alkdrache Sib der Zombie
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,90000127,0,TYPES_TOKEN,0,0,1,RACE_DRAGON,ATTRIBUTE_WATER,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,90000127,0,TYPES_TOKEN,0,0,1,RACE_DRAGON,ATTRIBUTE_WATER,POS_FACEUP) then return end
	local c=e:GetHandler()
	for i=1,2 do
		local token=Duel.CreateToken(tp,90000127)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		--Cannot be used as Link Material
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3312)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		--Inflict 300 damage when destroyed
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(s.damop)
		token:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Recover(c:GetPreviousControler(),300,REASON_EFFECT)
	end
	