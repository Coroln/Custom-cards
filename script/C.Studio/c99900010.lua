--RE:C Altair
--Scripted by Raivost
function c99900010.initial_effect(c)
  c:EnableReviveLimit()
  --Link Summon 
  Link.AddProcedure(c,c99900010.matfilter,3,3)
  --(1) Return to Extra Deck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99900010,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetCondition(c99900010.redcon)
  e1:SetTarget(c99900010.redtg)
  e1:SetOperation(c99900010.redop)
  c:RegisterEffect(e1)
  --(2) Copy effect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99900010,3))
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCost(c99900010.copycost)
  e2:SetTarget(c99900010.copytg)
  e2:SetOperation(c99900010.copyop)
  e2:SetHintTiming(0,TIMING_END_PHASE)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99900010.atkval)
  e3:SetCondition(c99900010.atkcon)
  c:RegisterEffect(e3)
  --(4) Cannot target 
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetCondition(c99900010.ctgcon)
  e4:SetTarget(c99900010.ctgtg)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTargetRange(0,LOCATION_MZONE)
  e5:SetCondition(c99900010.ctgcon)
  e5:SetValue(c99900010.ctgtg)
  c:RegisterEffect(e5)
  --(5) Draw
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e6:SetCategory(CATEGORY_DRAW)
  e6:SetCode(EVENT_DISCARD)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCondition(c99900010.drcon)
  e6:SetOperation(c99900010.drop)
  c:RegisterEffect(e6)
end
--Link Summon
function c99900010.matfilter(c,lc,sumtype,tp)
  return c:IsSetCard(0x990,lc,sumtype,tp) and c:GetFlagEffect(99900060)~=0
end
--(1) Return to Extra Deck
function c99900010.redcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c99900010.redtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToExtra() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99900010.redfilter(c)
  return c:IsSetCard(0x990) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99900010.redop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) 
  and Duel.IsExistingMatchingCard(c99900010.redfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99900010,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99900010,2))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99900010.redfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
  Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
  local g2=Duel.GetOperatedGroup()
  if g2:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=g2:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct>0 then
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
  end
  end
end
--(2) Copy effect
function c99900010.copycostfilter(c)
  return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(99900010)
end
function c99900010.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99900010.copycostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(99900010)==0 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99900010.copycostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  e:SetLabel(g:GetFirst():GetOriginalCode())
  e:GetHandler():RegisterFlagEffect(99900010,RESET_CHAIN,0,1)
end
function c99900010.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99900010.copyop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local code=e:GetLabel()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000)
    Duel.RaiseEvent(c,EVENT_CUSTOM+99900010,e,0,tp,0,0)
    --(2.1) Reset effect
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetCode(EVENT_CUSTOM+99900010)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetLabel(cid)
    e1:SetCondition(c99900010.resetcon)
    e1:SetOperation(c99900010.resetop)
    c:RegisterEffect(e1)
  end
end
--(2.1) Reset effect
function c99900010.resetcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=re:GetHandler()
  return rc==c
end
function c99900010.resetop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local cid=e:GetLabel()
  if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
end
--(3) Gain ATK
function c99900010.atkcon(e)
  local lg=e:GetHandler():GetLinkedGroup():Filter(c99900010.atkfilter,nil)
  return lg:GetCount()>=1
end
function c99900010.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x990)
end
function c99900010.atkval(e,c)
  local lg=c:GetLinkedGroup():Filter(c99900010.atkfilter,nil)
  return lg:GetCount()*500
end
--(4) Cannot target
function c99900010.ctgcon(e)
  local lg=e:GetHandler():GetLinkedGroup():Filter(c99900010.atkfilter,nil)
  return lg:GetCount()>=2
end
function c99900010.ctgtg(e,c)
  return c:IsSetCard(0x990) and c~=e:GetHandler()
end
--(5) Draw
function c99900010.drconfilter(c)
  return c:IsSetCard(0x990) and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_EFFECT)
end
function c99900010.drcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup():Filter(c99900010.atkfilter,nil)
  return eg:IsExists(c99900010.drconfilter,1,nil)
  and lg:GetCount()==3
end
function c99900010.drop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99900010)
  Duel.Draw(tp,1,REASON_EFFECT)
end
