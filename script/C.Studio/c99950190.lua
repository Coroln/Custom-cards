--MSMM Akuma Homura
--Scripted by Raivost
function c99950190.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950190.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_MATERIAL_CHECK)
  e2:SetValue(c99950190.matcheck)
  c:RegisterEffect(e2)
  --(3) Banish 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950190,0))
  e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetTarget(c99950190.bantg1)
  e3:SetOperation(c99950190.banop1)
  c:RegisterEffect(e3)
  --(4) Unaffected
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99950190.unfilter)
  c:RegisterEffect(e4)
  --(5) Inflict Damage
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950190,1))
  e5:SetCategory(CATEGORY_DAMAGE)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTarget(c99950190.damtg)
  e5:SetOperation(c99950190.damop)
  c:RegisterEffect(e5)
  --(6) Negate
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99950190,2))
  e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
  e6:SetType(EFFECT_TYPE_QUICK_O)
  e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e6:SetCode(EVENT_CHAINING)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetCondition(c99950190.negcon)
  e6:SetTarget(c99950190.negtg)
  e6:SetOperation(c99950190.negop)
  c:RegisterEffect(e6)
  --(7) Place in S/T Zone
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950190,3))
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e7:SetCode(EVENT_LEAVE_FIELD)
  e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e7:SetCondition(c99950190.stzcon)
  e7:SetTarget(c99950190.stztg)
  e7:SetOperation(c99950190.stzop)
  c:RegisterEffect(e7)
  --(8) Banish 2
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950190,4))
  e8:SetType(EFFECT_TYPE_QUICK_O)
  e8:SetRange(LOCATION_SZONE)
  e8:SetCode(EVENT_FREE_CHAIN)
  e8:SetCountLimit(1)
  e8:SetTarget(c99950190.bantg2)
  e8:SetOperation(c99950190.banop2)
  c:RegisterEffect(e8)
end
--Ritual Condition
function c99950190.filter(c,tp)
  return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_SZONE) and c:IsSetCard(0x995)
  and bit.band(c:GetOriginalType(),0x81)==0x81 and c:GetLevel()==5
end
function c99950190.ritual_custom_condition(c,mg,ft)
  local tp=c:GetControler()
  local g=mg:Filter(c99950190.filter,c,tp)
  return g:IsExists(c99950190.ritfilter1,5,nil,c:GetLevel(),g)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c99950190.ritfilter1(c,lv,mg)
  local mg2=mg:Clone()
  return c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81  
  and c:GetLevel()==5 and c:IsAbleToDeck()
end
function c99950190.ritual_custom_operation(c,mg)
  local tp=c:GetControler()
  local lv=c:GetLevel()
  local g=mg:Filter(c99950190.filter,c,tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
  local g1=g:FilterSelect(tp,c99950190.ritfilter1,5,99,nil,lv,g)
  c:SetMaterial(g1)
end
--(1) Special Summon condition
function c99950190.splimit(e,se,sp,st)
  return e:GetHandler():IsLocation(LOCATION_HAND) and se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK/DEF
function c99950190.matcheck(e,c)
  local ct=c:GetMaterialCount()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(ct*500)
  e1:SetReset(RESET_EVENT+0xff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end
--(3) Banish 1
function c99950190.banfilter1(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950190.bantg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99950070.banfilter,tp,0,LOCATION_MZONE,nil)  
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c99950190.banop1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99950190.banfilter1,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
  end
end
--(4) Unaffected
function c99950190.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(5) Inflict Damage
function c99950190.damfilter(c,tp)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsControler(tp)
end
function c99950190.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=eg:Filter(c99950190.damfilter,e:GetHandler(),tp)
  local ct=g:GetCount()
  if chk==0 then return ct>0 end
  Duel.SetTargetCard(eg)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
end
function c99950190.damop(e,tp,eg,ep,ev,re,r,rp)
  local g=eg:Filter(c99950190.damfilter,e:GetHandler(),tp):Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 then
    local dmg=0
    local tc=g:GetFirst()
    while tc do
      dmg=dmg+tc:GetBaseAttack()
      tc=g:GetNext()
    end
    if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
      Duel.Damage(1-tp,dmg,REASON_EFFECT)
    end
  end
end
--(6) Negate
function c99950190.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99950190.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
  end
end
function c99950190.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
  end
end
--(7) Place in S/T Zone
function c99950190.stzcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c99950190.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99950190.stzop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  --Continuous Spell
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetCode(EFFECT_CHANGE_TYPE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fc0000)
  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
  c:RegisterEffect(e1)
  Duel.RaiseEvent(c,EVENT_CUSTOM+99950150,e,0,tp,0,0)
end
--(8) Banish 2
function c99950190.banfilter2(c)
  return c:IsSetCard(0x995) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToRemove()
end
function c99950190.bantg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950190.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c99950190.banop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950190.banfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    --(8.1) Place S/T Zone | Send to Grave
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabelObject(g:GetFirst())
    e1:SetCountLimit(1)
    e1:SetOperation(c99950190.pgop)
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
--(8.1) Place S/T Zone | Send to Grave
function c99950190.pgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.HintSelection(Group.FromCards(tc))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    select=Duel.SelectOption(tp,aux.Stringid(99950190,5),aux.Stringid(99950190,6))
  else
    select=Duel.SelectOption(tp,aux.Stringid(99950190,6))
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