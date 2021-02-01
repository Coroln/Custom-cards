--DAL Spirit - Sister
--Scripted by Raivost
function c99970510.initial_effect(c)
  --(1) Reveal
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970510,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCondition(c99970510.revcon)
  e1:SetTarget(c99970510.revtg)
  e1:SetOperation(c99970510.revop)
  c:RegisterEffect(e1)
  --(2) Gain LP
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970510,3))
  e2:SetCategory(CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,99970510)
  e2:SetCondition(c99970510.reccon)
  e2:SetTarget(c99970510.rectg)
  e2:SetOperation(c99970510.recop)
  c:RegisterEffect(e2)
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970510,4))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(c99970510.spcon)
  e3:SetTarget(c99970510.sptg)
  e3:SetOperation(c99970510.spop)
  c:RegisterEffect(e3)
end
function c99970510.revcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970510.revfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER)
end
function c99970510.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970510.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 
  and Duel.IsExistingMatchingCard(c99970510.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970510.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970510.revop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
  Duel.ConfirmDecktop(1-tp,5)
  local ct=Duel.GetDecktopGroup(1-tp,5):Filter(c99970510.revfilter,nil,e,tp)
  Duel.ShuffleDeck(1-tp)
  local g=Duel.GetMatchingGroup(c99970510.atkfilter,tp,LOCATION_MZONE,0,nil)
  if ct:GetCount()>0 and g:GetCount()>0 then
    for sc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetValue(ct:GetCount()*100)
    sc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    sc:RegisterEffect(e2)
    end
    if Duel.IsExistingMatchingCard(c99970510.thfilter,tp,LOCATION_DECK,0,1,nil)
    and Duel.SelectYesNo(tp,aux.Stringid(99970510,1)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970510,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,c99970510.thfilter,tp,LOCATION_DECK,0,1,1,nil)
      if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
      end
    end
  end
end
--(2) Gain LP
function c99970510.reccon(e)
  local tp=e:GetHandlerPlayer()
  return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>0
end
function c99970510.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local tp=e:GetHandlerPlayer()
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
end
function c99970510.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end
--(3) Special Summon
function c99970510.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970510.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970510.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970510.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970510.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end