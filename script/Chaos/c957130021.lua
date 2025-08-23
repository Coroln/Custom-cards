--Mythical Chaos Ritual
local s,id=GetID()
function s.initial_effect(c)
    --Ritual Summon
    Ritual.AddProcEqual(c,s.ritual_filter, nil, nil, nil, nil, nil, s.stage2, LOCATION_HAND):SetCountLimit(1,id)
    --set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,{id,1})
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end

-- Nur „Mythical Chaos Angel“-Ritualmonster
function s.ritual_filter(c)
    return c:IsRitualMonster() and c:IsSetCard(0x40CF) -- Ersetze 0xXYZ durch den tatsächlichen Setcode
end

-- Effekt nach der Beschwörung: 1 verbanntes „Mythical Chaos Angel“-Ritualmonster zur Hand hinzufügen
function s.stage2(op,e,tp,eg,ep,ev,re,r,rp,tc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

    if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if #g==0 then return end
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
    end
end

function s.thfilter(c)
    return c:IsSetCard(0x40CF) and c:IsRitualMonster() and c:IsAbleToHand() and c:IsFaceup()
end

--e2
function s.cfilter(c)
	return c:IsCode(957130018) or c:IsCode(39552864)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
