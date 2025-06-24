--Tribute to The Mighty
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.rfilter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsReleasable()
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and (c:IsLevel(5) or c:IsLevel(6)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.rfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--Tribute 1 monster to make opponent choose effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	if #g>0 then
		Duel.Release(g,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
				Duel.Draw(1-tp,1,REASON_EFFECT)				
			end
		end
	end
end