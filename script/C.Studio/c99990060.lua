--SAO Kirito - ALO B.
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Synchro Summon
  Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,0x999),1,99)
  c:EnableReviveLimit()
  --(1) Equip
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetTarget(s.eqtg)
  e1:SetOperation(s.eqop)
  c:RegisterEffect(e1)
  aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_LEAVE_FIELD_P)
  e2:SetOperation(s.eqcheck)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCountLimit(1,id)
  e3:SetCondition(s.spcon)
  e3:SetCost(s.spcost)
  e3:SetTarget(s.sptg)
  e3:SetOperation(s.spop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
end
s.listed_names={99990010}
--(1) Equip
function s.eqval(ec,c,tp)
  return ec:IsControler(tp) and c:IsSetCard(0x1999)
end
function s.eqfilter(c)
  return c:IsSetCard(0x1999) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.equipop(c,e,tp,tc)
  aux.EquipByEffectAndLimitRegister(c,e,tp,tc,nil,true)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,c)
  local tc=g:GetFirst()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    s.equipop(c,e,tp,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
  else 
    Duel.SendtoGrave(tc,REASON_EFFECT) 
  end
end
--(2) Special Summon
function s.eqcheck(e,tp,eg,ep,ev,re,r,rp)
  if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
  local g=e:GetHandler():GetEquipGroup()
  g:KeepAlive()
  e:SetLabelObject(g)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1999,1,REASON_COST) end
  Duel.RemoveCounter(tp,1,0,0x1999,1,REASON_COST)
end
function s.spfilter(c,e,tp)
  return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) 
  and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=e:GetLabelObject():GetLabelObject()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and g:IsExists(s.spfilter,1,nil,e,tp) and not Duel.IsEnvironment(47355498) end
  local sg=g:Filter(s.spfilter,nil,e,tp)
  Duel.SetTargetCard(sg)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.spfilter,nil,e,tp)
  if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    g=g:Select(tp,1,1,nil)
    Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
end
