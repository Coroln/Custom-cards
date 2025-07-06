Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Return Attacking Monster to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --Return 1 monster on each side to Hand if used as Trick Material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(s.thcon2)
	e2:SetTarget(s.thtg2)
    e2:SetOperation(s.opATK200)
    c:RegisterEffect(e2)
end
--e1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tp~=Duel.GetTurnPlayer() and tc:IsAttribute(ATTRIBUTE_WIND)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg and tg:IsAbleToHand() end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) and tg:IsAbleToHand() end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


--e2
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
    local c=e:GetHandler() -- the material
    local sc=re:GetHandler() -- the monster that was summoned using this card as material
    return sc:IsSummonType(SUMMON_TYPE_SPECIAL) and sc:IsPreviousLocation(LOCATION_EXTRA)
        and not (sc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)) and c:GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end

function s.rmfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function s.rescon(sg,e,tp,mg)
    return sg:FilterCount(Card.IsControler,nil,tp)==1
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,0) end
	local tg=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,HINTMSG_RTOHAND)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,2,0,0)
end
function s.opATK200(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	for tc in aux.Next(g) do
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end