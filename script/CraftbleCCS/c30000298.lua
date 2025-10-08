Duel.EnableUnofficialProc(PROC_CANNOT_BATTLE_INDES)
local s,id=GetID()
function s.initial_effect(c)
	--c:EnableReviveLimit()
	--Immunity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.slifercon)
	e2:SetValue(s.unaffectedslifer)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(s.obeliskcon)
	e3:SetValue(s.unaffectedobelisk)
	c:RegisterEffect(e3)
	e4=e2:Clone()
	e4:SetCondition(s.racon)
	e4:SetValue(s.unaffectedra)
	c:RegisterEffect(e4)
	--Negate Konami Syndrome
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.disable)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
	--Consume
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetTarget(s.target)
	e6:SetOperation(s.operation)
	c:RegisterEffect(e6)
	--Special Summon this card
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTarget(s.sptg)
	e7:SetOperation(s.spop)
	c:RegisterEffect(e7)
	--King Crimson
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(s.sumsuc)
	c:RegisterEffect(e8)
	--Ensured Destruction
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BATTLE_INDES)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetTarget(s.tg)
	e9:SetValue(s.val)
	e9:SetCondition(s.slifercon)
	c:RegisterEffect(e9)
	--Mass Destruction
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e10:SetCondition(s.obeliskcon)
	e10:SetTarget(function(_e,_c) return _c:GetFlagEffect(id+100)>0 end)
	e10:SetValue(function(_e,_c) return _c==_e:GetHandler() end)
	e10:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_DAMAGE_STEP_END)
	e11:SetOperation(s.obeliskcon)
	e11:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_EXTRA_ATTACK)
	e12:SetValue(9999)
	e12:SetCondition(s.obeliskcon)
	e12:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
	c:RegisterEffect(e9)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_DAMAGE_STEP_END)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e13:SetOperation(s.unop)
	e13:SetCondition(s.obeliskcon)
	e13:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
	c:RegisterEffect(e13)
	--Fuse with Duelist
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(id,2))
	e14:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e14:SetCountLimit(1)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetCondition(s.racon)
	e14:SetCost(s.adcost)
	e14:SetOperation(s.adop)
	c:RegisterEffect(e14)
	--Cannot Lose Duel
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetCode(EFFECT_CANNOT_LOSE_LP)
	e15:SetRange(LOCATION_MZONE)
	e15:SetTargetRange(1,0)
	e15:SetValue(1)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e16)
	local e17=e15:Clone()
	e17:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e17)
	--Gains 500 ATK/DEF for each material attached to it
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e18:SetCode(EFFECT_UPDATE_ATTACK)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCondition(s.ritucon)
	e18:SetValue(function(e,c) return c:GetOverlayCount()*500 end)
	c:RegisterEffect(e18)
	local e19=e18:Clone()
	e19:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e19)
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(id,0))
	e20:SetCategory(CATEGORY_CONTROL)
	e20:SetType(EFFECT_TYPE_IGNITION)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCountLimit(1)
	e20:SetCost(s.ccost)
	e20:SetTarget(s.ttarget)
	e20:SetOperation(s.ooperation)
	c:RegisterEffect(e20)
end
s.listed_names={10000000,10000010,10000020}
function s.slifercon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsOriginalCodeRule,1,nil,10000020)
end
function s.obeliskcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsOriginalCodeRule,1,nil,10000000)
end
function s.racon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsOriginalCodeRule,1,nil,10000010)
end
function s.unaffectedslifer(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.unaffectedobelisk(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.unaffectedra(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.disable(e,c)
	return c:GetLevel()<=4 and c:IsAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack()>=2000
end
function s.filter(c)
	return c:IsRace(RACE_DIVINE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if c:IsRelateToEffect(e) and tc then
		Duel.Overlay(c,tc,true)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP) then c:CompleteProcedure() end
	end
end
function s.ritucon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not s.ritucon(e) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function s.tg(e,c)
	return e:GetHandler():GetBattleTarget()==c
end
function s.val(e,re,c)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.unop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		bc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1)
	end
end
function s.dirop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetAttackTarget() then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetCondition(s.obeliskcon)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
function s.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>0 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp)
	Duel.PayLPCost(tp,lp)
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--Fuse ATK/DEF
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetBaseAttack()+e:GetLabel())
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(c:GetBaseDefense()+e:GetLabel())
		c:RegisterEffect(e2)
	end
end
function s.cfilter(c)
	return c:IsDiscardable() and c:IsSpell()
end
function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.ooperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end