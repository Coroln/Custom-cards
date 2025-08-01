--Dice Dragon - Earth
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--Burn effect on destruction
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(s.damcon)
    e2:SetTarget(s.damtg)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
	--fusion substitute while "Dice Dragon - Fire" is face-up
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_FUSION_SUBSTITUTE)
    e4:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
    e4:SetCondition(s.subcon)
    c:RegisterEffect(e4)
end
s.roll_dice=true
--dice
function s.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:IsType(TYPE_TUNER)
end
function s.condition(e,c)
	if c==nil then return true end
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    local d1,d2=Duel.TossDice(tp,2)
    local sum=d1+d2
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp)
    local combos={}
    for tc in g:Iter() do
        if tc:GetLevel()==sum then
            table.insert(combos,Group.FromCards(tc))
        end
    end
    for tc1 in g:Iter() do
        for tc2 in g:Iter() do
            if tc1~=tc2 and tc1:GetLevel()+tc2:GetLevel()==sum then
                table.insert(combos,Group.FromCards(tc1,tc2))
            end
        end
    end
    if #combos==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local options=Group.CreateGroup()
    for _,subg in ipairs(combos) do
        options:Merge(subg)
    end
    local sg=options:Select(tp,1,2,nil)
    if #sg==0 then return end
    local lv=0
    for tc in sg:Iter() do
        lv=lv+tc:GetLevel()
    end
    if lv~=sum then return end
    for tc in sg:Iter() do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
    end
    Duel.SpecialSummonComplete()
end
function s.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
--Burn effect on destruction
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local dice=Duel.TossDice(tp,1)
    Duel.Damage(1-tp,dice*100,REASON_EFFECT)
end
--fusion substitute while "Dice Dragon - Fire" is face-up
function s.subcon(e)
    return Duel.IsExistingMatchingCard(s.firefilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.firefilter(c)
    return c:IsFaceup() and c:IsCode(61730205)
end
