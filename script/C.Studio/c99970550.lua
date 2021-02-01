--DAL Spirit - Judgement
--Scripted by Raivost
function c99970550.initial_effect(c)
  --Link Summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),2)
  c:EnableReviveLimit()
  --(1) To hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970550,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCondition(c99970550.thcon)
  e1:SetTarget(c99970550.thtg)
  e1:SetOperation(c99970550.thop)
  c:RegisterEffect(e1)
  --(2) Inflict damge
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970550,3))
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99970550.damcon)
  e2:SetTarget(c99970550.damtg)
  e2:SetOperation(c99970550.damop)
  c:RegisterEffect(e2)
  --(3) Indestructable battle/effect
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetCondition(c99970550.indescon)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e4)
  --(4) Special Summon
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970550,4))
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_DESTROYED)
  e5:SetCondition(c99970550.spcon)
  e5:SetTarget(c99970550.sptg)
  e5:SetOperation(c99970550.spop)
  c:RegisterEffect(e5)
end
--(1) To hand
function c99970550.thcon(e,tp,eg,ep,ev,re,r,rp)
  return (re and re:GetHandler():IsSetCard(0x997)) or e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99970550.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
  if chk==0 then return lg:GetCount()>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c99970550.thfilter2(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970550.thop(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
  local rec=0
  if lg:GetCount()>0 then
    for tc in aux.Next(lg) do
      if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
        rec=rec+tc:GetAttack()/2
      end
    end
  end
  if Duel.Recover(tp,rec,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c99970550.thfilter2,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970550,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99970550,2))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99970550.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end   
end
--(2) Inflic damage
function c99970550.damconfilter(c,g)
  return c:IsFaceup() and g:IsContains(c)
end
function c99970550.damcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(c99970550.damconfilter,1,nil,lg)
end
function c99970550.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970550.damop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local lg=c:GetLinkedGroup()
  if not lg then return end
  local dam=0
  local g=eg:Filter(c99970550.damconfilter,nil,lg)
  for tc in aux.Next(g) do
    dam=dam+tc:GetBaseAttack()/2
  end
  Duel.Damage(1-tp,dam,REASON_EFFECT)
end
--(3) Indestructable battle/effect
function c99970550.indesfil(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970550.indescon(e)
  return e:GetHandler():GetLinkedGroup():IsExists(c99970550.indesfil,1,nil)
end
--(4) Special Summon
function c99970550.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970550.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970550.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970550.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970550.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end