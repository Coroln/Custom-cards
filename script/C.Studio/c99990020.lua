--SAO Asuna - SAO
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Gain effect this turn
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetOperation(s.geop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --(2) Change to Face-up Defense Position
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_START)
  e3:SetCost(s.poscost)
  e3:SetTarget(s.postg)
  e3:SetOperation(s.posop)
  c:RegisterEffect(e3)
end
s.listed_names={99990020}
--(1) Gain effect this turn
function s.geop(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Search
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.thtg)
  e1:SetOperation(s.thop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(1.1) Search
function s.thfilter(c)
  return c:IsCode(99990050) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetFirstMatchingCard(s.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
  end
end
--(2) Change to Face-up Defense Position
function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  local d=Duel.GetAttackTarget()
  if chk ==0 then return Duel.GetAttacker()==e:GetHandler() 
  and d and d:IsAttackPos() and d:IsCanChangePosition() end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
  local d=Duel.GetAttackTarget()
  if d:IsRelateToBattle() and d:IsAttackPos() then
    Duel.ChangePosition(d,POS_FACEUP_DEFENSE)
    if d:IsPosition(POS_FACEUP_DEFENSE) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_DEFENSE)
      e1:SetValue(-700)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      d:RegisterEffect(e1)
    end
  end
end