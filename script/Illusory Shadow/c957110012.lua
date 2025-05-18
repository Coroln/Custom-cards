local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Materials and Special Summon Procedure
	Fusion.AddProcMix(c,true,false,s.FusGenFilter,s.FusLIGHTFilter,s.FusDARKFilter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,false)
	--Cannot be used as Fusion Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Only 1 Special Summon per turn from Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
    --Neither monster can be destroyed by battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.indestg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
    --immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.Protectfilter)
    e4:SetCondition(s.Protectcon)
	c:RegisterEffect(e4)

    --e5
    --Shuffle monster into the Deck; Shuffle opponents monster into the Deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
    e5:SetCost(s.ToDeck_cost)
	e5:SetTarget(s.ToDeck_tg)
	e5:SetOperation(s.ToDeck_op)
	c:RegisterEffect(e5)
    --Pay 500 LP as maintenance cost in the End Phase
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.mtcon)
	e6:SetOperation(s.mtop)
	c:RegisterEffect(e6)

    -- Optional destruction replacement: place in S/T Zone as Continuous Spell
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EFFECT_DESTROY_REPLACE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTarget(s.reptg)
    e7:SetOperation(s.repop)
    e7:SetValue(1)
    c:RegisterEffect(e7)

    --Negate all cards and effects activated in this card's column
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetRange(LOCATION_SZONE)
	e8:SetOperation(s.negop)
	c:RegisterEffect(e8)
end

function s.FusGenFilter(c)
	return c:IsSetCard(3003) and c:IsMonster()
end
function s.FusLIGHTFilter(c)
	return c:IsSetCard(3003) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsMonster()
end
function s.FusDARKFilter(c)
	return c:IsSetCard(3003) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsMonster()
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_GRAVE,0,nil)
end
function s.contactop(g,tp)
	local fu,fd=g:Split(Card.IsFaceup,nil)
	if #fu>0 then Duel.HintSelection(fu,true) end
	if #fd>0 then Duel.ConfirmCards(1-tp,fd) end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST|REASON_MATERIAL)
end

--e2
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return c:IsOriginalCode(id) and c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--e3
function s.indestg(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end

--e4
function s.Protectcon(e)
	local c=e:GetHandler()
	return c:IsFusionSummoned() and not (Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.GetCurrentPhase()==PHASE_DRAW)
end
function s.Protectfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--e5

function s.ToDeck_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

function s.tdfilter(c)
	return c:IsMonster() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SPECIAL))) and c:IsAbleToDeck()
end

function s.ToDeck_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function s.ToDeck_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--e6
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
--e7
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsFaceup() and c:IsFusionSummoned()
			and r&REASON_EFFECT~=0 and rp~=tp
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	return Duel.SelectYesNo(tp,aux.Stringid(id,2)) -- optionaler Prompt
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end

--e8 (from Disablaster the Negation Fortress)
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local seq,p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc&(LOCATION_MZONE|LOCATION_SZONE)==0 then return end --triggering outside the field or in the Field Zone
	if (seq==5 or seq==6) then --First, correct effects triggering in the Extra Monster Zone
		if seq==5 then
			seq=1
		elseif seq==6 then
			seq=3
		end
	end
	if p==1-tp then --Then correct effects triggering in the opponent's (main) sequences, by mirroring them to your sequences
		seq=4-seq
	end
	local dis_seq=e:GetHandler():GetSequence()
	if (dis_seq==5 or dis_seq==6) then --Then correct this card's sequence, if it is in the EMZ
		if dis_seq==5 then
			dis_seq=1
		elseif dis_seq==6 then
			dis_seq=3
		end
	end
	if dis_seq==seq and re:GetHandler():GetControler()~=tp then
		Duel.NegateEffect(ev)
	end
end
