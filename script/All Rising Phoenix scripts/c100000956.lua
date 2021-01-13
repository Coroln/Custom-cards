 --Created and coded by Rising Phoenix
 local s,id=GetID()
function s.initial_effect(c)
c:SetUniqueOnField(1,0,id)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x75C),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x75C),1,99)
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1c0)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(s.targethh)
	e1:SetOperation(s.activatehh)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)		
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetCondition(s.conua)
	e11:SetValue(s.efilterua)
	c:RegisterEffect(e11)
	--half damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(s.dxcon)
	e4:SetOperation(s.dxop)
	c:RegisterEffect(e4)
end
function s.efilterua(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.dxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function s.dxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function s.filterua(c)
	return c:IsFaceup() and c:IsCode(100000955)
end
function s.conua(e)
	return Duel.IsExistingMatchingCard(s.filterua,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x75C)
end
function s.rfilter(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000950)
end
function s.rfilter2(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000949)
end
function s.rfilter3(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000948)
end
function s.rfilter4(c,att)
	return c:IsAbleToRemoveAsCost() and c:IsCode(100000951)
end
function c100000956.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(s.rfilter2,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(s.rfilter3,tp,LOCATION_GRAVE,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(s.rfilter4,tp,LOCATION_GRAVE,0,1,nil,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.rfilter2,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,s.rfilter3,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,s.rfilter4,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	g:Merge(g1)
	g:Merge(g2)
	g:Merge(g3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.targethh(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.activatehh(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end