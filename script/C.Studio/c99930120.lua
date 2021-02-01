--OTNN Field
--Scripted by Raivost
function c99930120.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_FZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(c99930120.atktg)
  e1:SetValue(c99930120.atkval)
  c:RegisterEffect(e1)
  --(2) Attach
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930120,0))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(c99930120.attachcon)
  e2:SetTarget(c99930120.attachtg)
  e2:SetOperation(c99930120.attachop)
  c:RegisterEffect(e2)
  --(3) Move
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99930120,1))
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99930120.movetg)
  e3:SetOperation(c99930120.moveop)
  c:RegisterEffect(e3)
end
--(1) Gain ATK
function c99930120.atktg(e,c)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x993) and c:GetOverlayCount()>0
end
function c99930120.atkval(e,c)
  return c:GetRank()*100
end
--(2) Attach
function c99930120.attachconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x993) and c:GetSummonPlayer()==tp  and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99930120.attachcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99930120.attachconfilter,1,nil,tp)
end
function c99930120.attachfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x993)
end
function c99930120.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99930120.attachfilter,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,RACE_WARRIOR) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99930120.attachfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99930120.attachop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,RACE_WARRIOR)
    if g:GetCount()>0 and Duel.Overlay(tc,g)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
      e1:SetValue(g:GetFirst():GetAttack()/2)
      tc:RegisterEffect(e1)
    end
  end
end
--(3) Move
function c99930120.movefilter(c)
  return c:GetSequence()>=5
end
function c99930120.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99930120.movefilter,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99930120.movefilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99930120.spfilter(c,e,tp)
  return c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99930120.moveop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  if tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    if Duel.MoveSequence(tc,nseq)~=0 and Duel.IsExistingMatchingCard(c99930120.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(99930120,2)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99930120,3))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,c99930120.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
      local tc=g:GetFirst()
	  if tc then
	    Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	    tc:CompleteProcedure()
	  end
    end
  end
end