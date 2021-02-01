--SAO Guns And Swords
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_DAMAGE_STEP_END)
  e1:SetCountLimit(1,id+1)
  e1:SetCondition(s.spcon)
  e1:SetTarget(s.sptg)
  e1:SetOperation(s.spop)
  c:RegisterEffect(e1)
  --(2) Return to Extra
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,id+1)
  e2:SetCost(s.texcost)
  e2:SetTarget(s.textg)
  e2:SetOperation(s.texop)
  c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if a:IsStatus(STATUS_OPPO_BATTLE) and d:IsControler(tp) then a,d=d,a end
  if a:IsSetCard(0x999) and not a:IsType(TYPE_XYZ) then
    e:SetLabelObject(a)
    return true
  else return false end
end
function s.spfilter(c,e,tp,mc)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x999) and mc:IsCanBeXyzMaterial(c,tp)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tc=e:GetLabelObject()
  if chk==0 then return tc:IsFaceup() and tc:IsCanBeEffectTarget(e) and tc:IsRelateToBattle()
  and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc)
  and Duel.GetLocationCountFromEx(tp,tp,tc)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetTargetCard(tc)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) 
  or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
  local sc=g:GetFirst()
  if sc then
    local mg=tc:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(tc))
    Duel.Overlay(sc,Group.FromCards(tc))
    Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
    sc:CompleteProcedure()
  end
end
--(2) Return to Extra
function s.texcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.exccon(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST)  end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.texfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToExtra()
end
function s.thfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsAbleToHand()
end
function s.textg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(s.texfilter,tp,LOCATION_GRAVE,0,1,nil) 
  and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,s.texfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.texop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end