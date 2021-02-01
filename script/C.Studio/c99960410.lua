--BRS Farside Bunny, Arcana's Moon
--Scripted by Raivost
function c99960410.initial_effect(c)
  c:EnableReviveLimit()
  --Link Summon
  aux.AddLinkProcedure(c,nil,2,nil,c99960410.matcheck)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960410,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,99960410)
  e1:SetTarget(c99960410.thtg)
  e1:SetOperation(c99960410.tgop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960410,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,99960411)
  e2:SetCost(c99960410.spcost)
  e2:SetTarget(c99960410.sptg)
  e2:SetOperation(c99960410.spop)
  c:RegisterEffect(e2)
  --(3) Battle damage as effect damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
  c:RegisterEffect(e3)
  --(4) Cannot Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99960410,2))
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1,99960412)
  e4:SetCost(c99960410.csscost)
  e4:SetTarget(c99960410.csstg)
  e4:SetOperation(c99960410.cssop)
  c:RegisterEffect(e4)
end
--Link Summon
function c99960410.matcheck(g,lc,tp)
  return g:IsExists(Card.IsLinkSetCard,1,nil,0x996)
end
--(1) Search
function c99960410.thfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99960410.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960410.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960410.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960410.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Special Summon
function c99960410.spcostfilter(c)
  return c:GetLevel()==4 and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGraveAsCost()    
end
function c99960410.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.IsExistingMatchingCard(c99960410.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.PayLPCost(tp,500)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99960410.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99960410.spfilter(c,e,tp,zone)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99960410.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local zone=e:GetHandler():GetLinkedZone(tp)
    return zone~=0 and Duel.IsExistingMatchingCard(c99960410.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960410.spop(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if zone==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960410.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
  local tc=g:GetFirst()
  if tc then
    Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
    tc:CompleteProcedure()
  end
end
--(4) Cannot Special Summon
function c99960410.csscostfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGraveAsCost()    
end
function c99960410.csscost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.IsExistingMatchingCard(c99960410.csscostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
  Duel.PayLPCost(tp,500)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99960410.csscostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99960410.csstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
  local rc=Duel.AnnounceAttribute(tp,1,0xffff)
  e:SetLabel(rc)
end
function c99960410.cssop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetLabel(e:GetLabel())
  e1:SetTargetRange(0,1)
  e1:SetTarget(c99960410.sumlimit)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function c99960410.sumlimit(e,c,sump,sumtype,sumpos,targetp)
  return c:IsAttribute(e:GetLabel()) and c:IsLocation(LOCATION_EXTRA)
end