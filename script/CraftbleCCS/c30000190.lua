local s,id=GetID()
function s.initial_effect(c)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==1-tp end)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(s.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.value)
	c:RegisterEffect(e4)
end
function s.dfilter(c)
	return c:IsSetCard(SET_DARK_SCORPION) and c:IsMonster()
end
function s.value(e,c)
	local g=Duel.GetMatchingGroup(s.dfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct*200
end
function filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsMonster() and (c:IsSetCard(SET_DARK_SCORPION) or c:IsCode(76922029))
end
function s.aclimit(e,c)
	return c:GetColumnGroup():IsExists(filter,1,c,e:GetHandlerPlayer())
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.IsPlayerCanDiscardDeck(1-tp,2)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	else
		e:SetCategory(CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,2)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		--Discard 1 random card from your opponent's hand
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
		if #g==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD|REASON_EFFECT)
	else
		--Send the top 2 cards of your opponent's Deck to the GY
		Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and (a:IsSetCard(SET_DARK_SCORPION) or a:IsCode(76922029)) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and (d:IsSetCard(SET_DARK_SCORPION) or d:IsCode(76922029)) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE)
	tc:RegisterEffect(e2)
end

