--HN Gamindustri
--Scripted by Raivost
function c99980440.initial_effect(c)
  --(1) Additional Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(c99980440.ansop)
  c:RegisterEffect(e1)
  --(2) Untargetable
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetRange(LOCATION_FZONE)
  e2:SetTargetRange(LOCATION_SZONE,0)
  e2:SetTarget(c99980440.unttg)
  e2:SetValue(aux.tgoval)
  c:RegisterEffect(e2)
  --(3) Search
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980440,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1,99980440)
  e3:SetTarget(c99980440.thtg)
  e3:SetOperation(c99980440.thop)
  c:RegisterEffect(e3)
end
--(1) 
function c99980440.ansop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.GetFlagEffect(tp,99980440)==0 and Duel.IsPlayerCanSummon(tp) and Duel.SelectYesNo(tp,aux.Stringid(99980440,0)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980440,1))
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x998))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,99980440,RESET_PHASE+PHASE_END,0,1)
  end
end
--(2) Untargetable
function c99980440.unttg(e,c)
  return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and aux.IsCodeListed(c,99980030) 
end 
--(3) Search
function c99980440.thfilter(c)
  return c:IsSetCard(0x1998) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99980440.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980440.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980440.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980440.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end