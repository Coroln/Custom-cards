--Kagemane Chian Master - Utsuroi
--Script by Coroln and ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    --synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(Card.IsSetCard,0x759F),1,99)
    --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(s.indesval)
	c:RegisterEffect(e1)
    --counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
    --destroy
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
    e3:SetCost(s.cost)
    e3:SetTarget(s.target)
    e3:SetOperation(s.operation)
    c:RegisterEffect(e3)
    --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end
s.listed_series={0x759F}
--indes
function s.indesval(e,re)
	return re:IsActiveType(TYPE_SPELL)
end
--counter
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) then
		e:GetHandler():AddCounter(0x1098,1)
	end
end
--destroy
-- Helper function to generate a table of numbers from 1 to n
local function GetNumberTable(min, max)
    local t = {}
    for i = min, max do
        table.insert(t, i)
    end
    return t
end
-- Helper function to check if a table contains a specific value
function table.contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end
-- Helper function to filter a table based on a condition
function table.filter(tbl, cond)
    local result = {}
    for _, v in ipairs(tbl) do
        if cond(v) then
            table.insert(result, v)
        end
    end
    return result
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local maxCounters=c:GetCounter(0x1098)
    if chk==0 then return c:IsCanRemoveCounter(tp,0x1098,1,REASON_COST) and maxCounters>0 end
    local levels={}
    local ranks={}
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        local lv=tc:GetLevel()
        local rk=tc:GetRank()
        if lv>0 then
            table.insert(levels, lv)
        end
        if rk>0 then
            table.insert(ranks, rk)
        end
    end
    local validChoices = {}
    for _, lv in ipairs(levels) do
        if not table.contains(validChoices, lv) then
            table.insert(validChoices, lv)
        end
    end
    for _, rk in ipairs(ranks) do
        if not table.contains(validChoices, rk) then
            table.insert(validChoices, rk)
        end
    end
    validChoices = table.filter(validChoices, function(val)
        return val <= maxCounters
    end)
    if #validChoices == 0 then
        return false
    end
    local ct = Duel.AnnounceNumber(tp, table.unpack(validChoices))
    c:RemoveCounter(tp, 0x1098, ct, REASON_COST)
    e:SetLabel(ct)
end
-- Target: Destroy monsters with Level/Rank <= removed counters
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
    if chk==0 then
        return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_MONSTER),tp,0,LOCATION_MZONE,1,nil,ct)
    end
    -- Get the group of valid monsters and register them for destruction
    local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,ct)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- Filter: Monsters with Level/Rank <= removed counters
function s.filter(c,ct)
    if not c:IsFaceup() then return false end
    local level=c:GetLevel()
    local rank=c:GetRank()
    -- Check if level or rank is less than or equal to the removed counters
    return (level > 0 and level <= ct) or (rank > 0 and rank <= ct)
end

-- Operation: Destroy the selected monsters
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct>0 then -- Ensure counters were actually removed
        local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,ct)
        if #g>0 then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end
--draw
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end