--Kuransain of Power
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.accon)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
    --increase ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x759F))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
    -- Store material count when leaving the field
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_LEAVE_FIELD_P)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetOperation(s.regop)
    c:RegisterEffect(e4)
    -- Draw and discard when destroyed
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(s.drcon)
    e5:SetTarget(s.drtg)
    e5:SetOperation(s.drop)
    c:RegisterEffect(e5)
    -- Link e2 and e3 for proper label handling
    e4:SetLabelObject(e5)
end
s.listed_series={0x759F}
--add Power Counter
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_DISCARD)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1022,1)
end
--increase ATK
function s.atkval(e,c)
	return e:GetHandler():GetCounter(0x1022)*100
end
--draw
-- Effect 2: Store material count before leaving the field
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetHandler():GetCounter(0x1022)
    if ct>0 then
        e:GetLabelObject():SetLabel(ct)
    end
end
-- Effect 3: Draw and discard when destroyed
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()>0 and e:GetHandler():IsReason(REASON_EFFECT) and rp==1-tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
    if chk==0 then return ct>0 end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    local dr=ct//2
    if ct>=2 and Duel.Draw(tp,dr,REASON_EFFECT)>0 then
        Duel.Draw(1-tp,dr-1,REASON_EFFECT)
    end
end
