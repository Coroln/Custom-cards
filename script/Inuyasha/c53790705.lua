--Inu - Shippou
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Special summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.hspcon)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCondition(s.drcon)
  e2:SetTarget(s.drtg)
  e2:SetOperation(s.drop)
  c:RegisterEffect(e2)
end
s.listed_series={0x5EB}
s.listed_names={53790700,53790701}
--Special Summon from hand
function s.hspconfilter(c)
  return c:IsFaceup() and c:IsCode(53790700, 53790701)
end
function s.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(s.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--Draw
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
  return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x5EB)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(2)
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
  Duel.BreakEffect()
  if e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToDeck()
  and not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
  end
end