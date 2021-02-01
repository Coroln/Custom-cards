--HN Nisa
--Scripted by Raivost
function c99980540.initial_effect(c)
  --(1) Special Summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980540,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetCondition(c99980540.spcon1)
  e1:SetTarget(c99980540.sptg1)
  e1:SetOperation(c99980540.spop1)
  c:RegisterEffect(e1)
  --(2) Special Summon 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980540,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,99980540)
  e2:SetTarget(c99980540.sptg2)
  e2:SetOperation(c99980540.spop2)
  c:RegisterEffect(e2)
end
--(1) Special Summon 1
function c99980540.spconfilter1(c,tp)
  return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) 
  and c:IsSetCard(0x998) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c99980540.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980540.spconfilter1,1,nil,tp)
end
function c99980540.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99980540.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0
    and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
    Duel.SendtoGrave(c,REASON_RULE)
  end
  local ph=Duel.GetCurrentPhase()
  if tp~=Duel.GetTurnPlayer() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
  Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
  end
end
--(2) 
function c99980540.spfilter2(c,e,tp)
  return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980540.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980540.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99980540.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980540.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e)
  and c:IsFaceup() and c:GetLevel()~=4 and Duel.SelectYesNo(tp,aux.Stringid(99980540,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980540,2))
  	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
  end
end