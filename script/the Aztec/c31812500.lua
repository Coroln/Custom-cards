--Stone Sphinx of the Aztecs
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Double damage
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e0:SetCondition(s.dcon)
	e0:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e0)
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
    --Force Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44035031,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atcon)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
s.listed_series={0x39F}
s.listed_names={31812496}
--Double damage
function s.dcon(e)
	return Duel.GetAttackTarget()==e:GetHandler()
end
--special summon
function s.spfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x39F) or c:IsCode(31812496))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
--Force Attack
function s.atcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
end
function s.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_CANNOT_ATTACK) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) 
		and (c:IsAttackPos() or c:IsHasEffect(EFFECT_DEFENSE_ATTACK))
end
function s.attg(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(id)==0 end
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,0)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.atop(e,tp,eg,ev,ep,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetTargetCards(e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:GetAttackAnnouncedCount()~=0 then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
