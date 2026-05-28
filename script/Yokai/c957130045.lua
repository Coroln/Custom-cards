local s,id=GetID()
function s.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--Gain 400 ATK for each banished Yokai monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

	--Piercing damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)

	--If an attack is declared involving this card: change the other monster to Defense Position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.poscon)
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4)

	--If this card inflicts battle damage: banish 1 Yokai monster from your GY
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id+100)
	e5:SetCondition(s.bancon)
	e5:SetTarget(s.bantg)
	e5:SetOperation(s.banop)
	c:RegisterEffect(e5)

	--All monsters you control lose 400 ATK while this card is in your GY.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetValue(-400)
	c:RegisterEffect(e6)

	--While this card is in your GY: Discard 1 card; banish this card from your GY.
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,{id,3})
	e7:SetCost(Cost.Discard())
	e7:SetOperation(s.rmop)
	c:RegisterEffect(e7)

	--All monsters you control lose 400 DEF while this card is banished.
	local e8=e6:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetRange(LOCATION_REMOVED)
	e8:SetValue(-400)
	c:RegisterEffect(e8)

end

function s.spfilter(c)
	return c:IsRace(RACE_YOKAI) and c:IsAbleToRemoveAsCost()
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,2,nil)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end


--ATK gain based on banished Yokai monsters
function s.atkval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(s.yokaifilterBanished,tp,LOCATION_REMOVED,0,nil)
	return ct*400
end


--Attack declared involving this card
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a==c and d~=nil) or d==c
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then return tc~=nil and tc:IsCanChangePosition() end
	Duel.SetTargetCard(tc)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToBattle() and tc:IsCanChangePosition() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end

--If this card inflicts battle damage
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.yokaifilterGY,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end

function s.banop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.yokaifilterGY,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--e7
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
