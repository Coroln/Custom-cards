--Overlord Nazarick Guardian, Albedo
--Scripted by Raivost
function c99920030.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetDescription(aux.Stringid(99920030,0))
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99920030.hspcon)
  e1:SetOperation(c99920030.hspop)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920030,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99920030.atkcon)
  e2:SetTarget(c99920030.atktg)
  e2:SetOperation(c99920030.atkop)
  c:RegisterEffect(e2)
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99920030,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,99920030)
  e3:SetTarget(c99920030.sptg)
  e3:SetOperation(c99920030.spop)
  c:RegisterEffect(e3)
  --(4) Cannot attack
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(0,LOCATION_MZONE)
  e4:SetValue(c99920030.atlimit)
  c:RegisterEffect(e4)
  --(5) Change position
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99920030,2))
  e5:SetCategory(CATEGORY_POSITION)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_SUMMON_SUCCESS)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTarget(c99920030.postg)
  e5:SetOperation(c99920030.posop)
  c:RegisterEffect(e5)
  local e6=e5:Clone()
  e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e6)
  local e7=e5:Clone()
  e7:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e7)
end
--(1) Special Summon from hand
function c99920030.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c99920030.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
--(2) Gain ATK/DEF
function c99920030.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  return c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 or (re and rc:IsSetCard(0x992) and rc~=c)
end
function c99920030.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99920030.atkop(e,tp,eg,ep,ev,re,r,rp)
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
function c99920030.spfilter(c,e,tp)
  return c:IsSetCard(0x992) and  c:IsSetCard(0xB92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99920030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99920030.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99920030.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99920030.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(4) Cannot attack
function c99920030.atlimit(e,c)
  return c:IsFaceup() and c:IsSetCard(0x992) and not c:IsCode(99920030)
end
--(5) Change position
function c99920030.ainzfiler(c,seq,p)
  return c:IsFaceup() and c:IsCode(99920010) and c:IsColumn(seq,p,LOCATION_MZONE)
end
function c99920030.posfilter(c,tp,g)
  return c:GetSummonPlayer()~=tp and not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition() and (g:IsContains(c) 
  or Duel.IsExistingMatchingCard(c99920030.ainzfiler,tp,LOCATION_MZONE,0,1,nil,c:GetSequence(),1-tp))
end
function c99920030.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99920030.posfilter,1,nil,tp,e:GetHandler():GetColumnGroup()) end
  local g=eg:Filter(c99920030.posfilter,nil,tp,e:GetHandler():GetColumnGroup())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetTargetCard(g)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c99920030.posop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c99920030.posfilter,nil,tp,e:GetHandler():GetColumnGroup())
  if g:GetCount()>0 then
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
  end
end