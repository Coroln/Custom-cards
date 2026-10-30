local s,id=GetID()
function s.initial_effect(c)
	
    --Half the ATK of 1 of your opponent's monsters
    local e1a=Effect.CreateEffect(c)
    e1a:SetDescription(aux.Stringid(id,1))
    e1a:SetCategory(CATEGORY_ATKCHANGE)
    e1a:SetProperty(EFFECT_FLAG_DELAY)
    e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1a:SetCode(EVENT_TO_GRAVE)
    e1a:SetCountLimit(1,id)
    e1a:SetCondition(s.atkcon)
    e1a:SetTarget(s.atktg)
    e1a:SetOperation(s.atkop)
    c:RegisterEffect(e1a)
    local e1b=e1a:Clone()
    e1b:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e1b)

	--actlimit
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2a:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetTargetRange(0,1)
	e2a:SetValue(1)
	e2a:SetCondition(s.con)
	c:RegisterEffect(e2a)
	--disable
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2b:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetCondition(s.con)
	e2b:SetOperation(s.disop)
	c:RegisterEffect(e2b)
	local e2c=e2b:Clone()
	e2c:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	c:RegisterEffect(e2c)

	--atk up
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(EFFECT_UPDATE_ATTACK)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(Cost.SelfBanish)
    e3:SetTarget(s.target)
    e3:SetOperation(s.operation)
    c:RegisterEffect(e3)
end
--e1
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and (r&REASON_DISCARD)~=0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		e1:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e1)
	end
end

--e2

function s.con(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c and c:GetBattleTarget()) or Duel.GetAttackTarget()==c
end
function s.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if not tc then return end
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
--e5
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
        if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
