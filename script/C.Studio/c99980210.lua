--HN CPU Plutia
--Scripted by Raivost
function c99980210.initial_effect(c)
  --(1) Search 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980210,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,99980210)
  e1:SetTarget(c99980210.thtg1)
  e1:SetOperation(c99980210.thop1)
  c:RegisterEffect(e1)
  --(2) Search 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980210,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCountLimit(1,99980211)
  e2:SetCondition(c99980210.thcon2)
  e2:SetTarget(c99980210.thtg2)
  e2:SetOperation(c99980210.thop2)
  c:RegisterEffect(e2)
  --(3) Level 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980210.xyzlv)
  c:RegisterEffect(e3)
end
--(1) Search 1
function c99980210.thfilter1(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function c99980210.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980210.thfilter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980210.thop1(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980210.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  	Duel.SendtoHand(g,nil,REASON_EFFECT)
  	Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Search 2
function c99980210.thcon2(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c99980210.thfilter2(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c99980210.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980210.thfilter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980210.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980210.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  	Duel.SendtoHand(g,nil,REASON_EFFECT)
  	Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Level 4 Xyz
function c99980210.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end