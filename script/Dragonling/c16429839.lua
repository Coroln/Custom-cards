--Radish Dragonling
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(Cost.SelfReveal)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={0xCF13}
--Negate
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsSetCard(0xCF13) or tc:IsCode(59481082) then
		if Duel.NegateEffect(ev) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end