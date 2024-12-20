local s,id=GetID()
function s.initial_effect(c)
	--Fusion materials
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
    --change name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(80516007)
	c:RegisterEffect(e2)
	--ATK UP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(function(e) return Duel.GetMatchingGroupCount(Card.IsNonEffectMonster,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)>=3 end)
	e3:SetTarget(s.atktg)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	--Destruction replacement
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	c:RegisterEffect(e4)
end
s.listed_names={01641882,80516007}
--e3
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsRace(RACE_BEAST,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsType(TYPE_FUSION) and c:GetLevel()<=3
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_FISH,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WATER,fc,sumtype,tp) and c:GetLevel()<=3
end

function s.atktg(e,c)
	return c:IsCode(01641882) or c:IsCode(80516007)
end
function s.val(e,c)
	return c:GetAttack()*2
end
--e4
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetTarget() ~= e:GetHandler()
end
function s.repfilter(c,Struct)
	return c:IsFaceup() and c:IsControler(Struct.s_tp) and c:IsLocation(LOCATION_MZONE)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) and c ~= Struct.s_e:GetHandler()
end
function s.repcfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsMonster() and c:IsAbleToRemove()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local Struct =
	{
		s_tp = tp,
		s_e = e
	}
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,Struct)--tp
		and Duel.IsExistingMatchingCard(s.repcfilter,tp,LOCATION_GRAVE,0,1,nil) end --tp
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function s.repval(e,c)
	local Struct =
	{
		s_tp = e:GetHandlerPlayer(),
		s_e = e
	}
	return s.repfilter(c,Struct)
end