--MSMM Timeless Soul Cage
--Scripted by Raivost
function c99950160.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950160,0))
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950160.actg)
  e1:SetOperation(c99950160.acop)
  c:RegisterEffect(e1)
end
--(1) Activate
function c99950160.acfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c99950160.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950160.acfilter,tp,LOCATION_SZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99950160.acfilter,tp,LOCATION_SZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99950160.acop(e,tp,eg,ep,ev,re,r,rp)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
    c:CancelToGrave()
    local code=tc:GetOriginalCode()
    --(1.1) Kaname Madoka
    if code==99950020 then
      --Gain LP 1
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,1))
      e1:SetCategory(CATEGORY_RECOVER)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_REMOVE)
      e1:SetCondition(c99950160.reccon1)
      e1:SetOperation(c99950160.recop1)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.2) Akemi Homura
    if code==99950030 then
      --Unaffected
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,2))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
      e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCountLimit(1)
      e1:SetCondition(c99950160.unfcon)
      e1:SetTarget(c99950160.unftg)
      e1:SetOperation(c99950160.unfop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.3) Miki Sayaka
    if code==99950040 then
      --Gain ATK
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,3))
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
      --Banish 1
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,4))
      e1:SetCategory(CATEGORY_REMOVE)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
      e1:SetCountLimit(1)
      e1:SetCondition(c99950160.bancon1)
      e1:SetTarget(c99950160.bantg1)
      e1:SetOperation(c99950160.banop1)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.5) Sakura Kyouko
    if code==99950060 then
      --Inflict Damage
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,5))
      e1:SetCategory(CATEGORY_DAMAGE)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetCode(EVENT_BATTLED)
      e1:SetRange(LOCATION_SZONE)
      e1:SetTarget(c99950160.damtg)
      e1:SetOperation(c99950160.damop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.6) Kaname Madokami
    if code==99950070 then
      --Special Summon
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,6))
      e1:SetType(EFFECT_TYPE_QUICK_O)
      e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
      e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCountLimit(1)
      e1:SetTarget(c99950160.sptg)
      e1:SetOperation(c99950160.spop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.7) Akuma Homura
    if code==99950190 then
      --Banish 2
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(99950160,7))
      e1:SetType(EFFECT_TYPE_QUICK_O)
      e1:SetCategory(CATEGORY_REMOVE)
      e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCountLimit(1)
      e1:SetTarget(c99950160.bantg2)
      e1:SetOperation(c99950160.banop2)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.8) Draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(99950160,14))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,99950160)
    e2:SetCondition(c99950160.drcon)
    e2:SetTarget(c99950160.drtg)
    e2:SetOperation(c99950160.drop)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
    --(1.9) Gain LP
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(99950160,8))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c99950160.reccon2)
    e3:SetTarget(c99950160.rectg2)
    e3:SetOperation(c99950160.recop2)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e3)
  end
end
--(1.1) Kaname Madoka
function c99950160.recfilter1(c,tp)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(0x80+LOCATION_SZONE) 
  and not c:IsType(TYPE_TOKEN) and c:GetPreviousControler()==tp
end
function c99950160.reccon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950160.recfilter1,1,nil,1-tp)
end
function c99950160.recop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99950160)
  Duel.Recover(tp,500,REASON_EFFECT)
end
--(1.2) Akemi Homura
function c99950160.unfcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950160.unffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995)
end
function c99950160.unftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99950160.unffilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950160.unffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950160,9))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950160.unffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950160.unfop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(99950160,9))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c99950160.unfilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    e1:SetOwnerPlayer(tp)
    tc:RegisterEffect(e1)
  end
end
function c99950160.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(1.4) Tomoe Mami
function c99950160.bancon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950160.bantg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950160,10))
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c99950160.banop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
  if g:GetCount()==0 then return end
  local sg=g:RandomSelect(tp,1)
  Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--(1.5) Sakura Kyouko
function c99950160.check(c,tp)
  return c and c:IsControler(tp) and c:IsSetCard(0x995)
end
function c99950160.damfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950160.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetAttackTarget()~=nil
  and (c99950160.check(Duel.GetAttacker(),tp) or c99950160.check(Duel.GetAttackTarget(),tp)) end
  local val=Duel.GetMatchingGroupCount(c99950160.damfilter,tp,0,LOCATION_REMOVED,nil)
  Duel.SetTargetPlayer(1-tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950160,15))
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val*100)
end
function c99950160.damop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local val=Duel.GetMatchingGroupCount(c99950160.damfilter,tp,0,LOCATION_REMOVED,nil)
  Duel.Damage(p,val*100,REASON_EFFECT)
end
--(1.6) Kaname Madokami
function c99950160.spfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x995) and c:GetLevel()==5
  and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99950160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99950160.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950160,11))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99950160.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99950160.spop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
  end
end
--(1.7) Akuma Homura
function c99950160.banfilter2(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToRemove()
end
function c99950160.bantg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950160.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950160,10))
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c99950160.banop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950160.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    --Place S/T Zone | Send to Grave
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabelObject(g:GetFirst())
    e1:SetCountLimit(1)
    e1:SetOperation(c99950160.pgop)
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
--Place S/T Zone | Send to Grave
function c99950160.pgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.HintSelection(Group.FromCards(tc))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    select=Duel.SelectOption(tp,aux.Stringid(99950160,12),aux.Stringid(99950160,13))
  else
    select=Duel.SelectOption(tp,aux.Stringid(99950160,13))
    select=1
  end
  if select==0 then
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
  else
    Duel.SendtoGrave(tc,REASON_EFFECT)
  end
end
--(1.8) Draw
function c99950160.drconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:GetSummonPlayer()==tp
end
function c99950160.drcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950160.drconfilter,1,nil,tp)
end
function c99950160.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950160.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99950160.drfilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c99950160.drop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c99950160.drfilter,tp,LOCATION_MZONE,0,nil)
  if ct>0 then
    Duel.Draw(p,ct,REASON_EFFECT)
  end
end
--(1.9) Gain Lp 2
function c99950160.recfilter2(c,tp)
  local pl=c:GetPreviousLocation()
  return c:IsPreviousSetCard(0x995) and c:GetPreviousControler()==tp 
  and ((c:IsType(TYPE_MONSTER) and pl==LOCATION_MZONE) or (c:IsLevelAbove(1) and pl==LOCATION_SZONE))
end
function c99950160.reccon2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950160.recfilter2,1,nil,tp)
end
function c99950160.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(500)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c99950160.recop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end