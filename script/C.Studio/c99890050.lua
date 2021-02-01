--Fate Asceded Archer, Emiya Shirou
--Scripted by Raivost
function c99890050.initial_effect(c)
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
  e1:SetDescription(aux.Stringid(99890050,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890050.thtg)
  e1:SetOperation(c99890050.thop)
  c:RegisterEffect(e1)
  --(2) Direct attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_DIRECT_ATTACK)
  c:RegisterEffect(e2)
  --(3) Reduce damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e3:SetCondition(c99890050.rdcon)
  e3:SetOperation(c99890050.rdop)
  c:RegisterEffect(e3)
  --(4) Change position
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99890050,1))
  e4:SetCategory(CATEGORY_POSITION)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(c99890050.postg)
  e4:SetOperation(c99890050.posop)
  c:RegisterEffect(e4)
end
c99890050.listed_names={99890040}
--(1) Search
function c99890050.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890040) and c:IsAbleToHand()
end
function c99890050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890050.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890050.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890050.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(3) Reduce damage
function c99890050.rdcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return ep~=tp and Duel.GetAttackTarget()==nil
  and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c99890050.rdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev/2)
end
--(4) Change position
function c99890050.posfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x989)
end
function c99890050.posfilter2(c)
  return c:IsCanChangePosition()
end
function c99890050.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ct=Duel.GetMatchingGroupCount(c99890050.posfilter1,tp,LOCATION_MZONE,0,e:GetHandler())
  if chk==0 then return Duel.IsExistingTarget(c99890050.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and ct>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectTarget(tp,c99890050.posfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c99890050.posop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local g=tg:Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 then
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
  end
end