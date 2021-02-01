--BRS Chain Armament
--Scripted by Raivost
function c99960170.initial_effect(c)
  --Equip target
  aux.AddEquipProcedure(c,0,c99960170.eqtfilter,c99960170.eqlimit)
  --((1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960170,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCondition(c99960170.atkcon)
  e1:SetCost(c99960170.atkcost)
  e1:SetTarget(c99960170.atktg)
  e1:SetOperation(c99960170.atkop)
  c:RegisterEffect(e1)
  --(2) Chain attack
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960170,1))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DAMAGE_STEP_END)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1,99960171)
  e2:SetCondition(c99960170.cacon)
  e2:SetCost(c99960170.cacost)
  e2:SetTarget(c99960170.catg)
  e2:SetOperation(c99960170.caop)
  c:RegisterEffect(e2)
  --(3) Equip
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960170,2))
  e3:SetCategory(CATEGORY_EQUIP)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960170.eqcon)
  e3:SetTarget(c99960170.eqtg)
  e3:SetOperation(c99960170.eqop)
  c:RegisterEffect(e3)
  if not c99960170.global_check then
    c99960170.global_check=true
    c99960170[0]=0
    c99960170[1]=0
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
    ge1:SetOperation(c99960170.checkop)
    Duel.RegisterEffect(ge1,0)
    local ge2=Effect.CreateEffect(c)
    ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    ge2:SetOperation(c99960170.clear)
    Duel.RegisterEffect(ge2,0)
  end
end
function c99960170.checkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  if tc:GetFlagEffect(99960170)==0 then
    c99960170[ep]=c99960170[ep]+1
    tc:RegisterFlagEffect(99960170,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
  end
end
function c99960170.clear(e,tp,eg,ep,ev,re,r,rp)
  c99960170[0]=0
  c99960170[1]=0
end
--Equip target
function c99960170.eqlimit(e,c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetControler()==e:GetHandler():GetControler()
end
function c99960170.eqtfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
--(1) Inflict damage
function c99960170.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c99960170.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,100) end
  local lp=Duel.GetLP(tp)
  local ct=math.floor(math.min(lp,1000)/100)
  local t={}
  for i=1,ct do
    t[i]=i*100
  end
  local cost=Duel.AnnounceNumber(tp,table.unpack(t))
  Duel.PayLPCost(tp,cost)
  e:SetLabel(cost)
end
function c99960170.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960170.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  if not tc then return end
  if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(e:GetLabel())
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
    tc:RegisterEffect(e1)
  end
end
--(2) Chain attack
function c99960170.cacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()~=nil
end
function c99960170.cafilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99960170.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.IsExistingMatchingCard(c99960170.cafilter,tp,LOCATION_GRAVE,0,1,nil)
  and (c99960170[tp]==0 or c:GetEquipTarget():GetFlagEffect(99960170)~=0) end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(c99960170.ftarget)
  e1:SetLabel(c:GetEquipTarget():GetFieldID())
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99960170.cafilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99960170.ftarget(e,c)
  return e:GetLabel()~=c:GetFieldID()
end
function c99960170.catg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetEquipTarget():IsChainAttackable(0,true) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99960170.caop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ec=c:GetEquipTarget()
  if not ec:IsRelateToBattle() then return end
  Duel.ChainAttack()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
  ec:RegisterEffect(e1)
end
--(3) Equip
function c99960170.eqcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960170.eqfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960170.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingTarget(c99960170.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  Duel.SelectTarget(tp,c99960170.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99960170.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
    Duel.Equip(tp,c,tc)
  end
end