local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCost(Cost.PayLP(2000))
    e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

    --Set this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMING_BATTLE_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_SZONE,0,1,nil) end)
    e2:SetCost(s.setcost)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)

    --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,id)
	e3:SetCost(Cost.SelfToDeck)
    e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end
--e1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0xBBB) and c:IsLevelBelow(5) and c:IsAbleToGrave()
end
function s.ACfilter(c,e,tp)
    return c:IsCode(957110005)
end
function s.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xBBB)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsCode(957110005)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
            Duel.BreakEffect()
            local op=nil
            local b1 =  Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
            local b2 = false
            local sg = false
            local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
            local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
            --if not ct or ct<=0 or ft<ct or ct>1 then return end
            if ft <= 0 then goto EFFECT_SELECTION_LABEL end
            sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ACfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,nil,e,tp)
            b2 = (#sg>=ct) and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_SZONE,0,1,nil)
            ::EFFECT_SELECTION_LABEL::
            if b1 and b2 then
            op=Duel.SelectEffect(tp,
                {b1,aux.Stringid(id,0)},
                {b2,aux.Stringid(id,1)})
            else
                if b1 then
                    if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then op = 1 end
                elseif b2 then
                    if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then op = 2 end
                end
            end

            if op~=nil then
                if op==1 then
                    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                    local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
                    if #g>0 then
                        Duel.SendtoGrave(g,REASON_EFFECT)
                    end
                elseif op==2 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
                    local ssg=sg:Select(tp,ct,ct,nil)
                    if #ssg==ct then
                        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
                        local tc=Duel.SelectMatchingCard(tp,s.ACfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
                        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                        local te=tc:GetActivateEffect()
                        local tep=tc:GetControler()
                    end
                end
            end
        end
	end
end

--e2
function s.setfilter(c,tp)
	return c:IsSetCard(0xBBB) and c:IsMonster() and c:IsAbleToDeckOrExtraAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() and Duel.SSet(tp,c)>0 then
		--Banish it when it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
		c:RegisterEffect(e1)
	end
end
--e3
function s.e3filter(c)
	return c:IsMonster() and c:IsSetCard(0xBBB) and c:IsAbleToDeck()
end
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.e3filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.e3filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.e3filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.ConfirmDecktop(tp,1)
	end
end
