--古代の機械城
--Ancient Gear Castle
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0xb)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_ANCIENT_GEAR))
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.addc)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	--summon proc
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCost(s.drcost)
	e5:SetOperation(s.drop)
	c:RegisterEffect(e5)
end
s.listed_series={SET_ANCIENT_GEAR}
function s.atkval(e,c)
	return e:GetHandler():GetCounter(0x1102)*100
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1102,1)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1102,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1102,5,REASON_COST)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,30000321)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end