--Overlord Death Determination War
--Scripted by Raivost
function c99920090.initial_effect(c)
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920090,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99920090)
  e1:SetTarget(c99920090.destg)
  e1:SetOperation(c99920090.desop)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920090,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,99920091)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99920090.thtg)
  e2:SetOperation(c99920090.thop)
  c:RegisterEffect(e2)
end
--(1) Destroy
function c99920090.desfilter1(c,tp)
  local lg=c:GetColumnGroup()
  return c:IsFaceup() and c:IsSetCard(0x992) and Duel.IsExistingMatchingCard(c99920090.desfilter2,tp,0,LOCATION_ONFIELD,1,nil,lg)
end
function c99920090.desfilter2(c,g)
  return g:IsContains(c)
end
function c99920090.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99920090.desfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99920090.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c99920090.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local lg=tc:GetColumnGroup()
  local g=Duel.GetMatchingGroup(c99920090.desfilter2,tp,0,LOCATION_ONFIELD,nil,lg)
  if g:GetCount()==0 then return end
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and g:GetCount()>0
  and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(99920090,2)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99920090,3))
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
  end
end
--(2) Search
function c99920090.thfilter(c)
  return c:IsSetCard(0xA92) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99920090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99920090.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99920090.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99920090.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end