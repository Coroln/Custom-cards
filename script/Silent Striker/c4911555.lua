--Silent Striker Bircord
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.condition)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
s.listed_series={0x132F}
s.listed_names={id}
--atk up
function s.condition(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function s.atkval(e,c)
	if not Duel.GetFieldCard(c:GetControler(),LOCATION_PZONE,1) then return end
	local tc=Duel.GetFieldCard(c:GetControler(),LOCATION_PZONE,1)
	return tc:GetRightScale()*100
end
--Attack twice
function s.condition2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
end
function s.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x132F) and c:IsDestructable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil) and Duel.IsExistingTarget(s.costfilter,tp,LOCATION_ONFIELD,0,2,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)>=2 then
    	local g=Duel.SelectTarget(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.Destroy(g,REASON_COST)
	else
		local g=Duel.SelectTarget(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
		Duel.Destroy(g,REASON_COST)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x132F) and c:IsMonster() and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end