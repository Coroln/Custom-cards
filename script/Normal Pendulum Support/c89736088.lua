--Maiden of War
--Script by Coroln and ChatGPT
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum Attribute
	Pendulum.AddProcedure(c)
	--Pendulum Effect 1: Treat Monster Zones as linked zones (Target specific monster zone)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.linkedzone_target)
	e1:SetOperation(s.linkedzone_value)
	c:RegisterEffect(e1)
	--Pendulum Effect 2: ATK Boost for Normal Pendulum Monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.boostfilter)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--Pendulum Effect 3: Restrict Pendulum Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.pscon)
    e3:SetValue(0)
	c:RegisterEffect(e3)
	--Monster Effect 1: ATK Boost during battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--Monster Effect 2: Search and Gain LP
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOEXTRA+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.addtg)
	e5:SetOperation(s.addop)
	c:RegisterEffect(e5)
end
--Pendulum Effect 1: Treat Monster Zones as linked zones (Target specific monster zone)
function s.linkedzone_target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq1=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,0)
	local seq2=Duel.SelectFieldZone(tp,1,0,LOCATION_MZONE,0)
	local seq=seq1|seq2
	Duel.Hint(HINT_ZONE,tp,seq)
	e:SetLabel(seq)
end
function s.linkedzone_value(e,tp,eg,ep,ev,re,r,rp)
	local seq3=e:GetLabel()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(seq3)
    Duel.RegisterEffect(e1,tp)
end
--Pendulum Effect: ATK Boost for Normal Pendulum Monsters
function s.boostfilter(e,c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM)
end
function s.atkval(e,c)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	return g:FilterCount(Card.IsType,nil,TYPE_NORMAL)*100
end
--Pendulum Effect: Restrict Pendulum Summon
function s.pscon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_PZONE,0)
	if g:FilterCount(Card.IsType,nil,TYPE_NORMAL+TYPE_PENDULUM) then
		return false
	end
end
--Monster Effect: ATK Boost during battle
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleMonster(tp)~=nil
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--Monster Effect: Search and Gain LP
function s.addfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT)>0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
