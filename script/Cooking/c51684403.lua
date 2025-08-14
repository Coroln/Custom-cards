--Preparation Art Boiling
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--cooking
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	c:RegisterEffect(e1)
	--GY effect: ATK boost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
--cooking
function s.fusionfilter(c,tp)
	if not c:IsType(TYPE_FUSION) or not c.listed_names or not table.contains(c.listed_names,id) then return false end
	if not c.listed_cooking_materials then return false end
	-- Check if all required materials are on the field
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
	-- Select tribute materials (exactly the listed_cooking_materials)
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
-- Helper: table.contains
function table.contains(t,val)
	for _,v in ipairs(t) do
		if v==val then return true end
	end
	return false
end
-- ATK boost from GY
function s.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local effCount=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EFFECT)
		local atk=effCount*200
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		tc:RegisterEffect(e1)
	end
end