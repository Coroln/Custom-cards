--DAL Irregular Spirit - AI
--Scripted by Raivost
function c99970470.initial_effect(c)
  Pendulum.AddProcedure(c)
  --Pendulum effects
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970470,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCondition(c99970470.reccon)
  e1:SetTarget(c99970470.rectg)
  e1:SetOperation(c99970470.recop)
  c:RegisterEffect(e1)
  --(2) Unaffected by Spell 1
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x997))
  e2:SetValue(c99970470.unsfilter)
  c:RegisterEffect(e2)
  --Monster effects
  --(1) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970470,1))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(c99970470.revcon)
  e3:SetTarget(c99970470.revtg)
  e3:SetOperation(c99970470.revop)
  c:RegisterEffect(e3)
  --(2) Unaffected by Spell 2
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99970470.unsfilter)
  c:RegisterEffect(e4)
  --(3) Special Summon
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970470,2))
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_DESTROYED)
  e5:SetCondition(c99970470.spcon)
  e5:SetTarget(c99970470.sptg)
  e5:SetOperation(c99970470.spop)
  c:RegisterEffect(e5)
end
--Pendulum effects
--(1) Gain LP
function c99970470.reccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970470.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local rec=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec*300)
end
function c99970470.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local rec=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
  Duel.Recover(p,rec*300,REASON_EFFECT)
end
--(2) Unaffected Spell 1
function c99970470.unsfilter(e,te)
  return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
--Monster effects
--(1) Gain ATK
function c99970470.revcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970470.revfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970470.revfilter2(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970470.revtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970470.revfilter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970470.revfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970470.revop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local tc=Duel.GetFirstTarget()
  Duel.ConfirmDecktop(tp,5)
  local g=Duel.GetDecktopGroup(tp,5)
  local ct=g:FilterCount(c99970470.revfilter2,nil)
  Duel.ShuffleDeck(tp)
  if ct>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct*500)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
--(3) Special Summon
function c99970470.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970470.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970470.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970470.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970470.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970470.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
