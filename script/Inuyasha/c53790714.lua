--Inu Wolf demon Ayame
function c53790714.initial_effect(c)
	--xyz summon
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x5EB),2,2)
    c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53790714,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c53790714.spcost)
	e1:SetTarget(c53790714.sptg)
	e1:SetOperation(c53790714.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53790714,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c53790714.negcon)
	e2:SetCost(c53790714.negcost)
	e2:SetTarget(c53790714.negtg)
	e2:SetOperation(c53790714.negop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53790714,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c53790714.thtg)
	e3:SetOperation(c53790714.thop)
	c:RegisterEffect(e3)
	--Gain ATK/DEF
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(53790714,5))
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DESTROYED)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c53790714.atkcon)
    e4:SetTarget(c53790714.atktg)
    e4:SetOperation(c53790714.atkop)
    c:RegisterEffect(e4)
end
--special summon
function c53790714.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c53790714.spfilter(c,e,tp)
	return c:IsSetCard(0x5EB) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53790714.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53790714.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c53790714.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53790714.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c53790714.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c53790714.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function c53790714.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53790714.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53790714.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c53790714.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		local cat=e:GetCategory()
		if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
			e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		else
			e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
		end
	end
end
function c53790714.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK) then
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(53790714,3)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(53790714,4)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			Duel.ConfirmCards(1-tp,rc)
		end
	end
end
function c53790714.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c53790714.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c53790714.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53790714.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c53790714.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c53790714.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--(4) Gain ATK/DEF
function c53790714.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank()) 
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink())
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x5EB) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c53790714.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790714.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end