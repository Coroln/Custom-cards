--designed and script by Rising Phoenix
function c100001221.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100001221.splimit)
	c:RegisterEffect(e1)
		--draw more
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,100001221)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetDescription(aux.Stringid(100001221,0))
	e2:SetCondition(c100001221.condition)
	e2:SetTarget(c100001221.target)
	e2:SetOperation(c100001221.operation)
	e2:SetCost(c100001221.spcost)
	c:RegisterEffect(e2)
		--draw 1
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c100001221.condition2)
	e4:SetTarget(c100001221.target2)
	e4:SetOperation(c100001221.operation2)
	c:RegisterEffect(e4)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
		--Negate
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,100001222)
	e12:SetCost(c100001221.cost2)
	e12:SetCondition(c100001221.discon)
	e12:SetTarget(c100001221.distg)
	e12:SetOperation(c100001221.disop)
	c:RegisterEffect(e12)
		--disable spsummon
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EVENT_SUMMON)
	e13:SetCountLimit(1,100001222)
	e13:SetCondition(c100001221.dscon)
	e13:SetCost(c100001221.cost2)
	e13:SetTarget(c100001221.dstg)
	e13:SetOperation(c100001221.dsop)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e14)
	local e15=e13:Clone()
	e15:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e15)
end
function c100001221.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c100001221.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100001221.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c100001221.cfilter2(c)
	return  c:IsAttribute(ATTRIBUTE_LIGHT) and  c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c100001221.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001221.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100001221.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100001221.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(100001221) and Duel.IsChainNegatable(ev)
end
function c100001221.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100001221.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c100001221.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c100001221.envfilter(c)
	return c:IsFaceup() and c:IsCode(56433456)
end
function c100001221.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(42444868)
end
function c100001221.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (Duel.IsExistingMatchingCard(c100001221.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) or Duel.IsEnvironment(56433456,tp))
end
function c100001221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c100001221.gfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		local ct=c100001221.count_unique_code(g)
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c100001221.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c100001221.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) or Duel.IsEnvironment(56433456,tp)) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c100001221.gfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ct=c100001221.count_unique_code(g)
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c100001221.count_unique_code(g)
	local check={}
	local count=0
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				count=count+1
			end
		end
		tc=g:GetNext()
	end
	return count
end
function c100001221.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c100001221.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100001221.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100001221.gfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10a) and not c:IsCode(100001221)
end