--DAL Rasiel - Tome of Revelation
--Scripted by Raivost
function c99970240.initial_effect(c)
  --(1) Copy Effect
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970240,7))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970240+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970240.cetg)
  e1:SetOperation(c99970240.ceop)
  c:RegisterEffect(e1)
end
--(1) Copy Effect
function c99970240.cefilter(c)
  return c:IsSetCard(0x997) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToRemove()
  and not c:IsCode(99970240) and c:CheckActivateEffect(false,true,false)~=nil
end
function c99970240.thfilter(c)
  return c:IsSetCard(0x997) and not c:IsSetCard(0x1A97) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970240.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
  if chk==0 then return g:GetCount()>0 end
end
function c99970240.ceop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
  if g:GetCount()==0 then return end
  local tc=g:RandomSelect(tp,1):GetFirst()
  Duel.ConfirmCards(tp,tc)
  local ct=0
  if tc:IsType(TYPE_FUSION) then ct=ct+TYPE_FUSION 
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,0))
  end
  if tc:IsType(TYPE_SYNCHRO) then ct=ct+TYPE_SYNCHRO 
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,1))
  end
  if tc:IsType(TYPE_XYZ) then ct=ct+TYPE_XYZ 
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,2))
  end
  if tc:IsType(TYPE_PENDULUM) then ct=ct+TYPE_PENDULUM 
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,3))
  end
  if tc:IsType(TYPE_LINK) then ct=ct+TYPE_LINK 
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,4))
  end
  if ct then
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetLabel(ct)
    e2:SetTargetRange(0,1)
    e2:SetTarget(c99970240.sumlimit)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,tp)
  end
  if Duel.IsExistingMatchingCard(c99970240.cefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970240,5)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970240,6))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c99970240.cefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    local bantg=g:GetFirst()
    if not bantg or Duel.Remove(bantg,POS_FACEUP,REASON_EFFECT)==0 then return end
    g:GetFirst():CreateEffectRelation(e)
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    local te=e:GetLabelObject()
    if not te then return end
    if not te:GetHandler():IsRelateToEffect(e) then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
  end
end
function c99970240.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:IsType(e:GetLabel())
end