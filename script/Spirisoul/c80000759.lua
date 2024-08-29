--Spirisoul's Revitalizing Spirit
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--During your Main Phase, you can Normal Summon 1 Spirit in addition to your Normal Summon/Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND|LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) return c:IsType(TYPE_SPIRIT) end)
	c:RegisterEffect(e1)
   --Gain LP (extra handling from Ghost Sister & Spooky Dogwood 儚無みずき)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.recop1)
	c:RegisterEffect(e2)
end
s.listed_names={0x356}
--gain LP
function s.cfilter(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return #eg==1 and tc:IsPreviousControler(tp) and tc:IsPreviousLocation(LOCATION_MZONE)
		and (tc:GetType())~=TYPE_SPIRIT
		and tc:IsPreviousPosition(POS_FACEUP) and tc:GetOriginalAttack()>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return #eg==1 and ec:IsPreviousLocation(LOCATION_ONFIELD) and ec:GetOriginalAttack()>0 and ec:IsMonster() and ec:IsType(TYPE_SPIRIT)
end
function s.sum(c)
	local ec=eg:GetFirst()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ec:GetOriginalAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ec:GetOriginalAttack())
end
function s.recop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
