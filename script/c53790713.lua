--Inu Inuyasha Demon Mode
function c53790713.initial_effect(c)
  --Xyz Summon
  Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x5EB),4,2)
  c:EnableReviveLimit()
  --(1) To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(53790713,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c53790713.thcon)
  e1:SetTarget(c53790713.thtg)
  e1:SetOperation(c53790713.thop)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(53790713,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c53790713.descost)
  e2:SetTarget(c53790713.destg)
  e2:SetOperation(c53790713.desop)
  c:RegisterEffect(e2)
  --(4) Second attack
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(53790713,4))
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetCondition(c53790713.sacon)
  e3:SetTarget(c53790713.satg)
  e3:SetOperation(c53790713.saop)
  c:RegisterEffect(e3)
  --(4) Gain ATK/DEF
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(53790713,5))
  e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c53790713.atkcon)
  e4:SetTarget(c53790713.atktg)
  e4:SetOperation(c53790713.atkop)
  c:RegisterEffect(e4)
  --(5) change name
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_CHANGE_CODE)
  e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  e5:SetValue(53790700)
  c:RegisterEffect(e5)
end
--(1) To hand
function c53790713.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c53790713.thfilter(c)
  return c:IsSetCard(0x5EB) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c53790713.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c53790713.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53790713.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c53790713.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 then
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  end
end
--(2) Destroy
function c53790713.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c53790713.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c53790713.spfilter(c,e,tp)
  return c:IsSetCard(0x5EB) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53790713.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c53790713.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(53790713,2)) then
  	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(53790713,3))
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53790713,3))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c53790713.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
--(3) Second attack
function c53790713.sacon(e,tp,eg,ep,ev,re,r,rp)
  return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable()
end
function c53790713.satg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790713.saop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChainAttack()
end
--(4) Gain ATK/DEF
function c53790713.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c53790713.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790713.atkop(e,tp,eg,ep,ev,re,r,rp)
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