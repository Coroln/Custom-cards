--PM Charizardite Y
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Activate
	Ritual.AddProcEqual{handler=c,filter=s.ritualfil,location=LOCATION_HAND|LOCATION_EXTRA,matfilter=s.matfilter,nil}
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
    --add back
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={19962005}
s.listed_series={0x7CC}
s.fit_monster={19962013}
--Ritual Summon
function s.ritualfil(c)
	return c:IsCode(19962013) and c:IsRitualMonster() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function s.matfilter(c)
	return c:IsCode(19962005)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
end
--draw
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)>0 then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,d,REASON_EFFECT)
    end
end
--add back
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end