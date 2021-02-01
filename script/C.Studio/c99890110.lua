--Fate Ascended Shielder, Mashu Kyrieligh
--Scripted by Raivost
function c99890110.initial_effect(c)
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
  e1:SetDescription(aux.Stringid(99890110,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890110.thtg)
  e1:SetOperation(c99890110.thop)
  c:RegisterEffect(e1)
  --(3) destroy replace
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetCode(EFFECT_DESTROY_REPLACE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99890110.dreptg)
  c:RegisterEffect(e2)
  --(3) Cannot attack
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(0,LOCATION_MZONE)
  e3:SetValue(c99890110.atlimit)
  c:RegisterEffect(e3)
end
c99890110.listed_names={99890100}
--(1) Search
function c99890110.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890100) and c:IsAbleToHand()
end
function c99890110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890110.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890110.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890110.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Destroy replace
function c99890110.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) and Duel.CheckLPCost(tp,500) end
  if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
    local c=e:GetHandler()
    Duel.PayLPCost(tp,500)
    return true
  else return false end
end
--(3) Cannot attack
function c99890110.atlimit(e,c)
  return c:IsFaceup() and c:IsSetCard(0x989) and c~=e:GetHandler()
end