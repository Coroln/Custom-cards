--化合電界
--Catalyst Field
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_NORMAL),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_NORMAL),1,2)
    --1 Level 5 or higher Gemini monster can be Normal Summoned without tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ntcon)
	e2:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e2)
	--Can Normal Summon 1 additional Gemini monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND|LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	c:RegisterEffect(e3)

    --Negate a card or effect that would destroy cards on the field
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.discon)
    e4:SetCost(s.discost)
    e4:SetTarget(s.distg)
    e4:SetOperation(s.disop)
    c:RegisterEffect(e4)
end
s.listed_card_types={TYPE_NORMAL}
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)
end
function s.rmfilter(c)
	return c:IsGeminiStatus() and c:IsAbleToRemove()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not rc then return end
	local reset=RESET_PHASE|PHASE_END|RESET_OPPO_TURN
	if aux.RemoveUntil(rc,nil,REASON_EFFECT,PHASE_END,id,e,tp,aux.DefaultFieldReturnOp,s.retcon,reset) then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.retcon(ag,e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end


--e4

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-#tg>0
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil)
	Duel.Release(sg,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

