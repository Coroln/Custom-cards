--BRS Black Rock Shooter Despair
--Scripted by Raivost
function c99960090.initial_effect(c)
  c:EnableReviveLimit()
  --Fusion material
  Fusion.AddProcMix(c,true,true,99960010,99960060)
  --Contact fusion
  Fusion.AddContactProc(c,c99960090.contactfil,c99960090.contactop,c99960090.splimit)
  --(1) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960090,0))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99960090.atkcon)
  e2:SetTarget(c99960090.atktg)
  e2:SetOperation(c99960090.atkop)
  c:RegisterEffect(e2)
  --(2) Battle damage as effect damage
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
  c:RegisterEffect(e2)
  --(3) Move to Zone
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960090,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1,99960090)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960090.movecost)
  e3:SetTarget(c99960090.movetg)
  e3:SetOperation(c99960090.moveop)
  c:RegisterEffect(e3)
  --(4) Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960090,4))
  e4:SetCategory(CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1,99960091)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99960090.descost)
  e4:SetTarget(c99960090.destg)
  e4:SetOperation(c99960090.desop)
  c:RegisterEffect(e4)
end
c99960090.material_setcode={0x996}
--Contact fusion
function c99960090.contactfil(tp)
  return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c99960090.contactop(g,tp)
  local rg=Group.CreateGroup()
  for tc in aux.Next(g) do
    if tc:IsFacedown() then
      rg:AddCard(tc)
    end
  end
  Duel.ConfirmCards(1-tp,rg)
  Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c99960090.splimit(e,se,sp,st)
  return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--(1) Gain ATK
function c99960090.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99960090.atkfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996) and c:GetAttack()>0
end
function c99960090.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960090.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960090.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99960090.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetAttack()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    if tc:IsLocation(LOCATION_GRAVE) then
      Duel.BreakEffect()
      Duel.SendtoHand(tc,nil,REASON_EFFECT)
      if tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
      end
    end
  end
end
--(2) Move to Zone
function c99960090.movecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960090.movetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960090.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99960090.moveop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
  Duel.Hint(HINT_SELECTMSG,tp,571)
  local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
  local nseq=math.log(s,2)
  if Duel.MoveSequence(c,nseq)~=0 and Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingMatchingCard(c99960090.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
  and Duel.SelectYesNo(tp,aux.Stringid(99960090,2)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99960090,3))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99960090.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
      Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
      tc:CompleteProcedure()
    end
  end
end
--(4) Destroy
function c99960090.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
function c99960090.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960090.desfilter(c,val)
  return c:IsType(TYPE_MONSTER) and c:GetAttack()<val
end
function c99960090.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local sg=Duel.GetMatchingGroup(c99960090.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetBaseAttack())
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~0 and sg:GetCount()>0 then 
    Duel.Destroy(sg,REASON_EFFECT)
  end
end
