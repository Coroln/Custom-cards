--Dice Deity FIVE - Sorrow
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(s.sfilter),1,99)
	--Destroy monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Burn effect on destruction
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(s.damcon)
    e2:SetTarget(s.damtg)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
end
s.roll_dice=true
--Synchro Summon procedure
function s.sfilter(c,val,scard,sumtype,tp)
	return c.roll_dice
end
--Destroy monsters
function s.filter(c)
	return c:IsFaceup() and c:HasLevel() and not c.roll_dice
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local d1,d2=Duel.TossDice(tp,2)
	local sum=d1+d2
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,sum)
	Duel.Destroy(g,REASON_EFFECT)
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
    Duel.Damage(1-tp,dice*200,REASON_EFFECT)
end