--Fate Rousing Resolution
--Scripted by Raivost
function c99890150.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890150,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCountLimit(1,99890150+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99890150.spcon)
  e1:SetTarget(c99890150.sptg)
  e1:SetOperation(c99890150.spop)
  c:RegisterEffect(e1)
  --(2) Activate in hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetCondition(c99890150.handcon)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99890150.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp)
end
function c99890150.spfilter(c,e,tp)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c99890150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99890150.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99890150.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99890150.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_DEFENSE)>0 then 
    tc:RegisterFlagEffect(99890150,RESET_EVENT+0x1fe0000,0,1,Duel.GetTurnCount())
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetLabelObject(tc)
    e1:SetCondition(c99890150.tdcon)
    e1:SetOperation(c99890150.tdop)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
    e1:SetCountLimit(1)
    Duel.RegisterEffect(e1,tp)
    local a=Duel.GetAttacker()
    if tc:IsSetCard(0xF19) and Duel.NegateAttack() then
      Duel.Damage(1-tp,math.ceil(a:GetAttack()/2),REASON_EFFECT)
    else
      local ag=a:GetAttackableTarget()
      if a:IsAttackable() and not a:IsImmuneToEffect(e) and ag:IsContains(tc) then
        Duel.BreakEffect()
        Duel.ChangeAttackTarget(tc)
      end
    end
  end
end
function c99890150.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  return Duel.GetTurnCount()==e:GetLabel() and tc:GetFlagEffectLabel(99890150)==e:GetLabel()
end
function c99890150.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.Hint(HINT_CARD,0,99890150)
  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
--(2) Activate in hand
function c99890150.handfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x989)
end
function c99890150.handcon(e)
  return not Duel.IsExistingMatchingCard(c99890150.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end