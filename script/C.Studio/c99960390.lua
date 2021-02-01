--BRS Golden Reach
--Scripted by Raivost
function c99960390.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960390,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960390+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99960390.acttg)
  e1:SetOperation(c99960390.actop)
  c:RegisterEffect(e1)
  if c99960390.counter==nil then
    c99960390.counter=true
    c99960390[0]=0
    c99960390[1]=0
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e2:SetOperation(c99960390.resetcount)
    Duel.RegisterEffect(e2,0)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_PAY_LPCOST)
    e3:SetOperation(c99960390.addcount)
    Duel.RegisterEffect(e3,0)
  end
end
function c99960390.resetcount(e,tp,eg,ep,ev,re,r,rp)
  c99960390[0]=0
  c99960390[1]=0
end
function c99960390.addcount(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetTurnPlayer()
  if ep==p and re and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:GetHandler():IsSetCard(0x996) then
    local val=math.ceil(ev/2)
    c99960390[p]=c99960390[p]+val
  end
end
--(1) Activate
function c99960390.actfilter(c,tp)
  return c:IsCode(99960150) and c:GetActivateEffect():IsActivatable(tp)
end
function c99960390.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960390.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960390.actop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99960390.actfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
  if tc then
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if fc then
      Duel.SendtoGrave(fc,REASON_RULE)
      Duel.BreakEffect()
    end
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local te=tc:GetActivateEffect()
    local tep=tc:GetControler()
    local cost=te:GetCost()
    if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
    Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
  end
  --(1.1) Gain LP
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetOperation(c99960390.recop)
  Duel.RegisterEffect(e1,tp)
end
--(1.1) Gain LP
function c99960390.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960390)
  Duel.Recover(tp,c99960390[tp],REASON_EFFECT)
end