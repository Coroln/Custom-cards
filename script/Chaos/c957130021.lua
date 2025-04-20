--Mythical Chaos Ritual
local s,id=GetID()
function s.initial_effect(c)
    --Ritual Summon
    local e1=Ritual.CreateProc({
        handler=c,
        filter=s.ritual_filter,
        level=Ritual.LevelEqual,
        location=LOCATION_HAND,
        extra_material=s.extrafil,
        stage2=s.stage2
    })
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,{id,1})
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- Nur „Mythical Chaos Angel“-Ritualmonster
function s.ritual_filter(c)
    return c:IsRitualMonster() and c:IsSetCard(0x40CF) -- Ersetze 0xXYZ durch den tatsächlichen Setcode
end

-- Zusätzliche Materialien aus Hand/Feld
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
    return Duel.GetMatchingGroup(Card.IsMonster, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil)
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