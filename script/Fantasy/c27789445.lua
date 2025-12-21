--Fantasy Great Paladin
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0xFF)
    --Special summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
    e2:SetCondition(s.condition)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
    --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.HasCounter,0xFF))
	e3:SetValue(1)
	c:RegisterEffect(e3)
    --counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE|PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.addct)
	e4:SetOperation(s.addc)
	c:RegisterEffect(e4)
end
s.counter_place_list={0xFF}
--Special summon procedure
function s.spfilter(c,tp)
	return c:IsMonster() and c:IsCanRemoveCounter(tp,0xFF,1,REASON_COST)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ct=0
	for i in aux.Next(g) do
		ct=ct+i:GetCounter(0xFF)
	end
	return ct>=8 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if #g==1 then
		g:GetFirst():RemoveCounter(tp,0xFF,8,REASON_COST)
	else
		local ct=0
		while ct<8 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
			tc:RemoveCounter(tp,0xFF,1,REASON_COST)
			ct=ct+1
		end
	end
end
--copy effect
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.cpfilter(c)
	return c:ListsCounter(0xFF) and c:IsSpell() and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if not te then return end
	local tg=te:GetTarget()
	local op=te:GetOperation()
	if tg then tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
	Duel.BreakEffect()
	tc:CreateEffectRelation(te)
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for etc in aux.Next(g) do
		etc:CreateEffectRelation(te)
	end
	if op then op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
	tc:ReleaseEffectRelation(te)
	for etc in aux.Next(g) do
		etc:ReleaseEffectRelation(te)
	end
end
--counter
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xFF)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xFF,1)
	end
end