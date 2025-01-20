--Astrid, Wielder of the Celestial Lance
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum Attribute
	Pendulum.AddProcedure(c)
	--Pendulum Effect 1: Treat Monster Zones as linked zones
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(0xff,0xff)
    e1:SetCondition(s.lcon)
    e1:SetValue(0x1)
	c:RegisterEffect(e1)
    local e1a=e1:Clone()
    e1a:SetValue(0x100000)
    c:RegisterEffect(e1a)
    local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1b:SetRange(LOCATION_PZONE)
    e1b:SetTargetRange(0xff,0xff)
    e1b:SetCondition(s.lcon2)
    e1b:SetValue(0x10)
	c:RegisterEffect(e1b)
    local e1c=e1b:Clone()
    e1c:SetValue(0x10000)
    c:RegisterEffect(e1c)
    --Back to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
    --splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	c:RegisterEffect(e3)
end
--Pendulum Effect 1: Treat Monster Zones as linked zones
function s.lcon(e)
	return e:GetHandler():GetSequence()==0
end
function s.lcon2(e)
	return e:GetHandler():GetSequence()==4
end
--Back to hand
function s.thfil(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfil,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_BP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	end
end
--splimit
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM)) and (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end