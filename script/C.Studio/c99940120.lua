--NGNL Hatsuse Izuna
--Scripted by Raivost
function c99940120.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Scale change
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DICE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99940120.sccon)
  e1:SetTarget(c99940120.sctg)
  e1:SetOperation(c99940120.scop)
  c:RegisterEffect(e1)
  --(2) Cannot set
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_MSET)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTargetRange(0,1)
  e2:SetTarget(aux.TRUE)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_CANNOT_SSET)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EFFECT_CANNOT_TURN_SET)
  c:RegisterEffect(e4)
  local e5=e2:Clone()
  e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e5:SetTarget(c99940120.csetlimit)
  c:RegisterEffect(e5)
  --(3) Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99940120,2))
  e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e6:SetCode(EVENT_DRAW)
  e6:SetRange(LOCATION_PZONE)
  e6:SetCondition(c99940120.spcon)
  e6:SetTarget(c99940120.sptg)
  e6:SetOperation(c99940120.spop)
  c:RegisterEffect(e6)
  --Monster Effects
  --(1) Special Summon from hand
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_FIELD)
  e7:SetCode(EFFECT_SPSUMMON_PROC)
  e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e7:SetRange(LOCATION_HAND)
  e7:SetCondition(c99940120.hspcon)
  c:RegisterEffect(e7)
  --(2) Shuffle 1
  local e8=Effect.CreateEffect(c)
  e8:SetDescription(aux.Stringid(99940120,3))
  e8:SetCategory(CATEGORY_TODECK)
  e8:SetType(EFFECT_TYPE_QUICK_O)
  e8:SetCode(EVENT_FREE_CHAIN)
  e8:SetRange(LOCATION_MZONE)
  e8:SetCountLimit(1)
  e8:SetCondition(c99940120.tdcon1)
  e8:SetTarget(c99940120.tdtg1)
  e8:SetOperation(c99940120.tdop1)
  c:RegisterEffect(e8)
  --(3) Shuffle 2
  local e9=Effect.CreateEffect(c)
  e9:SetDescription(aux.Stringid(99940120,3))
  e9:SetCategory(CATEGORY_TODECK)
  e9:SetType(EFFECT_TYPE_QUICK_O)
  e9:SetCode(EVENT_FREE_CHAIN)
  e9:SetRange(LOCATION_MZONE)
  e9:SetCountLimit(1)
  e9:SetCondition(c99940120.tdcon2)
  e9:SetTarget(c99940120.tdtg2)
  e9:SetOperation(c99940120.tdop2)
  c:RegisterEffect(e9)
  --(4) Avoid battle damage
  local e10=Effect.CreateEffect(c)
  e10:SetType(EFFECT_TYPE_SINGLE)
  e10:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e10:SetValue(1)
  c:RegisterEffect(e10)
end
--Pendulum Effects
--(1) Scale Change
function c99940120.sccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99940120.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  op=Duel.SelectOption(tp,aux.Stringid(99940120,0),aux.Stringid(99940120,1))
  e:SetLabel(op)
  if op==0 then
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
  else
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
  end
end
function c99940120.scop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if e:GetLabel()==0 then
    local dc=Duel.TossDice(tp,1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(dc)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  else
    local d1,d2=Duel.TossDice(tp,2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(d1+d2)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
  end
end
--(2) Cannot set
function c99940120.csetlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
--(3) Special Summon
function c99940120.spcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940120.spfilter(c,e,tp)
	return c:IsSetCard(0x994) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end   
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if chk==0 then return loc>0 and Duel.IsExistingMatchingCard(c99940120.spfilter,tp,loc,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c99940120.spop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99940120.spfilter,tp,loc,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--Monster Effects
--(1) Special Summon from hand
function c99940120.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
--(2) Shuffle 1
function c99940120.tdcon1(e)
  return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0x994)
end
function c99940120.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return e:GetHandler():IsAbleToDeck()
  and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_MZONE)
end
function c99940120.tdop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 then
  	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  	local sg=g:Select(tp,1,1,nil)
    Duel.HintSelection(sg)
  	if c:IsRelateToEffect(e) and sg then
  	  local sg=Group.FromCards(c,sg:GetFirst())
  	  Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
  	end
  end
end
--(3) Shuffle 2
function c99940120.tdcon2(e)
  return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0x994)
end
function c99940120.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return e:GetHandler():IsAbleToDeck()
  and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_MZONE)
end
function c99940120.tdop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,1,2,nil)
    Duel.HintSelection(sg)
    if c:IsRelateToEffect(e) and sg then
   	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT,true)
  	Duel.SendtoDeck(c,nil,2,REASON_EFFECT,true)
  	Duel.RDComplete()
  	end
  end
end