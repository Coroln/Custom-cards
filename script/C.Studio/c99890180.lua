--Fate Ascended Lancer, Cu Chulainn
--Scripted by Raivost
function c99890180.initial_effect(c)
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
  e1:SetDescription(aux.Stringid(99890180,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890180.thtg)
  e1:SetOperation(c99890180.thop)
  c:RegisterEffect(e1)
  --(2) Destroy 
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99890180,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetTarget(c99890180.destg)
  e2:SetOperation(c99890180.desop)
  c:RegisterEffect(e2)
  --(3) Discard
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99890180,2))
  e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_ATTACK_ANNOUNCE)
  e3:SetTarget(c99890180.distg)
  e3:SetOperation(c99890180.disop)
  c:RegisterEffect(e3)
end
c99890180.listed_names={99890170}
--(1) Search
function c99890180.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890170) and c:IsAbleToHand()
end
function c99890180.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890180.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890180.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890180.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Destroy
function c99890180.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  local d=Duel.GetAttackTarget()
  if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c99890180.desop(e,tp,eg,ep,ev,re,r,rp)
  local d=Duel.GetAttackTarget()
  if d~=nil and d:IsRelateToBattle() and d:IsDefensePos() then
    Duel.Destroy(d,REASON_EFFECT)
  end
end
--(3) Discard
function c99890180.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99890180.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
    local sg=g:RandomSelect(1-tp,1)
    Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
    local tc=sg:GetFirst()
    if tc:IsType(TYPE_MONSTER) and Duel.IsPlayerCanDraw(tp,1)
    and Duel.SelectYesNo(tp,aux.Stringid(99890180,3)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99890180,4))
      Duel.Draw(tp,1,REASON_EFFECT)
    end
  end
end