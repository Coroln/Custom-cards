--HN Lastation Nation
--Scripted by Raivost
function c99980080.initial_effect(c)
  c:SetUniqueOnField(1,0,99980080)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(c99980080.thop)
  c:RegisterEffect(e1)
  --(2) Return to hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980080,2))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DAMAGE_STEP_END)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(c99980080.rthcon)
  e2:SetTarget(c99980080.rthtg)
  e2:SetOperation(c99980080.rthop)
  c:RegisterEffect(e2)
end
c99980080.listed_names={99980030}
--(1) Search
function c99980080.thfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x998) and c:IsAbleToHand()
end
function c99980080.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(c99980080.thfilter,tp,LOCATION_DECK,0,nil)
  if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99980080,0)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980080,1))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
  end
end
--(2) Return to hand
function c99980080.rthcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return end
  if d:IsControler(tp) then
    e:SetLabelObject(a)
    return d:IsSetCard(0x998) and d:IsType(TYPE_XYZ) and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
  elseif a:IsControler(tp) then
    e:SetLabelObject(d)
    return a:IsSetCard(0x998) and a:IsType(TYPE_XYZ) and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
  end
  return false
end
function c99980080.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980080.rthop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=e:GetLabelObject()
  if tc:IsRelateToBattle() then
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end