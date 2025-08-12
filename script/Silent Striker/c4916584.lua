--Rapid Updraft
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x4911,LOCATION_SZONE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Place 2 "Silent Striker" monsters from your hand to your Pendulum Zones
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.pltg)
	e2:SetOperation(s.plop)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e3:SetCost(s.atkcost)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(s.drawcost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
	--change pendulum scale to 13
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,{id,3},EFFECT_COUNT_CODE_OATH)
	e5:SetCost(s.pencost)
	e5:SetTarget(s.pentg)
	e5:SetOperation(s.penop)
	c:RegisterEffect(e5)
end
s.counter_place_list={0x4911}
s.listed_series={0x132F}
--Place 2 "Silent Striker" monsters from your hand to your Pendulum Zones
function s.pcfilter(c)
	return c:IsSetCard(0x132F) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
	--Activation legality
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_PZONE,0,1,nil,TYPE_PENDULUM) end
        local gg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_PZONE,0,nil,TYPE_PENDULUM)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,gg,#gg,tp,0)
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local pc=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_PZONE,0,nil,TYPE_PENDULUM)
    if c:IsRelateToEffect(e) and pc and Duel.SendtoHand(pc,tp,REASON_COST)>=1 then
		local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_HAND,0,nil)
        if Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
            local pg=aux.SelectUnselectGroup(g,e,tp,2,2,aux.TRUE,1,tp,HINTMSG_TOFIELD)
            if #pg~=2 then return end
            local pc1,pc2=pg:GetFirst(),pg:GetNext()
            if Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
                if Duel.MoveToField(pc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
                    pc2:SetStatus(STATUS_EFFECT_ENABLED,true)
                end
                pc1:SetStatus(STATUS_EFFECT_ENABLED,true)
				c:AddCounter(0x4911,2)
            end
        end
    end
end
--attack up
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4911,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x4911,2,REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x132F)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--draw
function s.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4911,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x4911,4,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--change pendulum scale to 13
function s.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4911,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x4911,6,REASON_COST)
end
function s.penfilter(c)
	return c:IsSetCard(0x132F) and c:IsType(TYPE_PENDULUM) and not c:GetScale()~=13
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.penfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.penfilter,tp,LOCATION_PZONE,0,1,1,nil)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(13)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
	end
end