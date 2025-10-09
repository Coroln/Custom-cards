--Scripted by ChatGPT
local s,id=GetID()
function s.initial_effect(c)
	--Activate: target 1 face-up Fiend you control, then apply 1 chosen effect while this card remains face-up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Once per turn: Set this card
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3)) -- "Set this card"
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,id)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(s.setcon)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
end

function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
        local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
        if op == 0 then
            c:SetCardTarget(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(800)
            e1:SetCondition(s.rcon)
            tc:RegisterEffect(e1,true)
        elseif op == 1 then
            c:SetCardTarget(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_EXTRA_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(1)
            e1:SetCondition(s.rcon)
            tc:RegisterEffect(e1,true)
        else
            c:SetCardTarget(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_PIERCE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetCondition(s.rcon)
            tc:RegisterEffect(e1,true)
        end
	end
end
function s.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandlerPlayer()==e:GetOwnerPlayer()
end

--e4
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()==false
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return c:IsSSetable()
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.ChangePosition(c,POS_FACEDOWN)
	end
end
