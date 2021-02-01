--SAO Sinon - ALO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(Card.IsSetCard,0x999),1,1)
  c:EnableReviveLimit()
  --(1) To Deck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.tdtg)
  e1:SetOperation(s.tdop)
  c:RegisterEffect(e1)
  --(2) Banish
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_HAND)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,id+1)
  e2:SetCondition(s.bancon)
  e2:SetCost(s.bancost)
  e2:SetTarget(s.bantg)
  e2:SetOperation(s.banop)
  c:RegisterEffect(e2)
end
--(1) To Deck
function s.tdfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and not c:IsSetCard(0x1999) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
  and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end
--(2) Banish
function s.banfilter(c,tp)
  return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_RULE)
end
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(s.banfilter,1,nil,1-tp) and #eg==1
end
function s.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local ec=eg:GetFirst()
  if chk==0 then return ec and ec:IsAbleToRemove() end
  local p=ec:GetControler()
  e:SetLabelObject(ec)
  ec:CreateEffectRelation(e)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,ec,1,0,0)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if not tc or not tc:IsRelateToEffect(e) then return end
  if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetCondition(s.retcon)
    e1:SetOperation(s.retop)
    e1:SetLabelObject(tc)
    e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
  end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffect(id)==0 then
    e:Reset()
    return false
  else
    return Duel.GetTurnPlayer()~=tp
  end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
end