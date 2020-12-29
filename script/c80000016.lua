--Cyber Zerschlitzer
function c80000016.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80000016)
	e1:SetCondition(c80000016.spcon)
	e1:SetCost(c80000016.spcost)
	e1:SetTarget(c80000016.sptg)
	e1:SetOperation(c80000016.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000016,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,80000016)
	e2:SetTarget(c80000016.damtg)
	e2:SetOperation(c80000016.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(80000016,ACTIVITY_SPSUMMON,c80000016.counterfilter)
	--code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(64268668)
	c:RegisterEffect(e4)
end
function c80000016.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or (c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_EARTH))
end
function c80000016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80000016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80000016,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80000016.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000016.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsLocation(LOCATION_EXTRA)
end
function c80000016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c80000016.spfilter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c80000016.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000016,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c80000016.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c80000016.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
