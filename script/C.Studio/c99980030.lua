--HN Planeptune Nation
--Scripted by Raivost
function c99980030.initial_effect(c)
  c:SetUniqueOnField(1,0,99980030)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(c99980030.thop)
  c:RegisterEffect(e1)
  --(2) Gain ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980030,2))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(c99980030.atkcon)
  e2:SetTarget(c99980030.atktg)
  e2:SetOperation(c99980030.atkop)
  c:RegisterEffect(e2)
end
c99980030.listed_names={99980030}
--(1) Search
function c99980030.thfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x998) and c:IsAbleToHand()
end
function c99980030.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(c99980030.thfilter,tp,LOCATION_DECK,0,nil)
  if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99980030,0)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980030,1))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
  end
end
--(2) Gain ATK
function c99980030.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  local bc=Duel.GetAttackTarget()
  if not bc then return false end
  if tc:IsControler(1-tp) then bc,tc=tc,bc end
  return bc:IsFaceup() and tc:IsFaceup() and tc:IsSetCard(0x998) and tc:IsType(TYPE_XYZ)
end
function c99980030.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980030.atkop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetAttacker()
  if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
  if tc:IsFaceup() and tc:IsRelateToBattle() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetBaseAttack()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
    tc:RegisterEffect(e1)
  end
end