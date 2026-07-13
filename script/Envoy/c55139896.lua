--Chaos Angel - Envoy of Change
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	Xyz.AddProcedure(c,nil,4,2,nil,nil,nil,nil,false,s.xyzcheck)
	--change atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end
--Xyz Summon
function s.xyzfilter(c,xyz,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,xyz,SUMMON_TYPE_XYZ,tp)
end
function s.xyzfilter1(c,xyz,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,xyz,SUMMON_TYPE_XYZ,tp)
end
function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(EFFECT_EQUIP_SPELL_XYZ_MAT) end,nil)
	return mg:IsExists(s.xyzfilter,1,nil,xyz,tp) and mg:IsExists(s.xyzfilter1,1,nil,xyz,tp)
end
--change atk
function s.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)<=1
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)<=1
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local ty=0
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then ty=ty|ATTRIBUTE_LIGHT end
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,1,nil) then ty=ty|ATTRIBUTE_DARK end
	if chk==0 then return ty>0 and g:IsExists(Card.IsAttribute,1,nil,ty) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=c:GetOverlayGroup()
	local ty=0
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then ty=ty|ATTRIBUTE_LIGHT end
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttackAbove,0),tp,0,LOCATION_MZONE,1,nil) then ty=ty|ATTRIBUTE_DARK end
	if ty==0 then return end
	local sg=aux.SelectUnselectGroup(g:Filter(Card.IsAttribute,nil,ty),e,tp,1,1,s.rescon,1,tp,HINTMSG_REMOVEXYZ)
	local lb=0
	for tc in aux.Next(sg) do
		lb=lb|tc:Attribute()
	end
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	Duel.BreakEffect()
	if lb&ATTRIBUTE_LIGHT~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESETS_STANDARD_PHASE_END,2)
			e1:SetValue(800)
			tc:RegisterEffect(e1)
		end
	end
	if lb&ATTRIBUTE_DARK~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESETS_STANDARD_PHASE_END,2)
			e1:SetValue(-800)
			tc:RegisterEffect(e1)
		end
	end
end
--material
function s.mtfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.mtfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.Overlay(c,g)
	end
end
