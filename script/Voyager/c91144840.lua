--Voyager B.E.S. Assault Core
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.destg)
	e5:SetValue(s.value)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	--Store material count when leaving the field
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_LEAVE_FIELD_P)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetOperation(s.regop)
    c:RegisterEffect(e6)
    --Draw and discard when destroyed
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_BE_MATERIAL)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(s.drcon)
    e7:SetTarget(s.drtg)
    e7:SetOperation(s.drop)
    c:RegisterEffect(e7)
    e6:SetLabelObject(e7)
end
s.listed_names={id}
s.listed_sersies={0x943}
--special summon
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
--counter
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x1f)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1f,3)
	end
end
--destroy replace
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0x1f,1,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.value(e,c)
	return c:IsFaceup() and ((c:GetLocation()==LOCATION_MZONE and c:IsSetCard(0x15)) or c:IsSetCard(0x943))
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x1f,1,REASON_COST)
end
--draw
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetHandler():GetCounter(0x1f)
    if ct>0 then
        e:GetLabelObject():SetLabel(ct)
    end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
    return e:GetLabel()>0 and r&REASON_LINK==REASON_LINK
		and rc:IsSetCard(0x943) and rc:IsType(TYPE_LINK)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
    if chk==0 then return ct>0 end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
