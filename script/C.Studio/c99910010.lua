--YuYuYu Ritual Spell
--Scripted by Raivost
function c99910010.initial_effect(c)
  --(1) Special Summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99910010,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99910010.sptg)
  e1:SetOperation(c99910010.spop)
  c:RegisterEffect(e1)
   if not c99910010.global_check then
    c99910010.global_check=true
    c99910010[0]=0
    c99910010[1]=0
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CUSTOM+99910010)
    e3:SetOperation(c99910010.addcount)
    Duel.RegisterEffect(e3,0)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CUSTOM+99910011)
    e4:SetOperation(c99910010.addcount1)
    Duel.RegisterEffect(e4,0)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_CUSTOM+99910012)
    e5:SetOperation(c99910010.addcount2)
    Duel.RegisterEffect(e5,0)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e6:SetOperation(c99910010.clearop)
    Duel.RegisterEffect(e6,0)
  end
end
--(1) Special Summon 1
function c99910010.spfilter(c,e,tp)
  return c:IsSetCard(0x991) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c99910010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99910010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99910010.tgfilter(c)
  return c:IsSetCard(0x991) and c:IsRace(RACE_FAIRY) and c:IsAbleToGrave()
end
function c99910010.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local tg=Duel.SelectMatchingCard(tp,c99910010.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  local tc=tg:GetFirst()
  local mat=Group.CreateGroup()
  if tc then
    local b1=Duel.IsEnvironment(99910070) and Duel.IsExistingMatchingCard(c99910010.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c99910010.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) 
    if b1 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
      local g=Duel.SelectMatchingCard(tp,c99910010.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,0,2,nil)
      mat:Merge(g)
    elseif b2 then
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
      local g=Duel.SelectMatchingCard(tp,c99910010.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,0,2,nil)
      mat:Merge(g)
    end
    tc:SetMaterial(mat)
    Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
    Duel.BreakEffect()
    Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
    tc:CompleteProcedure()
    if Duel.GetFlagEffect(tp,99910010)==0 then
      Duel.RegisterFlagEffect(tp,99910010,RESET_PHASE+PHASE_END,0,1)
      --(1.1) Lose LP
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetCountLimit(1)
      e1:SetReset(RESET_PHASE+PHASE_END)
      e1:SetOperation(c99910010.loseop)
      Duel.RegisterEffect(e1,tp)
    end
    if mat:GetCount()==2 then
      Duel.RaiseEvent(tc,EVENT_CUSTOM+99910012,e,0,tp,0,0)
    elseif mat:GetCount()==1 then
      Duel.RaiseEvent(tc,EVENT_CUSTOM+99910011,e,0,tp,0,0)
    else
      Duel.RaiseEvent(tc,EVENT_CUSTOM+99910010,e,0,tp,0,0)
    end
  end
end
--(1.1) Lose LP
function c99910010.loseop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99910010)
  Duel.SetLP(tp,Duel.GetLP(tp)-c99910010[tp])
end
--Counter
function c99910010.addcount(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    local p=tc:GetReasonPlayer()
    c99910010[p]=c99910010[p]+1000
    tc=eg:GetNext()
  end
end
function c99910010.addcount1(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    local p=tc:GetReasonPlayer()
    c99910010[p]=c99910010[p]+500
    tc=eg:GetNext()
  end
end
function c99910010.addcount2(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
    local p=tc:GetReasonPlayer()
    c99910010[p]=c99910010[p]+0
    tc=eg:GetNext()
  end
end
function c99910010.clearop(e,tp,eg,ep,ev,re,r,rp)
  c99910010[0]=0
  c99910010[1]=0
end