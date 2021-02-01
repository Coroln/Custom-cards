--Fate Ascended Saber, Artoria Pendragon
--Scripted by Raivost
function c99890030.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon condition
  local e0=Effect.CreateEffect(c)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  e0:SetValue(aux.FALSE)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99890030,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_LEAVE_FIELD)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99890030.thtg)
  e1:SetOperation(c99890030.thop)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
   local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetCondition(c99890030.atkcon)
  e2:SetTarget(c99890030.atktg)
  e2:SetValue(500)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
  --(3) Indes by Spell
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetTarget(c99890030.indestg)
  e4:SetValue(c99890030.indesval)
  c:RegisterEffect(e4)
end
c99890030.listed_names={99890020}
--(1) Search
function c99890030.thfilter(c)
  return c:IsSetCard(0x989) and bit.band(c:GetType(),0x81)==0x81 and not c:IsCode(99890020) and c:IsAbleToHand()
end
function c99890030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99890030.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99890030.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99890030.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Gain ATK/DEF
function c99890030.atkcon(e)
  return e:GetHandler():IsAttackPos()
end
function c99890030.atktg(e,c)
  return c:IsSetCard(0x989) and c~=e:GetHandler()
end
--(3) Indes by Spell
function c99890030.indestg(e,c)
  return c:IsSetCard(0x989)
end
function c99890030.indesval(e,re,r,rp)
  if bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_SPELL) then
    return 1
  else return 0 end
end