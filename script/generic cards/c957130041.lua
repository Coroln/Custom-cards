local s,id=GetID()
local CARD_AEOREOS_POSSESSION = 957130042
s.listed_names={CARD_AEOREOS_POSSESSION}
local COUNTER_AEOREOS = 0x1BBC
s.counter_place_list={COUNTER_AEOREOS}
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_AEOREOS)
    Pendulum.AddProcedure(c)
	--Cannot pendulum summon if you control a monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
    e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp) return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM end)
	c:RegisterEffect(e1)

    --You cannot Special Summon monsters from the Extra Deck
    local e2=e1:Clone()
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTarget(function (e,c,sump,sumtype,sumpos,targetp) return c:IsLocation(LOCATION_EXTRA) end)
    c:RegisterEffect(e2)
    --Add counter on Tribute summon of monster.
    local e3a=Effect.CreateEffect(c)
    e3a:SetDescription(aux.Stringid(id,0))
    e3a:SetCategory(CATEGORY_COUNTER)
    e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3a:SetRange(LOCATION_PZONE)
    e3a:SetCode(EVENT_SUMMON_SUCCESS)
    e3a:SetCondition(s.tdcon2)
    e3a:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,tp,COUNTER_AEOREOS) end)
    e3a:SetOperation(s.counterop)
    c:RegisterEffect(e3a)
    local e3b=e3a:Clone()
    e3b:SetCode(EVENT_MSET)
    e3b:SetCondition(s.tdcon3)
    c:RegisterEffect(e3b)

    --Activate
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_PZONE)
    e4:SetCost(Cost.RemoveCounterFromSelf(COUNTER_AEOREOS,3))
    e4:SetCountLimit(1,id)
    e4:SetTarget(s.e4tg)
    e4:SetOperation(s.e4op)
    c:RegisterEffect(e4)
    -----------------
    --Monster effect:
    -----------------
    --Half stats
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetOperation(s.e5op)
    c:RegisterEffect(e5)

    --double tribute
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e6:SetValue(function(e,c) return c:IsAttack(2600) and c:IsDefense(2000) end)
    c:RegisterEffect(e6)

    -- Effekt e7: In der Hand aktivieren
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,6))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_HAND)
    e7:SetCountLimit(1,{id,1})
    e7:SetTarget(s.e7tg)
    e7:SetOperation(s.e7op)
    c:RegisterEffect(e7)

    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,7))
    e8:SetCategory(CATEGORY_DRAW)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetCondition(function(e) return e:GetHandler():IsTributeSummoned() end)
    e8:SetCountLimit(1,{id,2})
    e8:SetTarget(s.e8tg)
    e8:SetOperation(s.e8op)
    c:RegisterEffect(e8)

    -- Effekt e9: Vom Extra Deck in die Pendelzone legen
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,8))
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_EXTRA)
    e9:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsFaceup() end)
    e9:SetCost(s.e9cost)
    e9:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.CheckPendulumZones(tp) end end)
    e9:SetCountLimit(1,{id,3})
    e9:SetOperation(s.e9op)
    c:RegisterEffect(e9)
end
--e3
function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()~=e:GetHandler() and ep==tp
		and eg:GetFirst():IsTributeSummoned()
end
function s.tdcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetMaterialCount()~=0 and ep==tp
end
function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(COUNTER_AEOREOS,1)
	end
end
--e4
function s.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_AEOREOS,1) and c:IsCode(CARD_AEOREOS_POSSESSION)
end
function s.e4tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and e:GetHandler():IsCanRemoveCounter(tp,COUNTER_AEOREOS,1,REASON_EFFECT)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end

