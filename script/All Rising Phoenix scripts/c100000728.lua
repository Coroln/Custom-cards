 --Created and coded by Rising Phoenix
function c100000728.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000728.target)
	e1:SetOperation(c100000728.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000728,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c100000728.descost)
	e2:SetTarget(c100000728.sptg)
	e2:SetOperation(c100000728.spop)
	c:RegisterEffect(e2)
end
function c100000728.filter(c,e,tp)
	return  c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x760) or c:IsSetCard(0x761) or c:IsSetCard(0x762)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000728.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000728.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100000728.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000728.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
	end
end
function c100000728.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100000728.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x760) or c:IsSetCard(0x761) or c:IsSetCard(0x762)) and c:IsAbleToGrave()
end
function c100000728.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000728.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c100000728.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000728.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,nil,REASON_EFFECT)
	end
end
