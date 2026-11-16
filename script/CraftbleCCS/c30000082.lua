local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
s.roll_dice=true
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local archfiend=0
	local dc=6
	while dc==6 do
	dc=Duel.TossDice(tp,1)
	if dc==1 then
	archfiend=30000304
	elseif dc==2 then
	archfiend=30000305
	elseif dc==3 then
	archfiend=30000302
	elseif dc==4 then
	archfiend=30000303
	elseif dc==5 then
	archfiend=30000301
	else
	archfiend=30000024
	end
	local token=Duel.CreateToken(tp,archfiend)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsChainDisablable(ev) then return false end
    local ex=Duel.GetOperationInfo(ev,CATEGORY_DICE)
    return ex and re:GetHandler():GetControler(1-tp) and re:GetHandler()~=e:GetHandler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,Group.FromCards(re:GetHandler()),1,1-tp,re:GetHandler():GetLocation())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_CARD,0,id)
        local cd=Duel.GetDiceResult()
        if cd~=0 then
            local dc=Duel.TossDice(tp,1)
            if dc>=cd then
                Duel.NegateEffect(ev)
            end
        end
    end
end