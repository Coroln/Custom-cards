--HN IF
--Scripted by Raivost
function c99980190.initial_effect(c)
  --(1) Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980190,0))
  e1:SetCategory(CATEGORY_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,99980190)
  e1:SetTarget(c99980190.nstg)
  e1:SetOperation(c99980190.nsop)
  c:RegisterEffect(e1)
end
--(1) Normal Summon
function c99980190.nsfilter(c)
  return c:IsSetCard(0x998) and c:IsSummonable(true,nil)
end
function c99980190.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980190.nsfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c99980190.nsop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980190.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.Summon(tp,g:GetFirst(),true,nil)
  end
end