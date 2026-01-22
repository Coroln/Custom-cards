--Preparation Art Baking
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Baking
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	c:RegisterEffect(e1)
	--Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
--Baking
function s.fusionfilter(c,tp)
	if not c:IsType(TYPE_FUSION) or not c.listed_names or not table.contains(c.listed_names,id) then return false end
	if not c.listed_cooking_materials then return false end
	for _,code in ipairs(c.listed_cooking_materials) do
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,code) then
			return false
		end
	end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.fusionfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc)
	local mats=Group.CreateGroup()
	for _,code in ipairs(tc.listed_cooking_materials) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,code)
		mats:Merge(sg)
	end
	Duel.SetTargetCard(mats)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,mats,#mats,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local mats=Duel.GetTargetCards(e)
	if not tc or not tc:IsType(TYPE_FUSION) then return end
	if #mats<#tc.listed_cooking_materials then return end
	tc:SetMaterial(mats)
	if Duel.Release(mats,REASON_COST+REASON_MATERIAL+REASON_FUSION)~=0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function table.contains(t,val)
	for _,v in ipairs(t) do
		if v==val then return true end
	end
	return false
end
--shuffle
function s.tdfilter(c)
	return c:IsMonster() and c:IsType(TYPE_EFFECT) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if #g==3 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==3 then
			Duel.Draw(tp,1,REASON_EFFECT)
			local c=e:GetHandler()
			--Cannot Special Summon from the Extra Deck, except Fusion Monsters
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--Clock Lizard check
			aux.addTempLizardCheck(c,tp,s.lizfilter)
		end
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function s.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_FUSION)
end