function s.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(COUNTER_AEOREOS,1) then
		tc:AddCounter(COUNTER_AEOREOS,1)

        local op_table={}
        local op_val={}
        table.insert(op_table,aux.Stringid(id,0)) -- "No"
        table.insert(op_val,1)
        if s.e4chekLeftEffect(e,tp,eg,ep,ev,re,r,rp) then
            table.insert(op_table,aux.Stringid(id,1)) -- "Destroy cards in this Column"
            table.insert(op_val,2)
        elseif s.e4chekRightEffect(e,tp,eg,ep,ev,re,r,rp) then
            table.insert(op_table,aux.Stringid(id,2)) -- "Tribute Summoned monster gain 500"
            table.insert(op_val,3)
        end
        if s.e4checkLeftRightEffect(e,tp,eg,ep,ev,re,r,rp) then
            table.insert(op_table,aux.Stringid(id,3)) -- "look at top card and place it on top or Bottom"
            table.insert(op_val,4)
        end

        for k, v in pairs(op_val) do
                Debug.Message("k = " .. tostring(k) .. ", v = " .. tostring(v))
        end
        if #op_table>1 then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
            local sel=Duel.SelectOption(tp,table.unpack(op_table))
            Debug.Message("sel = " .. tostring(sel))
            local op_sel = op_val[sel+1]
            if op_sel == 1 then
                Debug.Message("op_sel == 1")
                return
            end
            Duel.BreakEffect()
            if op_sel == 2 then
                Debug.Message("op_sel == 2")
                s.e4opL(e,tp,eg,ep,ev,re,r,rp)
            elseif op_sel == 3 then
                Debug.Message("op_sel == 3")
                s.e4opR(e,tp,eg,ep,ev,re,r,rp)
            elseif op_sel == 4 then
                Debug.Message("op_sel == 4")
                s.e4opLR(e,tp,eg,ep,ev,re,r,rp)
            end
        end
    end
end

function s.e4chekRightEffect(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(function(c) return c:IsSummonType(SUMMON_TYPE_TRIBUTE) end,tp,LOCATION_MZONE,0,nil)
    return s.e4checkPZone(e,1) and #g>0
end

function s.e4checkLeftRightEffect(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,1)
    return #g > 0 and (s.e4checkPZone(e,0) or s.e4checkPZone(e,1))
end
function s.e4chekLeftEffect(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetColumnGroup():Filter(function(c) return true end,c,nil)
    return s.e4checkPZone(e,0) and #g>0
end

function s.e4checkPZone(e,Zone) -- left = 0, right = 1
    return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,Zone)
end

function s.e4opL(e,tp,eg,ep,ev,re,r,rp)
    Debug.Message("op L")
    local c=e:GetHandler()
    g=c:GetColumnGroup():Filter(function(c) return true end,c,nil)
    Duel.BreakEffect()
    Duel.Destroy(g,REASON_EFFECT)
end
function s.e4opR(e,tp,eg,ep,ev,re,r,rp)
    Debug.Message("op R")
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	for tc in g:Iter() do
		--Increase ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

function s.e4opLR(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,1)
    if #g > 0 and (s.e4checkPZone(e,0) or s.e4checkPZone(e,1)) then
        local tc=g:GetFirst()
        Duel.ConfirmDecktop(tp,1)
        if Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))==0 then
            Duel.MoveSequence(tc,SEQ_DECKTOP)
        else
            Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
        end
    end
end
-----------------
--Monster effect:
-----------------
--e5
function s.e5op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SWAP_BASE_AD)
        e1:SetReset(RESETS_STANDARD_PHASE_END)
        c:RegisterEffect(e1)
    end
end
--e7
function s.e7tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
            and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
    end
    -- Namen deklarieren
    s.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
    local ac=Duel.AnnounceCard(tp,s.announce_filter)
    Duel.SetTargetParam(ac)

    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.e7op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)

    -- Abbrechen, falls keine Karten im Deck
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end

    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()

    -- Vergleich: Stimmt die oberste Karte mit dem Namen überein?
    if tc:IsCode(ac) then
        -- 1. Spezialbeschwöre diese Karte von der Hand
        if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
            -- 2. Wenn Beschwörung erfolgreich, füge die Karte vom Deck der Hand hinzu
            Duel.BreakEffect()
            Duel.DisableShuffleCheck()
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
            Duel.ShuffleHand(tp)
        end
    else
        -- Falls falsch: Karte bleibt einfach oben liegen (oder optional mischen)
        Duel.MoveSequence(tc,SEQ_DECKTOP)
    end
end
--e8
function s.e8tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.e8op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end

--e9
-- Kosten: 1 Counter von "A'eareos's Possession" entfernen

function s.e9filter(c)
    return c:IsFaceup() and c:IsCode(CARD_AEOREOS_POSSESSION) and c:GetCounter(COUNTER_AEOREOS)>0
end

function s.e9cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.e9filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,COUNTER_AEOREOS,1,REASON_COST) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
    local g=Duel.SelectMatchingCard(tp,s.e9filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    g:GetFirst():RemoveCounter(tp,COUNTER_AEOREOS,1,REASON_COST)
end

function s.e9op(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
