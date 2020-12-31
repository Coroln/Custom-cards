--SW - Jedi Ahsoka
function c88000008.initial_effect(c)
 --Xyz Summon
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x7bc),4,2)
  c:EnableReviveLimit()
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(88000008,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c88000008.descon)
  e1:SetTarget(c88000008.destg)
  e1:SetOperation(c88000008.desop)
  c:RegisterEffect(e1)
  --(2) Send to GY
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(88000008,1))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c88000008.tgcost)
  e2:SetTarget(c88000008.tgtg)
  e2:SetOperation(c88000008.tgop)
  c:RegisterEffect(e2)
  --to DECK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88000008,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c88000008.thtg)
	e3:SetOperation(c88000008.thop)
	c:RegisterEffect(e3)
 end
 --(1) Destroy
function c88000008.descon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
end
function c88000008.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c88000008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c88000008.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c88000008.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88000008.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
--(2) Send to GY
function c88000008.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88000008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0 end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c88000008.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_HAND,1,1,nil)
  if g:GetCount()~=0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
    Duel.ShuffleHand(1-tp)
    local tc=g:GetFirst()
    if not tc:IsType(TYPE_MONSTER) then
      Duel.Draw(tp,1,REASON_EFFECT)
    end
  end
end
--to DECK
function c88000008.thfilter(c)
	return c:IsSetCard(0x7bc) and c:IsAbleToDeck()
end
function c88000008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88000008.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88000008.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATODECK)
	local g=Duel.SelectTarget(tp,c88000008.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c88000008.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
