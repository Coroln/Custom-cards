--Miroku
function c53790702.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53790702.spcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c53790702.valcon)
	c:RegisterEffect(e2)
	--(3) Gain ATK/DEF
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(53790702,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c53790702.atkcon)
    e3:SetTarget(c53790702.atktg)
    e3:SetOperation(c53790702.atkop)
    c:RegisterEffect(e3)
end
function c53790702.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5EB) and not c:IsCode(53790702)
end
function c53790702.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53790702.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c53790702.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
--(3) Gain ATK/DEF
function c53790702.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank()) 
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink())
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x5EB) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c53790702.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790702.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end