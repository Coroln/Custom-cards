--Overlord Ainz Ooal Gown, The Sorcerer King
--Scripted by Raivost
function c99920010.initial_effect(c)
  c:SetUniqueOnField(1,0,99920010)
  c:EnableReviveLimit()
  --(0) Cannot be Special Summoned
  local e0=Effect.CreateEffect(c)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)
  --(1) Special Summon from hand 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99920010,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99920010.hspcon1)
  e1:SetOperation(c99920010.hspop1)
  c:RegisterEffect(e1)
  --(2) Special Summon from hand 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99920010,1))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99920010.hspcon2)
  c:RegisterEffect(e2)
  --(3) Unaffected
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99920010.unfilter)
  c:RegisterEffect(e3)
  --(4) Activate "Ruler of Death"
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99920010,2))
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetCondition(c99920010.acfcon)
  e4:SetTarget(c99920010.acftg)
  e4:SetOperation(c99920010.acfop)
  c:RegisterEffect(e4)
  --(5) Search
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99920010,3))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetCost(c99920010.thcost)
  e5:SetTarget(c99920010.thtg)
  e5:SetOperation(c99920010.thop)
  c:RegisterEffect(e5)
  --(6) Switch
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99920010,4))
  e6:SetType(EFFECT_TYPE_QUICK_O)
  e6:SetCode(EVENT_FREE_CHAIN)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetTarget(c99920010.swtg)
  e6:SetOperation(c99920010.swop)
  c:RegisterEffect(e6)
  --(7) Special Summon
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99920010,1))
  e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e7:SetType(EFFECT_TYPE_IGNITION)
  e7:SetRange(LOCATION_GRAVE)
  e7:SetTarget(c99920010.sptg)
  e7:SetOperation(c99920010.spop)
  c:RegisterEffect(e7)
  --(8) Gain ATK/DEF
  local e8=Effect.CreateEffect(c)
  e8:SetType(EFFECT_TYPE_SINGLE)
  e8:SetCode(EFFECT_UPDATE_ATTACK)
  e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e8:SetRange(LOCATION_MZONE)
  e8:SetValue(c99920010.atkval)
  c:RegisterEffect(e8)
  local e9=e8:Clone()
  e9:SetCode(EFFECT_UPDATE_DEFENSE)
  e9:SetValue(c99920010.defval)
  c:RegisterEffect(e9)
end
--(1) Special Summon from hand 1
function c99920010.hspcfilter(c)
  return c:IsSetCard(0x992) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c99920010.hspcon1(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local g=Duel.GetMatchingGroup(c99920010.hspcfilter,tp,LOCATION_HAND,0,c)
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>=3
end
function c99920010.hspop1(e,tp,eg,ep,ev,re,r,rp,c)
  local g=Duel.GetMatchingGroup(c99920010.hspcfilter,tp,LOCATION_HAND,0,e:GetHandler())
  if g:GetCount()>=3 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local sg=g:Select(tp,3,3,e:GetHandler())
    Duel.ConfirmCards(1-tp,sg)
    Duel.ShuffleHand(tp)
  end
end
--(2) Special Summon from hand 2
function c99920010.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x992)
end
function c99920010.hspcon2(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99920010.hspconfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
--(3) Unaffected 
function c99920010.unfilter(e,re)
  return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--(4) Activate "Ruler of Death"
function c99920010.acfcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldCard(tp,LOCATION_SZONE,5)==nil
end
function c99920010.acffilter(c,tp)
  return c:IsCode(99920020) and c:GetActivateEffect():IsActivatable(tp)
end
function c99920010.acftg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99920010.acffilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99920010.acfop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local tc=Duel.GetFirstMatchingCard(c99920010.acffilter,tp,LOCATION_DECK,0,nil,tp)
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
end
--(5) Search
function c99920010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99920010.thfilter(c)
  return c:IsSetCard(0xA92) and c:IsAbleToHand()
end
function c99920010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99920010.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99920010.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99920010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(6) Switch
function c99920010.swfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x992) and c:GetSequence()<5
end
function c99920010.swtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99920010.swfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
  and e:GetHandler():GetSequence()<5 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99920010.swop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99920010.swfilter,tp,LOCATION_MZONE,0,1,1,c)
  local tc=g:GetFirst()
  if not (tc or c) then return end
  Duel.HintSelection(g)
  Duel.SwapSequence(tc,c) 
end
--(7) Special Summon
function c99920010.spfilter(c)
  return c:IsSetCard(0x992)
end
function c99920010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) 
  and Duel.IsExistingMatchingCard(c99920010.spfilter,tp,LOCATION_MZONE,0,1,nil) end
  local g=Duel.GetMatchingGroup(c99920010.spfilter,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99920010.spop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99920010.spfilter,tp,LOCATION_MZONE,0,nil)
  if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
  end
end
--(8) Gain ATK/DEF
function c99920010.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x992) and c:GetAttack()>0
end
function c99920010.atkval(e,c)
  local g=Duel.GetMatchingGroup(c99920010.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)  
  local atk=0 
  for tc in aux.Next(g) do
    atk=atk+tc:GetAttack()
  end
  return math.ceil(atk/2)
end
function c99920010.deffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x992) and c:GetDefense()>0 
end
function c99920010.defval(e,c)
  local g=Duel.GetMatchingGroup(c99920010.deffilter,c:GetControler(),LOCATION_MZONE,0,nil)
  local def=0 
  for tc in aux.Next(g) do
    def=def+tc:GetDefense()
  end
  return math.ceil(def/2)
end