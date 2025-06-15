Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Send 1 trap from deck to GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
    e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
    --Special Self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(Cost.Discard())
    e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
	return c:IsTrap() and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--e2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if((r&REASON_TRICK) and (not c:IsSummonType(SUMMON_TYPE_MAXIMUM)) and c:GetReasonCard():IsAttribute(ATTRIBUTE_DARK))then
		return 1
	else
		return 0
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		c:AssumeProperty(ASSUME_RACE,RACE_FIEND)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
        --Target monster loses 500 ATK/DEF
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,0))
        e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetRange(LOCATION_MZONE)
        e1:SetHintTiming(TIMING_DAMAGE_STEP|TIMING_END_PHASE)
        e1:SetCountLimit(1,{id,2})
        e1:SetCondition(function() return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() end)
        e1:SetTarget(s.target_spop_e1)
        e1:SetOperation(s.atkop)
        c:RegisterEffect(e1)
		--c:RegisterEffect(e2)
        --atk
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCondition(s.e2filter)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT|RESETS_STANDARD)
        c:RegisterEffect(e3)

        --Change Attribute
        local e4=Effect.CreateEffect(c)
        e4:SetDescription(aux.Stringid(id,1))
        e4:SetType(EFFECT_TYPE_IGNITION)
        e4:SetRange(LOCATION_MZONE)
        e4:SetCountLimit(1,{id,3})
        e4:SetTarget(s.atttg)
        e4:SetOperation(s.attop)
        e4:SetReset(RESET_EVENT|RESETS_STANDARD)
        c:RegisterEffect(e4)
    
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetCode(EFFECT_UPDATE_ATTACK)
        e5:SetRange(LOCATION_MZONE)
        e5:SetValue(function(e,c) return 500*Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsTrick() end,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetBinClassCount(Card.GetAttribute) end)
        e5:SetReset(RESET_EVENT|RESETS_STANDARD)
        c:RegisterEffect(e5)
        Duel.SpecialSummonComplete()
	end
end
--Target monster gains 500 ATK/DEF
function s.filter(c)
	return c:IsFaceup() and c:IsTrick()
end
function s.target_spop_e1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--It gains 500 ATK/DEF
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
        --Unaffected by monster effects
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(3101)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetRange(LOCATION_MZONE)
		e2:SetValue(s.e1filter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function s.e1filter(e,re)
	return re:IsMonsterEffect() and re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function s.e2filter(e)
    local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_TRICK),c:GetControler(),LOCATION_MZONE,0,1,c)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local att=c:AnnounceAnotherAttribute(tp)
	e:SetLabel(att)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESETS_STANDARD_DISABLE_PHASE_END)
		c:RegisterEffect(e1)
	end
end