--D.D. Eater of Souls
--Script by Coroln
Duel.LoadScript("customutility2.lua")
local s,id=GetID()
function s.initial_effect(c)
    Fusion.AddProcMixN(c,true,true,s.ffilter,3)
    c:EnableReviveLimit()
    --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
    --negate and destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
    --Inflict 200 Damage to the opponent
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.damcon1)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(s.damcon2)
	c:RegisterEffect(e4)
end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsLevel(1) and c:IsDD(fc,sumtype,tp)
end
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsDD() or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,400)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
            Duel.Damage(1-tp,400,REASON_EFFECT)
            Duel.Damage(tp,400,REASON_EFFECT)
		end
	end
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and eg:GetFirst():IsDD() and eg:GetFirst():GetControler()==tp and eg:GetFirst():GetCode()~=id and Duel.GetLP(1-tp)>0
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r&REASON_BATTLE==0 and re and re:IsMonsterEffect()
		and re:GetHandler():IsDD() and re:GetHandler():GetCode()~=id and Duel.GetLP(1-tp)>0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end