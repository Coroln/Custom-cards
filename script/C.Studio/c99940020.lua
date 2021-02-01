--NGNL Shiro
--Scripted by Raivost
function c99940020.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Scale Change
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DICE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99940020.sccon)
  e1:SetTarget(c99940020.sctg)
  e1:SetOperation(c99940020.scop)
  c:RegisterEffect(e1)
  --(2) Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940020,2))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_DRAW)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCondition(c99940020.revcon)
  e2:SetTarget(c99940020.revtg)
  e2:SetOperation(c99940020.revop)
  c:RegisterEffect(e2)
  --(3) Discard
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99940020,3))
  e3:SetCategory(CATEGORY_HANDES)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_DRAW)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCondition(c99940020.discon)
  e3:SetTarget(c99940020.distg)
  e3:SetOperation(c99940020.disop)
  c:RegisterEffect(e3)
  --Monster Effects
  --(1) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940020,4))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_LEAVE_FIELD)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCondition(c99940020.spcon)
  e4:SetTarget(c99940020.sptg)
  e4:SetOperation(c99940020.spop)
  c:RegisterEffect(e4)
  --(2) Send to GY 
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99940020,5))
  e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_TO_HAND)
  e5:SetCountLimit(1)
  e5:SetCondition(c99940020.tgcon)
  e5:SetTarget(c99940020.tgtg)
  e5:SetOperation(c99940020.tgop)
  c:RegisterEffect(e5)
  --Avoid battle damage
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e6:SetValue(1)
  c:RegisterEffect(e6)
end
--Pendulum Effects
--(1) Scale Change
function c99940020.sccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99940020.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  op=Duel.SelectOption(tp,aux.Stringid(99940020,0),aux.Stringid(99940020,1))
  e:SetLabel(op)
  if op==0 then
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  else
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
  end
end
function c99940020.scop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if e:GetLabel()==0 then
    local dc=Duel.TossDice(tp,1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(dc)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  else
    local d1,d2=Duel.TossDice(tp,2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(d1+d2)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  end
end
--(2) Reveal
function c99940020.revcon(e,tp,eg,ep,ev,re,r,rp)
  return ep==tp
end
function c99940020.revfilter(c,e,tp)
  return c:IsSetCard(0x994) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940020.tgfilter1(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c99940020.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c99940020.revfilter,1,nil,e,tp)
  and Duel.IsExistingMatchingCard(c99940020.tgfilter1,tp,LOCATION_DECK,0,1,nil) end
  local g=eg:Filter(c99940020.revfilter,nil,e,tp)
  if g:GetCount()==1 then
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    Duel.SetTargetCard(g)
  else
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local sg=g:Select(tp,1,1,nil)
    Duel.ConfirmCards(1-tp,sg)
    Duel.ShuffleHand(tp)
    Duel.SetTargetCard(sg)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99940020.revop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsLocation(LOCATION_DECK) or (tc:IsLocation(LOCATION_REMOVED) and tc:IsFacedown()) 
  or (tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)<=0 and tc:IsFaceup()) then return end
  if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c99940020.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_EFFECT)
    end
  end
end
--(3) Discard
function c99940020.discon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940020.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99940020.disop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
  if g:GetCount()~=0 then
    local sg=g:RandomSelect(1-tp,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
  end
end
--Monster Effects
--(1) Special Summon 
function c99940020.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
  and not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c99940020.spfilter(c,e,tp)
  return c:IsSetCard(0x994) and not c:IsCode(99940020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(1-tp,1)
  and Duel.IsExistingMatchingCard(c99940020.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c99940020.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99940020.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    Duel.Draw(1-tp,1,REASON_EFFECT)
  end
end
--(2) Send to GY
function c99940020.tgconfilter(c,tp)
  return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c99940020.tgcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99940020.tgconfilter,1,nil,1-tp)
end
function c99940020.tgfilter2(c)
  return c:IsSetCard(0x994) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c99940020.disfilter(c,e,tp)
  return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c99940020.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99940020.tgfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
  local g=eg:Filter(c99940020.tgconfilter,nil,1-tp)
  Duel.SetTargetCard(g)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99940020.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99940020.tgfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  local sg=eg:Filter(c99940020.disfilter,nil,e,1-tp)
  if g:GetCount()~=0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
    if sg:GetCount()==0 then
      elseif sg:GetCount()==1 then
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
      else
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
        local dg=sg:Select(1-tp,1,1,nil)
        Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
    end
  end
end