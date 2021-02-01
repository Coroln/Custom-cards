--BRS Star Burst Forbearance
--Scripted by Raivost
function c99960300.initial_effect(c)
  --(1) Attach
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960300,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960300+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99960300.attchtg)
  e1:SetOperation(c99960300.attachop)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960300,2))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960300.atkcon)
  e2:SetTarget(c99960300.atktg)
  e2:SetOperation(c99960300.atkop)
  c:RegisterEffect(e2)
end
function c99960300.attachfilter1(c)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x996)
end
function c99960300.attchfilter2(c)
  return c:IsType(TYPE_MONSTER)
end
function c99960300.attchtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960300.attachfilter1,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingTarget(c99960300.attchfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960300.attachfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960300.attachop(e,tp,eg,ep,ev,re,r,rp) 
  local tc1=Duel.GetFirstTarget()
  if tc1:IsRelateToEffect(e) and not tc1:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c99960300.attchfilter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 and Duel.Overlay(tc1,g)~=0 then
      local tc2=g:GetFirst()
      local atk=0
      if tc2:IsType(TYPE_XYZ) then
        atk=tc2:GetRank()
      elseif tc2:IsType(TYPE_LINK) then
        atk=tc2:GetLink()
      else
        atk=tc2:GetLevel()
      end
      if atk>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk*300)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc1:RegisterEffect(e1)
      end
    end
  end
  Duel.BreakEffect()
  --(1.1) Special Summon
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetDescription(aux.Stringid(99960300,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetTarget(c99960300.sptg)
  e2:SetOperation(c99960300.spop)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc1:RegisterEffect(e2,true)
  if not tc1:IsType(TYPE_EFFECT) then
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_ADD_TYPE)
    e3:SetValue(TYPE_EFFECT)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc1:RegisterEffect(e3,true)
  end
end
--(1.1) Special Summon
function c99960300.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960300.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if chk==0 then return loc>0 and Duel.IsExistingTarget(c99960300.spfilter,tp,loc,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c99960300.spop(e,tp,eg,ep,ev,re,r,rp)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960300.spfilter),tp,loc,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(2) Gain ATK
function c99960300.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960300.atkfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960300.atkfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x996)
end
function c99960300.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960300.atkfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960300.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local atk=Duel.GetMatchingGroupCount(c99960300.atkfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
  if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and atk>0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetValue(atk*300)
    tc:RegisterEffect(e1)
  end
end