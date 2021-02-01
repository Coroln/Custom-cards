--BRS The Tiny Bird The Colors
--Scripted by Raivost
function c99960160.initial_effect(c)
  c:SetUniqueOnField(1,0,99960160)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Return to GY
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960160,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCost(c99960160.stzcost)
  e2:SetTarget(c99960160.stztg)
  e2:SetOperation(c99960160.stzop)
  c:RegisterEffect(e2)
  --(2) Indestruct
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3:SetRange(LOCATION_SZONE)
  e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
  e3:SetTarget(c99960160.indfilter)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  --(3) Change cost
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_LPCOST_CHANGE)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetRange(LOCATION_SZONE)
  e4:SetTargetRange(1,0)
  e4:SetValue(c99960160.changecost)
  c:RegisterEffect(e4)
end
function c99960160.stzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c99960160.stzfilter(c,tp)
  return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0x1996) and not c:IsForbidden()
end
function c99960160.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
  and Duel.IsExistingMatchingCard(c99960160.stzfilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960160.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
  if ft>2 then ft=2 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c99960160.stzfilter,tp,LOCATION_DECK,0,1,ft,nil)
  for tc in aux.Next(g) do
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end
--(2) Indestruct
function c99960160.indfilter(e,c)
  return c:IsCode(99960150)
end
--(3) Change chost
function c99960160.changecost(e,re,rp,val)
  if re and re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x996) then
    return val/2
  else
    return val
  end
end