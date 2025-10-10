--PM Pokéball
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Attach 1 monster from your Deck to this card as material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id)
	e0:SetTarget(s.attachtg)
	e0:SetOperation(s.attachop)
	c:RegisterEffect(e0)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eftg2)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--destroy itself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) local tc=e:GetHandler():GetFirstCardTarget() return tc and eg:IsContains(tc) end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.Destroy(e:GetHandler(),REASON_EFFECT) end)
	c:RegisterEffect(e2)
	--Shuffle when this card leaves the field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(s.leaveop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_series={0x7CC}
--Attach 1 monster from your Deck to this card as material
function s.attachfilter(c,xyzc,tp)
	return c:IsMonster() and c:IsSetCard(0x7CC) and not c:IsType(TYPE_RITUAL)
end
function s.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attachfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler(),tp) end
end
function s.attachop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,s.attachfilter,tp,LOCATION_DECK,0,1,1,nil,c,tp):GetFirst()
	if tc then
		Duel.HintSelection(tc)
		Duel.Overlay(c,tc)
	end
end
--Activate 1 of these effects
function s.filter1(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter2(c)
	return c:IsFaceup()
end
function s.select(e,tp,b1,b2)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+2
	end
	e:SetLabel(op)
end
function s.eftg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetOverlayCount()>0
	local b2=c:GetCardTargetCount()>0 and c:GetCardTarget():GetFirst():IsLocation(LOCATION_MZONE)
	if chkc then return false end
	if chk==0 then return b1 or b2 end
	s.select(e,tp,b1,b2)
	local op=e:GetLabel()
	if op==1 then
		-- Option 1: Special Summon from underneath
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=c:GetOverlayGroup():Select(tp,1,1,nil)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	elseif op==2 then
		--re-attach
		local tc=c:GetCardTarget():GetFirst()
		if tc then
			Duel.SetTargetCard(tc)
		end
	end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then return
	elseif e:GetLabel()==1 then
		--Special Summon
		local tc=Duel.GetTargetCards(e):GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				e:GetHandler():SetCardTarget(tc)  -- link spell with monster
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
			end
		end
	else
		--re-attach
		local tc=c:GetCardTarget():GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
	end
end
--Shuffle when this card leaves the field
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- First: check the Special Summoned monster
	local tc=c:GetCardTarget():GetFirst()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	-- Second: check for monster underneath
	local og=c:GetOverlayGroup()
	if #og>0 then
		Duel.SendtoDeck(og,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end