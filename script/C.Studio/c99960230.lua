--BRS Chain Wings Of Hope
--Scripted by Raivost
function c99960230.initial_effect(c)
  --(1) Activate effects
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960230+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960230.aecost)
  e1:SetTarget(c99960230.aetg)
  e1:SetOperation(c99960230.aeop)
  c:RegisterEffect(e1)
  --(2) Gain LP
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960230,2))
  e2:SetCategory(CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960230.reccon)
  e2:SetTarget(c99960230.rectg)
  e2:SetOperation(c99960230.recop)
  c:RegisterEffect(e2)
end
--(1) Activate effects
function c99960230.aecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960230.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960230.tdfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99960230.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960230.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
  local b2=Duel.IsExistingTarget(c99960230.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
  	op=Duel.SelectOption(tp,aux.Stringid(99960230,0),aux.Stringid(99960230,1))
  elseif b1 then
  	op=Duel.SelectOption(tp,aux.Stringid(99960230,0))
  else
  	op=Duel.SelectOption(tp,aux.Stringid(99960230,1))+1
  end
  e:SetLabel(op)
  if op==0 then
  	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
  else
  	e:SetCategory(CATEGORY_TODECK)
  	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
  	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c99960230.tdfilter),tp,LOCATION_GRAVE,0,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  end
end
function c99960230.aeop(e,tp,eg,ep,ev,re,r,rp)
  local op=e:GetLabel()
  if op==0 then
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if ft>2 then ft=2 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960230.spfilter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  else
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct>0 then
      local e1=Effect.CreateEffect(e:GetHandler())
  	  e1:SetType(EFFECT_TYPE_FIELD)
  	  e1:SetCode(EFFECT_CHANGE_DAMAGE)
  	  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  	  e1:SetTargetRange(1,0)
  	  e1:SetValue(0)
  	  e1:SetReset(RESET_PHASE+PHASE_END,2)
  	  Duel.RegisterEffect(e1,tp)
  	  local e2=e1:Clone()
  	  e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
  	  e2:SetReset(RESET_PHASE+PHASE_END,2)
  	  Duel.RegisterEffect(e2,tp)
  	end
  end
end
--(2) Gain LP
function c99960230.recfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996) 
end
function c99960230.reccon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960230.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  local ct=Duel.GetMatchingGroupCount(c99960230.recfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c99960230.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c99960230.recfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.Recover(p,ct*500,REASON_EFFECT)
end