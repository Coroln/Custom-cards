--Cyber Oger 3
function c80000019.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,37057012,64268668,true,true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000019.atkcon)
	e1:SetValue(c80000019.atkval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000019,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c80000019.damcon)
	e2:SetTarget(c80000019.damtg)
	e2:SetOperation(c80000019.damop)
	c:RegisterEffect(e2)
end
function c80000019.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function c80000019.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()/2
end
function c80000019.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c80000019.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c80000019.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
