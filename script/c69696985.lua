-- 69696985	Göttliches Incursio
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,aux.FilterBoolFunction(Card.IsLevel,6),2)
	--cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Your "Kaiserwaffe" monsters cannot be destroyed once during each opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(_,c) return c:IsFaceup() end)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--skip draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.damcon)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
s.listed_series={0x69AC}
s.listed_names={id}

function s.matfilter(c,fc,sumtype,tp)
	return c:GetSequence()>4 and c:IsLocation(LOCATION_MZONE) and (c:IsControler(tp) or c:IsFaceup())
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup()) and c:IsCard(69696986)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
end
function s.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function s.indval(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if bc and bc:IsRelateToEffect(e) and Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
	end
end