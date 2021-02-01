--Overlord Nazarick Guardian, Shalltear Bloodfallen
--Scripted by Raivost
function c99920040.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetDescription(aux.Stringid(99920040,0))
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99920040.hspcon)
  e1:SetOperation(c99920040.hspop)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920040,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99920040.atkcon)
  e2:SetTarget(c99920040.atktg)
  e2:SetOperation(c99920040.atkop)
  c:RegisterEffect(e2)
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99920040,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,99920040)
  e3:SetTarget(c99920040.sptg)
  e3:SetOperation(c99920040.spop)
  c:RegisterEffect(e3)
  --(4) Gain LP 1
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99920040,2))
  e4:SetCategory(CATEGORY_RECOVER)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCode(EVENT_BATTLE_DAMAGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99920040.reccon1)
  e4:SetOperation(c99920040.recop1)
  c:RegisterEffect(e4)
  --(5) Gain LP 2
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99920040,2))
  e5:SetCategory(CATEGORY_RECOVER)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99920040.reccon2)
  e5:SetTarget(c99920040.rectg2)
  e5:SetOperation(c99920040.recop2)
  c:RegisterEffect(e5)
end
--(1) Special Summon from hand
function c99920040.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c99920040.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
--(2) Gain ATK/DEF
function c99920040.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  return c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 or (re and rc:IsSetCard(0x992) and rc~=c)
end
function c99920040.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99920040.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(Duel.GetLP(tp))
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
  end
end
--(3) Special Summon
function c99920040.spfilter(c,e,tp)
  return c:IsSetCard(0x992) and  c:IsSetCard(0xB92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99920040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99920040.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99920040.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99920040.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(4) Gain LP 1
function c99920040.reccon1(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp
end
function c99920040.recop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99920040)
  Duel.Recover(tp,ev,REASON_EFFECT)
end
--(5) Gain LP 2
function c99920040.ainzfiler(c,seq,p)
  return c:IsFaceup() and c:IsCode(99920010) and c:IsColumn(seq,p,LOCATION_MZONE)
end
function c99920040.reccon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local tp=e:GetHandlerPlayer()
  local g=e:GetHandler():GetColumnGroup()
  return tc:GetSummonPlayer()~=tp and (g:IsContains(tc) 
  or Duel.IsExistingMatchingCard(c99920040.ainzfiler,tp,LOCATION_MZONE,0,1,nil,tc:GetSequence(),1-tp))
end
function c99920040.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1000)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c99920040.recop2(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end  