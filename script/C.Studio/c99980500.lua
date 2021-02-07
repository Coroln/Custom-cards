--HN MAGES.
--Scripted by Raivost
function c99980500.initial_effect(c)
  Pendulum.AddProcedure(c)
  --Pendulum Effcts
  --(1) Destroy replace
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetTarget(c99980500.dreptg)
  e1:SetValue(c99980500.drepval)
  e1:SetOperation(c99980500.drepop)
  c:RegisterEffect(e1)
  --(2) Inflict damage
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980500,0))
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99980500.damtg)
  e2:SetOperation(c99980500.damop)
  c:RegisterEffect(e2)
  --Monster Effects
  ---(1) Unaffected by S/T
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980500.unfilter)
  c:RegisterEffect(e3)
  --(2) Gain effect this turn
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e4:SetCode(EVENT_SUMMON_SUCCESS)
  e4:SetOperation(c99980500.geop)
  c:RegisterEffect(e4)
  local e5=e4:Clone()
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e5)
  if not c99980500.global_check then
    c99980500.global_check=true
    c99980500[0]=0
    c99980500[1]=0
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
    ge1:SetOperation(c99980500.checkop)
    Duel.RegisterEffect(ge1,0)
    local ge2=Effect.CreateEffect(c)
    ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    ge2:SetOperation(c99980500.clearop)
    Duel.RegisterEffect(ge2,0)
  end
end
--Pendulum Effects
--(1) Destroy replace
function c99980500.drepfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
    and c:IsSetCard(0x998) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
end
function c99980500.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99980500.drepfilter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c99980500.drepval(e,c)
  return c99980500.drepfilter(c,e:GetHandlerPlayer())
end
function c99980500.drepop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
---(2) Inflict damage
function c99980500.checkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    if tc:IsSetCard(0x998) and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
    and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) then
      local p=tc:GetSummonPlayer()
      c99980500[p]=c99980500[p]+1
    end
    tc=eg:GetNext()
  end
end
function c99980500.clearop(e,tp,eg,ep,ev,re,r,rp)
  c99980500[0]=0
  c99980500[1]=0
end 
function c99980500.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return c99980500[tp]>0 end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(c99980500[tp]*300)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c99980500[tp]*300)
end
function c99980500.damop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Damage(p,c99980500[tp]*300,REASON_EFFECT)
end
--Monster Effects
--(1) Unsaffected by S/T
function c99980500.unfilter(e,te)
  return te:IsActiveType(TYPE_TRAP+TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--(2) Gain effect this turn
function c99980500.geop(e,tp,eg,ep,ev,re,r,rp)
  --(2.1) Special Summon
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99980500,1))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,99980500)
  e1:SetTarget(c99980500.sptg)
  e1:SetOperation(c99980500.spop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(2.1) Special Summon
function c99980500.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980500.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99980500.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980500.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
