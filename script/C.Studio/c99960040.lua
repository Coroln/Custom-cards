--BRS Chariot
--Scripted by Raivost
function c99960040.initial_effect(c)
  --Xyz Summon
  Xyz.AddProcedure(c,nil,4,2)
  c:EnableReviveLimit()
 --(1) Attach
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960040,0))
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c99960040.attachcon)
  e1:SetTarget(c99960040.attachtg)
  e1:SetOperation(c99960040.attachop)
  c:RegisterEffect(e1)
  --(2) Battle damage as effect damage
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
  c:RegisterEffect(e2)
  --(3) Move to Zone
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960040,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1,99960040)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960040.movecost)
  e3:SetTarget(c99960040.movetg)
  e3:SetOperation(c99960040.moveop)
  c:RegisterEffect(e3)
  --(4) Equip
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960040,4))
  e4:SetCategory(CATEGORY_EQUIP)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99960040.eqcost)
  e4:SetTarget(c99960040.eqtg)
  e4:SetOperation(c99960040.eqop)
  c:RegisterEffect(e4,false,1)
end
--(1) Attach
function c99960040.attachcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x996) and not (e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
  and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and re:GetHandler()==e:GetHandler())
end
function c99960040.attachfilter(c)
  return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c99960040.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960040.attachfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=Duel.SelectTarget(tp,c99960040.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99960040.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
    Duel.Overlay(c,Group.FromCards(tc))
  end
end
--(3) Move to Zone
function c99960040.movecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960040.movetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960040.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99960040.moveop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
  Duel.Hint(HINT_SELECTMSG,tp,571)
  local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
  local nseq=math.log(s,2)
  if Duel.MoveSequence(c,nseq)~=0 and Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingMatchingCard(c99960040.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
  and Duel.SelectYesNo(tp,aux.Stringid(99960040,2)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99960040,3))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99960040.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
      Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
      tc:CompleteProcedure()
    end
  end
end
--(4) Special Summon
function c99960040.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
  and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960040.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c99960040.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  if not Duel.Equip(tp,tc,c,false) then return end
  --(3.1) Equip limit
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(c99960040.eqlimit)
  tc:RegisterEffect(e1)
  end
end
--(3.1) Equip limit
function c99960040.eqlimit(e,c)
  return e:GetOwner()==c
end
