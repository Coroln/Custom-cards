--MSMM Delusional Dreams
--Scripted by Raivost
function c99950080.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950080,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950080.sptg1)
  e1:SetOperation(c99950080.spop1)
  c:RegisterEffect(e1)
  --(2) Place S/T Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950080,11))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99950080.stzcost)
  e2:SetTarget(c99950080.stztg)
  e2:SetOperation(c99950080.stzop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99950080.spfilter1(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81
  and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c99950080.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c99950080.spfilter1(chkc,e,tp) end
  if chk==0 then return Duel.IsExistingTarget(c99950080.spfilter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99950080.spfilter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99950080.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
    c:CancelToGrave()
    local code=tc:GetOriginalCode()
    --(1.1) Kaname Madoka
    if code==99950020 then
      --Gain LP
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,1))
      e1:SetCategory(CATEGORY_RECOVER)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_REMOVE)
      e1:SetCondition(c99950080.reccon)
      e1:SetOperation(c99950080.recop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.2) Akemi Homura
    if code==99950030 then
      --Unaffected
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,2))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
      e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCountLimit(1)
      e1:SetCondition(c99950080.unfcon)
      e1:SetTarget(c99950080.unftg)
      e1:SetOperation(c99950080.unfop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.3) Miki Sayaka
    if code==99950040 then
      --Increase ATK
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,3))
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetTargetRange(LOCATION_MZONE,0)
      e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x995))
      e1:SetValue(500)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.4) Tomoe Mami
    if code==99950050 then
      --Banish from Hand
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,4))
      e1:SetCategory(CATEGORY_REMOVE)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
      e1:SetCountLimit(1)
      e1:SetCondition(c99950080.bancon1)
      e1:SetTarget(c99950080.bantg1)
      e1:SetOperation(c99950080.banop1)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.5) Sakura Kyouko
    if code==99950060 then
      --Inflict Damage
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,5))
      e1:SetCategory(CATEGORY_DAMAGE)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EVENT_BATTLED)
      e1:SetRange(LOCATION_SZONE)
      e1:SetTarget(c99950080.damtg)
      e1:SetOperation(c99950080.damop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.6) Kaname Madokami
    if code==99950070 then
      --Special Summon
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,6))
      e1:SetType(EFFECT_TYPE_QUICK_O)
      e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
      e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCountLimit(1)
      e1:SetTarget(c99950080.sptg2)
      e1:SetOperation(c99950080.spop2)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.7) Akuma Homura
    if code==99950190 then
      --Banish 2
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950080,7))
      e1:SetType(EFFECT_TYPE_QUICK_O)
      e1:SetCategory(CATEGORY_REMOVE)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCountLimit(1)
      e1:SetTarget(c99950080.bantg2)
      e1:SetOperation(c99950080.banop2)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
  end
end
--(1.1) Kaname Madoka
function c99950080.recfilter(c,tp)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(0x80+LOCATION_SZONE) 
  and not c:IsType(TYPE_TOKEN) and c:GetPreviousControler()==tp
end
function c99950080.reccon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950080.recfilter,1,nil,1-tp)
end
function c99950080.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99950080)
  Duel.Recover(tp,500,REASON_EFFECT)
end
--(1.2) Akemi Homura
function c99950080.unfcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950080.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) 
end
function c99950080.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950080.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950080,8))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950080.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950080.unfop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(99950080,8))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c99950080.unfilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    e1:SetOwnerPlayer(tp)
    tc:RegisterEffect(e1)
  end
end
function c99950080.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(1.4) Tomoe Mami
function c99950080.bancon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950080.bantg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950080,9))
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c99950080.banop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
  if g:GetCount()==0 then return end
  local sg=g:RandomSelect(tp,1)
  Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--(1.5) Sakura Kyouko
function c99950080.check(c,tp)
  return c and c:IsControler(tp) and c:IsSetCard(0x995)
end
function c99950080.damfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950080.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetAttackTarget()~=nil
  and (c99950080.check(Duel.GetAttacker(),tp) or c99950080.check(Duel.GetAttackTarget(),tp)) end
  local val=Duel.GetMatchingGroupCount(c99950080.damfilter,tp,0,LOCATION_REMOVED,nil)
  Duel.SetTargetPlayer(1-tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950080,14))
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val*100)
end
function c99950080.damop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local val=Duel.GetMatchingGroupCount(c99950080.damfilter,tp,0,LOCATION_REMOVED,nil)
  Duel.Damage(p,val*100,REASON_EFFECT)
end
--(1.6) Kaname Madokami
function c99950080.spfilter2(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x995) and c:GetLevel()==5
  and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99950080.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99950080.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950080,10))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99950080.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99950080.spop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(1.7) Akuma Homura
function c99950080.banfilter2(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToRemove()
end
function c99950080.bantg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950080.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950080,9))
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c99950080.banop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950080.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    --(1.7.1) Place S/T Zone | Send to Grave
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabelObject(g:GetFirst())
    e1:SetCountLimit(1)
    e1:SetOperation(c99950080.pgop)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x995))
    e2:SetValue(aux.tgoval)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
  end
end
--(1.7.1) Place S/T Zone | Send to Grave
function c99950080.pgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.HintSelection(Group.FromCards(tc))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    select=Duel.SelectOption(tp,aux.Stringid(99950080,11),aux.Stringid(99950080,12))
  else
    select=Duel.SelectOption(tp,aux.Stringid(99950080,12))
    select=1
  end
  if select==0 then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+99950150,e,0,tp,0,0)
  else
    Duel.SendtoGrave(tc,REASON_EFFECT)
  end
end
--(2) Place in S/T Zone
function c99950080.stzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99950080.stzfilter(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and not c:IsForbidden()
end
function c99950080.stztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950080.stzfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99950080.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99950080.stzfilter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    --Continuous Spell
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+99950150,e,0,tp,0,0)
  end
end