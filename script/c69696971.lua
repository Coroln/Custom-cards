--Kaiserwaffe Pumpkin
local s, id = GetID()
function s.initial_effect(c)
	-- Gain 1000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(s.econ)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	-- Loose 500
	local e2=e1:Clone()
	-- halve battledamage
	e2:SetCondition(s.tpcon)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCondition(s.tpcon)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e3)
end
s.listed_series={0x69AA}
s.listed_names={id}
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function s.tpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()<PHASE_MAIN2
end