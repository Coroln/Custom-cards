--BRS Bird of Orange Smiles
--Scripted by Raivost
function c99960100.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetDescription(aux.Stringid(99960100,0))
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960100,1))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,99960100)
  e1:SetCost(c99960100.drcost)
  e1:SetTarget(c99960100.drtg)
  e1:SetOperation(c99960100.drop)
  c:RegisterEffect(e1)
  --(2) Attach
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960100,2))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99960100.mattg)
  e2:SetOperation(c99960100.matop)
  c:RegisterEffect(e2)
end
--(1) Search
function c99960100.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsPublic() and c:IsAbleToDeck() end
  Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c99960100.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99960100.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
--(2) Attach
function c99960100.matfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c99960100.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99960100.matfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99960100.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960100.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Overlay(tc,Group.FromCards(c))
  end
end