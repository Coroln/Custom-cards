--Kaiserwaffe Pumpkin
local s, id = GetID()
function s.initial_effect(c)
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.con)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	-- Loose 500
	local e2=e1:Clone()
	e2:SetCondition(s.tpcon)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	-- halve battledamage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCondition(s.tpcon)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e3)
end
s.listed_series={0x69AA}
s.listed_names={id}
function s.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function s.tpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
