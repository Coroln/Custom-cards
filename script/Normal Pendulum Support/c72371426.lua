--Artificial Pendulum
--Coroln
Duel.LoadScript ("customutility2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum Attribute
	Pendulum.AddProcedure(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95453143,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--activate (spell)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--Change the Pendulum Scale of each card in your Pendulum Zones by 1 (min. 1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.pendscaletg)
	e3:SetOperation(s.pendscaleop)
	c:RegisterEffect(e3)
	--Add 1 Normal Pendulum monster from your Deck/Extra Deck to your hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67808837,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_SZONE) and e:GetHandler():IsPreviousPosition(POS_FACEUP) end)
	e4:SetTarget(s.thfrommdtg)
	e4:SetOperation(s.thfrommdop)
	c:RegisterEffect(e4)
	--Each time your Pendulum Monster(s) is Pendulum Summoned, gain atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.countercon)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
end
--copy
function s.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and c:IsMonster()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094258,3))
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SendtoExtraP(g,tp,REASON_COST)
	Duel.SetTargetCard(g)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		aux.CopyPendulumEffects(c,code,RESETS_STANDARD_DISABLE_PHASE_END|RESET_OPPO_TURN)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95453143,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_PZONE)
		e2:SetReset(RESETS_STANDARD_DISABLE_PHASE_END|RESET_OPPO_TURN)
		e2:SetLabel(code)
		e2:SetOperation(s.rstop)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--Change the Pendulum Scale of each card in your Pendulum Zones by 1 (min. 1)
function s.pendscaletg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,2,nil) end
	Duel.SetTargetCard(Duel.GetFieldGroup(tp,LOCATION_PZONE,0))
end
function s.pendscaleop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg==0 then return end
	local c=e:GetHandler()
	for sc in tg:Iter() do
		Duel.HintSelection(sc)
		local b1=true
		local b2=sc:GetScale()>1
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,4)},
			{b2,aux.Stringid(id,5)})
		local scale=op==1 and 1 or -1
		--Change each target's Pendulum Scale by 1 (min. 1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(scale)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		sc:RegisterEffect(e2)
	end
end
--Add 1 Normal Pendulum monster from your Deck/Extra Deck to your hand
function s.thfrommdfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and c:IsMonster() and c:IsAbleToHand()
end
function s.thfrommdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfrommdfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.thfrommdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfrommdfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Each time your Pendulum Monster(s) is Pendulum Summoned, gain atk
function s.counterconfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL) and c:IsPendulumSummoned() and c:IsSummonPlayer(tp)
end
function s.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.counterconfilter,1,nil,tp)
end
function s.atkfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsMonster()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(200)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
		end
	end
end