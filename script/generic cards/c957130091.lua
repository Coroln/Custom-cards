--Gravleshdragon
--RikaCpp

local s,id=GetID()

function s.initial_effect(c)
	--Fusion Summon
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(s.matcheck),aux.FilterBoolFunctionEx(s.matfilter2),aux.FilterBoolFunctionEx(s.matfilter2))

	--If Fusion Summoned: destroy 1 card your opponent controls
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	--Unaffected by opponent's Trap effects during the Battle Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(
		function (e,te)
			return te:IsTrapEffect() and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and Duel.IsBattlePhase()
		end)
	c:RegisterEffect(e2)

	--Once per turn:
	--Target 1 monster on the field; it gains 500 ATK,
	--also it cannot attack until the end of the next turn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	--If this attacking card destroys an opponent's monster by battle:
	--it can make a second attack in a row, but it cannot attack directly
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop2)
	c:RegisterEffect(e4)
end
--Fusion.AddProcMix
function s.matcheck(c, fc, sumtype, tp)
    return c:IsAttribute(ATTRIBUTE_DARK, fc, sumtype, tp)
        and c:IsSummonLocation(LOCATION_GRAVE)
end

function s.matfilter2()
    return true
end
--e1
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

--e3
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id)==0
	end

	--Mark the once-per-turn effect as used
	c:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsFaceup() or not tc:IsRelateToEffect(e) then
		return
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	tc:RegisterEffect(e1)

	--Cannot attack until the end of the next turn
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,2)
	tc:RegisterEffect(e2)
end

--e4
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	return c:GetFlagEffect(id)==0
		and Duel.GetAttacker()==c
		and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
		and c:CanChainAttack()
		and Duel.IsExistingMatchingCard(s.attacktarget,1-tp,LOCATION_MZONE,0,1,nil,c)
end

function s.attacktarget(tc,c)
	return tc:IsFaceup()
		and not tc:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET)
		and not tc:IsHasEffect(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		and not tc:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)
end

function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if not c:IsFaceup() or not c:IsRelateToBattle() then
		return
	end

	c:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)

	Duel.ChainAttack()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	c:RegisterEffect(e1)
end
