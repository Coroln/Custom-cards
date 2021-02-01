--Fate Ascended Rider, Medusa
--Scripted by Raivost
function c99890070.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon condition
  local e0=Effect.CreateEffect(c)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  e0:SetValue(aux.FALSE)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890070,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890070.thtg)
  e1:SetOperation(c99890070.thop)
  c:RegisterEffect(e1)
  --(2) Negate
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_DISABLE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(0,LOCATION_MZONE)
  e2:SetCondition(c99890070.negcon)
  e2:SetTarget(c99890070.negtg)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890070,1))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTarget(c99890070.atktg)
  e3:SetOperation(c99890070.atkop)
  c:RegisterEffect(e3)
end
c99890070.listed_names={99890060}
--(1) Search
function c99890070.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890060) and c:IsAbleToHand()
end
function c99890070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890070.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890070.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890070.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Negate
function c99890070.negcon(e)
  local c=e:GetHandler()
  return Duel.GetAttacker()==c and c:GetBattleTarget()
  and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c99890070.negtg(e,c)
  return c==e:GetHandler():GetBattleTarget()
end
--(3) Gain ATK
function c99890070.atkfilter(c,tp)
  return c:GetOwner()==1-tp and c:IsType(TYPE_MONSTER)
end
function c99890070.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  local d1=eg:FilterCount(c99890070.atkfilter,nil,tp)
  if chk==0 then return d1>0 end
end
function c99890070.atkop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99890070)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(400)
  e:GetHandler():RegisterEffect(e1)
end