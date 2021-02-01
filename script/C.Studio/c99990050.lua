--SAO Yui
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --(1) Special summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetCountLimit(1,id)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.hspcon)
  c:RegisterEffect(e1)
  --(2) Tuner OR Level 4
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetTarget(s.tnlvtg)
  e2:SetOperation(s.tnlvop)
  c:RegisterEffect(e2)
end
--(1) Special Summon from hand
function s.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and (aux.IsCodeListed(c,99990010) or aux.IsCodeListed(c,99990020))
end
function s.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(s.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--(2) Tuner OR Level 4
function s.tnlvtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=true
  local b2=not e:GetHandler():IsLevel(4)
  if chk==0 then return b1 or b2 end
  if b1 and ((not b2) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
    e:SetLabel(1)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
  else
    e:SetLabel(0)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
  end
end
function s.tnlvop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if e:GetLabel()==0 and c:IsRelateToEffect(e) then
  	local e1=Effect.CreateEffect(c)
  	e1:SetType(EFFECT_TYPE_SINGLE)
  	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  	e1:SetCode(EFFECT_ADD_TYPE)
  	e1:SetValue(TYPE_TUNER)
  	e1:SetReset(RESET_EVENT+0x1fe0000)
  	c:RegisterEffect(e1)
  elseif e:GetLabel()==1 and c:IsRelateToEffect(e) and c:IsFaceup() then
  	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
  end
end