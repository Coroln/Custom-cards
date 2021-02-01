--DAL Arusu Maria
--Scripted by Raivost
function c99970460.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum effects
  --(1) Search 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970460,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1,99970460)
  e1:SetTarget(c99970460.thtg1)
  e1:SetOperation(c99970460.thop1)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970460,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCondition(c99970460.descon)
  e2:SetTarget(c99970460.destg)
  e2:SetOperation(c99970460.desop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Special Summon from hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970460,2))
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_SPSUMMON_PROC)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e3:SetRange(LOCATION_HAND)
  e3:SetCountLimit(1)
  e3:SetCondition(c99970460.hspcon)
  e3:SetOperation(c99970460.hspop)
  c:RegisterEffect(e3)
  --(2) Search 2
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970460,0))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_SUMMON_SUCCESS)
  e4:SetCountLimit(1,99970461)
  e4:SetTarget(c99970460.thtg2)
  e4:SetOperation(c99970460.thop2)
  c:RegisterEffect(e4)
  local e5=e4:Clone()
  e5:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e5)
  --(3) Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e6:SetCode(EVENT_CHAINING)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetOperation(aux.chainreg)
  c:RegisterEffect(e6)
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99970460,2))
  e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e7:SetCode(EVENT_CHAIN_SOLVED)
  e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e7:SetRange(LOCATION_MZONE)
  e7:SetCondition(c99970460.spcon)
  e7:SetCost(c99970460.spcost)
  e7:SetTarget(c99970460.sptg)
  e7:SetOperation(c99970460.spop)
  c:RegisterEffect(e7)
  --(4) Place Pendulum Zone
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99970460,3))
  e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e8:SetRange(LOCATION_EXTRA)
  e8:SetCountLimit(1)
  e8:SetCondition(c99970460.pzcon)
  e8:SetTarget(c99970460.pztg)
  e8:SetOperation(c99970460.pzop)
  c:RegisterEffect(e8)
end
c99970460.listed_namescount=1
c99970460.listed_names={99970470}
--Pendulum Effects
--(1) Search
function c99970460.thfilter1(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c99970460.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970460.thfilter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970460.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970460.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Destroy
function c99970460.desconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970460.descon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingTarget(c99970460.desconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970460.desfilter(c)
  return c:IsCode(99970470) and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() 
  and c:IsLocation(LOCATION_EXTRA))) and not c:IsForbidden()
end
function c99970460.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable()
  and Duel.IsExistingMatchingCard(c99970460.desfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c99970460.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c99970460.desfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
      Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
  end
end
--Monster Effects
--(1) Special Summon from hand
function c99970460.hspconfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c99970460.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c99970460.hspconfilter,tp,LOCATION_HAND,0,1,nil)
end
function c99970460.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c99970460.hspconfilter,tp,LOCATION_HAND,0,1,1,nil)
  Duel.ConfirmCards(1-tp,g)
  Duel.ShuffleHand(tp)
end
--(2) Search 2
function c99970460.thfilter2(c)
  return c:IsCode(99970010) and c:IsAbleToHand()
end
function c99970460.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970460.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99970460.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970460.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Special Summon
function c99970460.spcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp
end
function c99970460.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99970460.spfilter(c,e,tp)
  return c:IsCode(99970470) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99970460.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970460.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970460.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(4) Place Pendulum Zone
function c99970460.pzcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970460.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970460.pzop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end