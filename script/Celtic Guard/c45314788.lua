--サイバー・ドラゴン・インフィニティ
function c45314788.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,c45314788.mfilter,5,3,c45314788.ovfilter,aux.Stringid(45314788,0),3,c45314788.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c45314788.atkval)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c45314788.target)
	e2:SetOperation(c45314788.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c45314788.discon)
	e3:SetCost(c45314788.discost)
	e3:SetTarget(c45314788.distg)
	e3:SetOperation(c45314788.disop)
	c:RegisterEffect(e3)
end
c45314788.listed_names={45314787}
function c45314788.mfilter(c,xyz,sumtype,tp)
	return c:IsRace(RACE_WARRIOR,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_EARTH,xyz,sumtype,tp)
end
function c45314788.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,45314787)
end
function c45314788.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,45314788)==0 end
	Duel.RegisterFlagEffect(tp,45314788,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c45314788.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c45314788.filter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c45314788.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45314788.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c45314788.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c45314788.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c45314788.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c45314788.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c45314788.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c45314788.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c45314788.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
