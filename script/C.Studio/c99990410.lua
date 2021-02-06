--SAO Asuna - OS
--Scripted by Raivost
local s,id=GetID()
function s.initial_effect(c)
  --Link Summon
  Link.AddProcedure(c,s.linkmatfilter,2,2)
  c:EnableReviveLimit()
  --(1) Gain effect this turn
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(s.gecon)
  e1:SetOperation(s.geop)
  c:RegisterEffect(e1)
  --(2) Place Counter
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_COUNTER)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(s.pctcon)
  e2:SetTarget(s.pcttg)
  e2:SetOperation(s.pctop)
  c:RegisterEffect(e2)
end
s.listed_names={99990020}
--Link Summon
function s.linkmatfilter(c,lc,sumtype,tp)
  return c:IsSetCard(0x999,lc,sumtype,tp) and not c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
--(1) Gain effect this turn
function s.gecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
  --(1.1) Excavate
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.excatg)
  e1:SetOperation(s.excaop)
  e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
--(1.1) Excavate
function s.excafilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetLink()>0
end
function s.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local lg=Duel.GetMatchingGroup(s.excafilter,tp,LOCATION_MZONE,0,nil)
  local ct=lg:GetSum(Card.GetLink)
  if chk==0 then 
    if ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
    local g=Duel.GetDecktopGroup(tp,ct)
    return g:FilterCount(Card.IsAbleToHand,nil)>0
  end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.thfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function s.excaop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local lg=Duel.GetMatchingGroup(s.excafilter,tp,LOCATION_MZONE,0,nil)
  local ct=lg:GetSum(Card.GetLink)
  if ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
  Duel.ConfirmDecktop(p,ct)
  local g=Duel.GetDecktopGroup(p,ct)
  if g:GetCount()>0 then
    local sg=g:Filter(s.thfilter,nil)
    if sg:GetCount()>0 then
      if sg:GetFirst():IsAbleToHand() then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-p,sg)
        Duel.ShuffleHand(p)
        g:Sub(sg)
      else
        Duel.SendtoGrave(sg,REASON_EFFECT)
      end
    end
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REVEAL)
  end
end
--(2) Place Counter
function s.pctcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ec=eg:GetFirst()
  local bc=ec:GetBattleTarget()
  return ec:IsControler(tp) and (ec==c or ec==c:GetLinkedGroup():GetFirst()) and bc 
  and bc:IsType(TYPE_MONSTER) and ec:IsStatus(STATUS_OPPO_BATTLE)
end
function s.pcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0x999) end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
end
function s.pctop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
  if tc and tc:IsFaceup() and tc:IsSetCard(0x999) then
    tc:AddCounter(0x1999,1)
  end
end
