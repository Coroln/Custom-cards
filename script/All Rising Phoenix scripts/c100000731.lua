--Created and scripted by rising phoenix
function c100000731.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(100000731,0))
	e1:SetCountLimit(1,100000731+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100000731.target)
	e1:SetOperation(c100000731.activate)
	e1:SetCondition(c100000731.descon2)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetDescription(aux.Stringid(100000731,1))
	e2:SetCountLimit(1,100000731+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c100000731.target2)
	e2:SetOperation(c100000731.activate2)
	e2:SetCondition(c100000731.descon2)
	c:RegisterEffect(e2)
			--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
		e3:SetDescription(aux.Stringid(100000731,2))
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,100000731+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c100000731.target3)
	e3:SetOperation(c100000731.activate3)
	e3:SetCondition(c100000731.descon2)
	c:RegisterEffect(e3)
end
function c100000731.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=5000
end
function c100000731.filter(c,e,tp)
	return (c:IsCode(100000814) or c:IsCode(100000816)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000731.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x758) and c:IsType(TYPE_MONSTER)
end
function c100000731.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000731.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c100000731.filter2,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c100000731.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c100000731.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c100000731.activate(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end
function c100000731.filter3(c,e,tp)
	return (c:IsCode(100000820) or c:IsCode(100000821)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000731.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000731.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c100000731.filter2,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c100000731.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c100000731.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c100000731.activate2(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end
function c100000731.filter4(c,e,tp)
	return c:IsCode(100000811) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000731.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000731.filter4,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c100000731.filter2,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c100000731.filter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c100000731.filter2,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c100000731.activate3(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end

