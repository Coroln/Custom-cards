local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=s.ffilter,matfilter=Card.IsAbleToDeck,
									 extrafil=s.fextra,extraop=Fusion.ShuffleMaterial,stage2=s.Effgain_op,extratg=s.extrtarget})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)

    --GY Effect: Special Summon from S&T Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Banished Effect: Return Fusion to Extra Deck and optionally destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end

function s.ffilter(c)
	return c:IsSetCard(3003)
end
function s.fextra(e,tp,mg,sumtype)
	return Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_GRAVE,0,nil)
end
function s.Effgain_op(e,tc,tp,mg,chk)
    if chk==0 then
        --Destroy opponent's monster was not destroyed by the battle
        local e1=Effect.CreateEffect(tc)
        e1:SetDescription(aux.Stringid(id,1))
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_DAMAGE_STEP_END)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESETS_STANDARD_DISABLE_PHASE_END)
        e1:SetTarget(s.destg)
        e1:SetOperation(s.desop)
        tc:RegisterEffect(e1)
        
        if not tc:IsType(TYPE_EFFECT) then
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_ADD_TYPE)
            e2:SetValue(TYPE_EFFECT)
            e2:SetReset(RESETS_STANDARD_DISABLE_PHASE_END)
            tc:RegisterEffect(e2,true)
        end
    end
end
function s.extrtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND|LOCATION_MZONE|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,b=Duel.GetBattleMonster(tp)
	if chk==0 then return a and b and b:IsRelateToBattle() and b:IsLocation(LOCATION_MZONE)
		and a==e:GetHandler() end
	e:SetLabelObject(b)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,b,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		if Duel.Destroy(tc,REASON_EFFECT) then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
			local c=e:GetHandler()
			for mc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				mc:RegisterEffect(e1)
			end
		end
	end
end

--Effect 2: GY – Special Summon monster from S/T Zone
function s.filter(c,e,sp)
	return c:IsFaceup() and c:IsOriginalType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

--Effect 3: Banished – Return Fusion + destroy
function s.tdfilter(c)
	return c:IsSetCard(3003) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToDeck() then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #dg>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
