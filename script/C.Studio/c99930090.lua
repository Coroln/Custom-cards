--OTNN Tail Gear Change
--Scripted by Raivost
function c99930090.initial_effect(c)
  c:SetUniqueOnField(1,0,99930090)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99930090,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_SZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCountLimit(1)
  e1:SetTarget(c99930090.sptg)
  e1:SetOperation(c99930090.spop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930090,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99930090.tdcon)
  e2:SetTarget(c99930090.tdtg)
  e2:SetOperation(c99930090.tdop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99930090.spfilter1(c,e,tp)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x993) and Duel.GetLocationCountFromEx(tp,tp,c)>0
  and Duel.IsExistingMatchingCard(c99930090.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
end
function c99930090.spfilter2(c,e,tp,mc,code)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x993) and not c:IsCode(code) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930090.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99930090.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99930090.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99930090.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99930090.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
  local sc=g:GetFirst()
  if sc then
    local mg=tc:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(tc))
    Duel.Overlay(sc,Group.FromCards(tc))
    Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_RANK)
    e1:SetValue(sc:GetOverlayCount())
    e1:SetReset(RESET_EVENT+0x1fe0000)
    sc:RegisterEffect(e1)
  end
end
--(2) Shuffle
function c99930090.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99930090.tdfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c99930090.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local g=Duel.GetMatchingGroup(c99930090.tdfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99930090.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99930090.tdfilter,tp,LOCATION_GRAVE,0,nil)
  if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
    Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
  end
end