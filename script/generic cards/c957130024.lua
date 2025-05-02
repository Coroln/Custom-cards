--D.D. Dhampir Duke
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Trick Summon
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,99}})
	c:EnableReviveLimit()

    -- ATK Boost if Linked
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.atkcon)
    e1:SetCost(Cost.PayLP(500))
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)

    -- Special Summon from GY when a Trap is activated (twice per turn)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re:IsTrapEffect() and re:IsHasType(EFFECT_TYPE_ACTIVATE) end)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    --Special Summon Monsters
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,{id,1})
    e3:SetCondition(s.spcon2)
    e3:SetOperation(s.setop)
    c:RegisterEffect(e3)

    --material count check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end

--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsSetCard(0x8e)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
-- ATK Boost – Target

function s.filter(c,sc,atk)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(sc) and (not atk or c:GetLink()>0)
end

function s.atkcon(e)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType, c:GetControler(), LOCATION_MZONE, LOCATION_MZONE, nil, TYPE_LINK)
	for tc in g:Iter() do
		if tc:GetLinkedGroup():IsContains(c) then
			return true
		end
	end
	return false
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chkc==0 then
        return chkc:IsOnField() and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,c,true)
    end
    if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c,true)
end

-- ATK Boost – Operation
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
    local atk=tc:GetLink()*500
    local g=tc:GetLinkedGroup():Filter(Card.IsFaceup,nil)
    g:AddCard(tc)
    for sc in g:Iter() do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESETS_STANDARD_DISABLE_PHASE_END,2)
        sc:RegisterEffect(e1)
    end
end

-- Trap Activated – Target
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(4)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

-- Trap Activated – Operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
            local c=e:GetHandler()
            -- Cannot be destroyed by battle
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            -- Cannot be destroyed by effects
            local e2=e1:Clone()
            e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
            tc:RegisterEffect(e2)
            -- Banish when leaves field
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
            e3:SetValue(LOCATION_REMOVED)
            tc:RegisterEffect(e3)
        end
    end
end


--Set Trap card's
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
	return ct >= 2 and (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.setfilter(c,e,tp)
	return c:IsMonster() and c:IsSetCard(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then lc=1 end
	local rg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
    Duel.SelectYesNo(tp,aux.Stringid(id,1))
    --local g = Duel.SelectMatchingCard(tp, s.setfilter, 1,tp,LOCATION_REMOVED,0,1,math.min(lc,ct),nil,e,tp)
    local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_REMOVED, 0, 1, math.min(lc, ct), nil, e, tp)

	--local g=aux.SelectUnselectGroup(rg,e,tp,1,math.min(lc,ct),s.setfilter,1,tp,HINTMSG_SPSUMMON)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Set its original ATK/DEF
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TRAP)
	e:GetLabelObject():SetLabel(ct)
end