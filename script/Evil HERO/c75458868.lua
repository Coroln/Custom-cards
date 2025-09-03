--Evil HERO Sinister Reflect
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon this card (from your hand) by discarding 1 Fiend monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--lose ATK
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(id,1))
	e1a:SetCategory(CATEGORY_ATKCHANGE)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1a:SetCondition(s.spcon2)
	e1a:SetOperation(s.spop2)
	c:RegisterEffect(e1a)
	--"Dark Fusion" Quick-Play
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(function(e,c) return c:IsCode(94820406) and not c:IsType(TYPE_QUICKPLAY) and c:IsHasEffect(EFFECT_BECOME_QUICK) and Duel.GetTurnPlayer()~=c:GetControler() end)
	c:RegisterEffect(e2)
	local e2a=Effect.CreateEffect(c)
	e2a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_BECOME_QUICK)
	e2a:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetTarget(function(e,c) return c:IsCode(94820406) and not c:IsType(TYPE_QUICKPLAY) and Duel.GetTurnPlayer()~=c:GetControler() end)
	c:RegisterEffect(e2a)
end
s.listed_names={CARD_DARK_FUSION}
--Special Summon this card (from your hand) by discarding 1 Fiend monster
function s.spcostfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsMonster() and c:IsDiscardable()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND,0,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.spcostfilter,tp,LOCATION_HAND,0,c)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_DISCARD,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_DISCARD|REASON_COST)
	g:DeleteGroup()
end
--lose ATK
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESETS_STANDARD_DISABLE_PHASE_END)
		c:RegisterEffect(e1)
	end
end