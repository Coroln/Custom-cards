--MSMM Kaname Madokami
--Scripted by Raivost
function c99950070.initial_effect(c)
  c:EnableReviveLimit()
  --(1) Special Summon condition
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950070.splimit)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_MATERIAL_CHECK)
  e2:SetValue(c99950070.matcheck)
  c:RegisterEffect(e2)
  --(3) Banish
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99950070,0))
  e3:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetTarget(c99950070.bantg)
  e3:SetOperation(c99950070.banop)
  c:RegisterEffect(e3)
  --(4) Unaffected
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99950070.unfilter)
  c:RegisterEffect(e4)
  --(5) Gain Lp
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950070,1))
  e5:SetCategory(CATEGORY_RECOVER)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_BATTLE_DAMAGE)
  e5:SetCondition(c99950070.reccon)
  e5:SetTarget(c99950070.rectg)
  e5:SetOperation(c99950070.recop)
  c:RegisterEffect(e5)
  --(6) Negate
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99950070,2))
  e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
  e6:SetType(EFFECT_TYPE_QUICK_O)
  e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e6:SetCode(EVENT_CHAINING)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetCondition(c99950070.negcon)
  e6:SetTarget(c99950070.negtg)
  e6:SetOperation(c99950070.negop)
  c:RegisterEffect(e6)
  --(7) Place in S/T Zone
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99950070,3))
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e7:SetCode(EVENT_LEAVE_FIELD)
  e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e7:SetCondition(c99950070.stzcon)
  e7:SetTarget(c99950070.stztg)
  e7:SetOperation(c99950070.stzop)
  c:RegisterEffect(e7)
  --(8) Special Summon
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99950070,4))
  e8:SetType(EFFECT_TYPE_QUICK_O)
  e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e8:SetRange(LOCATION_SZONE)
  e8:SetCode(EVENT_FREE_CHAIN)
  e8:SetCountLimit(1)
  e8:SetCondition(c99950070.spcon)
  e8:SetTarget(c99950070.sptg)
  e8:SetOperation(c99950070.spop)
  c:RegisterEffect(e8)
end
--Ritual Condition
function c99950070.filter(c,tp)
  return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_SZONE) and c:IsSetCard(0x995)
  and bit.band(c:GetOriginalType(),0x81)==0x81 and c:GetLevel()==5
end
function c99950070.ritual_custom_condition(c,mg,ft)
  local tp=c:GetControler()
  local g=mg:Filter(c99950070.filter,c,tp)
  return g:IsExists(c99950070.ritfilter1,5,nil,c:GetLevel(),g)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c99950070.ritfilter1(c,lv,mg)
  local mg2=mg:Clone()
  return c:IsSetCard(0x995) and bit.band(c:GetOriginalType(),0x81)==0x81  
  and c:GetLevel()==5 and c:IsAbleToDeck()
end
function c99950070.ritual_custom_operation(c,mg)
  local tp=c:GetControler()
  local lv=c:GetLevel()
  local g=mg:Filter(c99950070.filter,c,tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
  local g1=g:FilterSelect(tp,c99950070.ritfilter1,5,99,nil,lv,g)
  c:SetMaterial(g1)
end
--(1) Special Summon condition
function c99950070.splimit(e,se,sp,st)
  return e:GetHandler():IsLocation(LOCATION_HAND) and se:GetHandler():IsSetCard(0x995)
end
--(2) Gain ATK/DEF
function c99950070.matcheck(e,c)
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
--(3) Banish
function c99950070.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950070.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g=Duel.GetMatchingGroup(c99950070.banfilter,tp,0,LOCATION_MZONE,nil)  
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c99950070.banop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99950070.banfilter,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
    Duel.Recover(tp,g:GetCount()*500,REASON_EFFECT)
  end
end
--(4) Unaffected
function c99950070.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(5) Gain LP
function c99950070.reccon(e,tp,eg,ep,ev,re,r,rp)
  if ep==tp then return false end
  local rc=eg:GetFirst()
  return rc:IsControler(tp) and rc:IsSetCard(0x995)  and rc~=e:GetHandler()
end
function c99950070.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(ev/2)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev/2)
end
function c99950070.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end
--(6) Negate
function c99950070.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99950070.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
  end
end
function c99950070.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
  end
end
--Place in S/T Zone
function c99950070.stzcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetHandler():IsPreviousPosition(POS_FACEUP) 
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c99950070.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99950070.stzop(e,tp,eg,ep,ev,re,r,rp)
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
--(8) Special Summon
function c99950070.spfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x995) and c:GetLevel()==5
  and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99950070.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP) 
end
function c99950070.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99950070.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99950070.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99950070.spop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
  end
end