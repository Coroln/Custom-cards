--Disassembling Card
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon, then send to GY
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
--Special Summon, then send to GY
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_MONSTER)
end
function s.setfilter(c)
	return c:IsTrap() and c:IsSSetable()
end
function s.mgfilter(c,e,tp,sync)
	return c:IsLocation(LOCATION_GRAVE)
		and (c:GetReason()&0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mgfilter2(c,e,tp,fusc)
	return c:IsLocation(LOCATION_GRAVE)
		and (c:GetReason()&(REASON_FUSION|REASON_MATERIAL))~=(REASON_FUSION|REASON_MATERIAL) or c:GetReasonCard()~=fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mgfilter3(c,e,tp,linc,mg)
	return c:IsLocation(LOCATION_GRAVE)
		and (c:GetReason()&0x10000008)==0x10000008 and c:GetReasonCard()==linc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local typ=tc:GetType()
	local owner=tc:GetOwner()

	if tc:IsType(TYPE_XYZ) then
		local mats=tc:GetOverlayGroup()
		if #mats>0 then
			local ct=Duel.SpecialSummon(mats,0,owner,owner,false,false,POS_FACEUP)
		end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	
	elseif tc:IsType(TYPE_SYNCHRO) then
		local mg=tc:GetMaterial()
		local ct=#mg
		local sumtype=tc:GetSummonType()
		if sumtype==SUMMON_TYPE_SYNCHRO and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter),nil,e,tp,tc)==ct then
			Duel.SpecialSummon(mg,0,owner,owner,false,false,POS_FACEUP)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end

	elseif tc:IsType(TYPE_FUSION) then
		local mg=tc:GetMaterial()
		local ct=#mg
		local sumtype=tc:GetSummonType()
		if sumtype==SUMMON_TYPE_FUSION and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter2),nil,e,tp,tc)==ct then
			Duel.SpecialSummon(mg,0,owner,owner,false,false,POS_FACEUP)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end

	elseif tc:IsType(TYPE_LINK) then
		local mg=tc:GetMaterial()
		local ct=#mg
		local sumtype=tc:GetSummonType()
		if sumtype==SUMMON_TYPE_LINK and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter3),nil,e,tp,tc)==ct then
			Duel.SpecialSummon(mg,0,owner,owner,false,false,POS_FACEUP)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	elseif tc:IsType(TYPE_TRICK) then
		Duel.Sendto(tc,LOCATION_EXTRA,REASON_RULE,POS_FACEDOWN)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SSet(tp,g)
			end
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
