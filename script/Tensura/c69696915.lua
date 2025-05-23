--Jura Tempest
--Script by Coroln
Duel.LoadScript ("porc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--send then special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x69A}
s.listed_names={id}
--add to hand
function s.thfilter(c)
	return c:IsSetCard(0x69A) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--send then special summon
function s.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x69A)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,code,e,tp)
end
function s.filter2(c,code,e,tp)
	return c:ListsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g>0 then
		e:SetLabelObject(g:GetFirst())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc1=e:GetLabelObject()
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
		local code=tc1:GetCode()
		local tc2=Duel.GetFirstMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,nil,code,e,tp)
		local summon=SUMMON_TYPE_SPECIAL
		if tc2:IsType(TYPE_FUSION) then
			summon=SUMMON_TYPE_FUSION
		elseif tc2:IsType(TYPE_SYNCHRO) then
			summon=SUMMON_TYPE_SYNCHRO
		elseif tc2:IsType(TYPE_XYZ) then
			summon=SUMMON_TYPE_XYZ
		elseif tc2:IsType(TYPE_LINK) then
			summon=SUMMON_TYPE_LINK
		elseif tc2:IsType(TYPE_TRICK) then
			summon=SUMMON_TYPE_TRICK
		end
		if tc2 and Duel.SpecialSummon(tc2,summon,tp,tp,true,false,POS_FACEUP)~=0 then
			if tc2:IsType(TYPE_XYZ) and tc1:IsLocation(LOCATION_GRAVE) then
				Duel.BreakEffect()
				Duel.Overlay(tc2,Group.FromCards(tc1))
			end
			tc2:CompleteProcedure()
		end
	end
end
