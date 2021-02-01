--MSMM Decretum
--Scripted by Raivost
function c99950240.initial_effect(c)
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99950240,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950240.destg)
  e1:SetOperation(c99950240.desop)
  c:RegisterEffect(e1)
  --(2) Equip
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950240,1))
  e2:SetCategory(CATEGORY_EQUIP)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(aux.exccon)
  e2:SetTarget(c99950240.eqtg)
  e2:SetOperation(c99950240.eqop)
  c:RegisterEffect(e2)
end
--(1) Destroy 
function c99950240.desfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950240.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950240.desfilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99950240.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,c99950240.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
  if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
      Duel.HintSelection(g)
      if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
        Duel.Draw(tp,1,REASON_EFFECT)
      end
    end
  end
end
--(2) Equip
function c99950240.eqfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950240.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingTarget(c99950240.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  Duel.SelectTarget(tp,c99950240.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950240.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
  Duel.Equip(tp,c,tc,true)
  --(2.1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(c99950240.eqlimit)
  e1:SetLabelObject(tc)
  c:RegisterEffect(e1)
  --(2.2) Cannot Attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_CANNOT_ATTACK)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  --(2.3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950240,2))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
  e3:SetHintTiming(TIMING_DAMAGE_STEP)
  e3:SetCondition(c99950240.atkcon)
  e3:SetTarget(c99950240.atktg)
  e3:SetOperation(c99950240.atkop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e3)
  --(2.4) Gain LP
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950240,3))
  e4:SetCategory(CATEGORY_RECOVER)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_LEAVE_FIELD)
  e4:SetCondition(c99950240.reccon)
  e4:SetTarget(c99950240.rectg)
  e4:SetOperation(c99950240.recop)
  e4:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e4)
end
--(2.1) Equip
function c99950240.eqlimit(e,c)
  return c==e:GetLabelObject()
end
--(2.3) Gain ATK
function c99950240.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c99950240.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x995) 
end
function c99950240.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ec=e:GetHandler():GetEquipTarget()
  if chk==0 then return Duel.IsExistingTarget(c99950240.atkfilter,tp,LOCATION_MZONE,0,1,ec) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99950240.atkfilter,tp,LOCATION_MZONE,0,1,1,ec)
end
function c99950240.atkop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  local ec=e:GetHandler():GetEquipTarget()
  local atk=math.floor(ec:GetAttack()/2)
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
--(2.4) Gain LP
function c99950240.reccon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ec=c:GetPreviousEquipTarget()
  return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY)
end
function c99950240.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local rec=e:GetHandler():GetPreviousEquipTarget():GetBaseAttack()
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(math.floor(rec/2))
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.floor(rec/2))
end
function c99950240.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end