--HN Goddess of Prosperity Black Heart
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  c:EnableReviveLimit()
  --Link Summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x998),2,nil,s.matcheck)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(s.spcon)
  e1:SetTarget(s.sptg)
  e1:SetOperation(s.spop)
  c:RegisterEffect(e1)
  --(2) Indes by battle and no damage
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(s.indtg)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  c:RegisterEffect(e3)
end
--Link Summon
function s.matcheck(g,lc)
  return g:IsExists(s.matfilter,1,nil)
end
function s.matfilter(c)
  return c:IsSetCard(0x998) and aux.IsCodeListed(c,99980060)
end
--(1) Special Summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.spfilter(c,e,tp,zone)
  return c:IsSetCard(0x998) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.spzonefilter(c,e,tp,sc)
  return c:IsSetCard(0x998) and c:IsType(TYPE_LINK)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=0
  local g1=Duel.GetMatchingGroup(s.spzonefilter,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g1) do
    zone=zone | tc:GetLinkedZone()
  end
  zone = zone & 0x1f
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  local zone=0
  local g=Duel.GetMatchingGroup(s.spzonefilter,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    zone=zone | tc:GetLinkedZone()
  end
  zone = zone & 0x1f
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and zone~=0 then 
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Indes by battle and no damage
function s.indtg(e,c)
  local lg=e:GetHandler():GetLinkedGroup()
  return c:IsFaceup() and c:IsSetCard(0x998) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)) and lg:IsContains(c) 
end