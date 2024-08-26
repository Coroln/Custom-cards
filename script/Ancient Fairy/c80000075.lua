--Anike Feenquelle
function c80000075.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up (1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c80000075.tg)
	e2:SetValue(c80000075.val)
	c:RegisterEffect(e2)
	--effect (2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000075,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c80000075.effcon)
	e3:SetTarget(c80000075.efftg)
	e3:SetOperation(c80000075.effop)
	c:RegisterEffect(e3)
end
--(1)
function c80000075.tg(e,c)
	return c:IsCode(25862681) or c:IsCode(4179255)
end
function c80000075.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x2c9c)
end
function c80000075.val(e,c)
	return Duel.GetMatchingGroupCount(c80000075.filter,c:GetControler(),LOCATION_GRAVE,0,nil,nil)*500
end
--(2)
function c80000075.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(POS_FACEUP)
end
function c80000075.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=0
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	if b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(80000075,1),aux.Stringid(80000075,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(80000075,2))
	else opt=1 end
	e:SetLabel(opt)
	if opt==0 then
	e:SetCategory(CATEGORY_HANDES)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function c80000075.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		local g=Duel.GetFieldGroup(p,LOCATION_HAND,0):RandomSelect(p,d)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
