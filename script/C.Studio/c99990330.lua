--SAO Journey's End
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(s.accost)
  e1:SetTarget(s.actg)
  e1:SetOperation(s.acop)
  c:RegisterEffect(e1)
end
function s.accostfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsCanRemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  local b2=Duel.IsExistingMatchingCard(s.accostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
  if chk==0 then return b1 or b2 end
  if b1 and ((not b2) or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
    Duel.RemoveCounter(tp,1,0,0x1999,2,REASON_COST)
  else
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.accostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
  end
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return s.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
  or s.drtg(e,tp,eg,ep,ev,re,r,rp,chk) end
  if s.sptg(e,tp,eg,ep,ev,re,r,rp,0) and s.drtg(e,tp,eg,ep,ev,re,r,rp,0) then
    local opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
    if opt==0 then
      e:SetCategory(CATEGORY_SPECIAL_SUMMON)
      s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    else
      e:SetCategory(CATEGORY_DRAW)
      s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    end
    e:SetLabel(opt+1)
  elseif s.sptg(e,tp,eg,ep,ev,re,r,rp,0) then
    Duel.SelectOption(tp,aux.Stringid(id,1))
    s.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
    e:SetLabel(1)
    e:SetCategory(CATEGORY_SPECIAL_SUMMON)
  else
    Duel.SelectOption(tp,aux.Stringid(id,2))
    s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(2)
    e:SetCategory(CATEGORY_DRAW)
  end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetLabel()==1 then
    s.spop(e,tp,eg,ep,ev,re,r,rp)
  elseif e:GetLabel()==2 then
    s.drop(e,tp,eg,ep,ev,re,r,rp)
  end
end
--(1.1) Special Summmon
function s.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCountFromEx(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
    --(1.1.1) Destroy
    local fid=e:GetHandler():GetFieldID()
    tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1,fid)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetLabel(fid)
    e1:SetLabelObject(tc)
    e1:SetCondition(s.descon)
    e1:SetOperation(s.desop)
    Duel.RegisterEffect(e1,tp)
  end
end
--(1.1.1) Destroy
function s.descon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffectLabel(id)==e:GetLabel() then
    return true
  else
    e:Reset()
    return false
  end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.Destroy(tc,REASON_EFFECT)
end
--(1.2) Draw
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(2)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end