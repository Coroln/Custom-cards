--HN CPU Peashy
--Scripted by Raivost
function c99980230.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980230,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,99980230)
  e1:SetTarget(c99980230.thtg)
  e1:SetOperation(c99980230.thop)
  c:RegisterEffect(e1)
  --(2) Place in Pendulum Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980230,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCountLimit(1,99980231)
  e2:SetCondition(c99980230.pencon)
  e2:SetTarget(c99980230.pentg)
  e2:SetOperation(c99980230.penop)
  c:RegisterEffect(e2)
  --(3) Level 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980230.xyzlv)
  c:RegisterEffect(e3)
end
--(1) Search
function c99980230.thfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99980230.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980230.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980230.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980230.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Place in Pendulum Zone
function c99980230.pencon(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c99980230.penfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99980230.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980230.penfilter,tp,LOCATION_DECK,0,1,nil)
  and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980230.penop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c99980230.penfilter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc then
    Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end
--(3) Level 4 Xyz
function c99980230.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end