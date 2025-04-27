--Spark Glove
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end
--destroy
function s.descostfilter(c)
	return c:IsType(TYPE_UNION) and c:IsMonster() and c:IsDiscardable()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.descostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sc=Duel.SelectMatchingCard(tp,s.descostfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(sc,REASON_COST|REASON_DISCARD)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsFaceup() and bc:IsSpecialSummoned() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetEquipTarget():GetBattleTarget(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
--equip
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetEquipTarget():IsType(TYPE_UNION) or e:GetHandler():GetEquipTarget():IsType(TYPE_NORMAL))
end
function s.eqfilter(c)
	return c:IsType(TYPE_UNION) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and ec:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if not tc or not Duel.Equip(tp,tc,ec,true) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
		aux.SetUnionState(tc)
	end
end
function s.splimit(e,c)
	return c:IsCode(e:GetLabel())
end