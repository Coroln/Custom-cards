--HN CPU Noire
--Scripted by Raivost
function c99980060.initial_effect(c)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980060,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,99980060)
  e1:SetTarget(c99980060.thtg)
  e1:SetOperation(c99980060.thop)
  c:RegisterEffect(e1)
  --(2) Place in S/T Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980060,1))
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCountLimit(1,99980061)
  e2:SetCondition(c99980060.stzcon)
  e2:SetTarget(c99980060.stztg)
  e2:SetOperation(c99980060.stzop)
  c:RegisterEffect(e2)
  --(3) Level 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980060.xyzlv)
  c:RegisterEffect(e3)
end
c99980060.listed_names={99980060}
--(1) Search
function c99980060.thfilter(c)
  return c:IsCode(99980080) and c:IsAbleToHand()
end
function c99980060.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980060.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980060.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=Duel.GetFirstMatchingCard(c99980060.thfilter,tp,LOCATION_DECK,0,nil)
  if tc then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
  end
end
--(2) Place in S/T Zone
function c99980060.stzcon(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c99980060.stzfilter(c,tp)
  return c:IsCode(99980080) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c99980060.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(c99980060.stzfilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980060.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local tc=Duel.GetFirstMatchingCard(c99980060.stzfilter,tp,LOCATION_DECK,0,nil,tp)
  if tc then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end
--(3) Level 4 Xyz
function c99980060.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end