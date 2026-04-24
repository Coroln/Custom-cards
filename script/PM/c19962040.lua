--PM Mewtu
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Must be Special Summoned with a "PM" card
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,sum_eff) return sum_eff:GetHandler():IsSetCard(0x7CC) end)
	c:RegisterEffect(e0)
	--copy summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
s.listed_names={id,94033810}
s.listed_series={0x7CC}
--copy summon
function s.filter(c,e,tp)
	return c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local token=Duel.CreateToken(tp,id+1) -- your EMPTY token ID
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	-- Change name
	local e0=Effect.CreateEffect(token)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(tc:GetCode())
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e0)
	-- Copy effects
	token:CopyEffect(tc:GetCode(),RESET_EVENT+RESETS_STANDARD)
	-- ATK
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e1)
	-- DEF
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	-- Attribute
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(tc:GetAttribute())
	token:RegisterEffect(e3)
	-- Race
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	-- Level handling
	local lv=0
	if tc:IsType(TYPE_LINK) then
		lv=tc:GetLink()
	elseif tc:IsType(TYPE_XYZ) then
		lv=tc:GetRank()
	else
		lv=tc:GetLevel()
	end
	if lv>0 then
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_LEVEL)
		e5:SetValue(lv)
		token:RegisterEffect(e5)
	end
	-- Add "PM"
	local e6=e1:Clone()
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x7CC)
	token:RegisterEffect(e6)
	-- Summon restriction
	local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e7:SetTargetRange(1,0)
	e7:SetTarget(function(e,c) return not c:IsSetCard(0x7CC) end)
	e7:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e7,tp)
end
--atk gain
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(94033810)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,1000)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Make this card gain 1000 ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end