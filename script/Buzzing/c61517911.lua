--Royal Insect on the Royal Throne
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_INSECT)
	e3:SetCondition(s.con)
	e3:SetTarget(s.tg)
	c:RegisterEffect(e3)
	--id chk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(id)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_CUSTOM+id)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(s.ctop)
	c:RegisterEffect(e5)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROY)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
	--summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(s.cost)
	e6:SetTarget(s.nstg)
	e6:SetOperation(s.nsop)
	c:RegisterEffect(e6)
	--Remove 2 Honey Counter on your Standby Phase or destroy this card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
end
s.listed_names={id,61517904}
s.counter_list={0x1BEE}
--increase ATK
function s.atkval(e,c)
	return Duel.GetCounter(1,1,1,0x1BEE)*100
end
--race
function s.confilter(c)
	return c:IsCode(61517904) and c:IsFaceup()
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.tg(e,c)
	if c:GetFlagEffect(1)==0 then
		c:RegisterFlagEffect(1,0,0,0)
		local eff
		if c:IsLocation(LOCATION_MZONE) then
			eff={Duel.GetPlayerEffect(c:GetControler(),EFFECT_NECRO_VALLEY)}
		else
			eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
		end
		c:ResetFlagEffect(1)
		for _,te in ipairs(eff) do
			local op=te:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	return true
end
function s.val(e,c,re,chk)
	if chk==0 then return true end
	return RACE_INSECT
end
--counter
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local total=0
    local g=Group.CreateGroup()
    for tc in aux.Next(eg) do
        if tc:IsRace(RACE_INSECT) and tc:GetLevel()>0 then
            total=total+tc:GetLevel()
            g:AddCard(tc)
        end
    end
    if total>0 then
        Duel.RaiseEvent(g,EVENT_CUSTOM+id,re,r,rp,tp,total)
    end
end
function s.qfilter(c)
    return c:IsFaceup() and c:IsCode(61517904)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local total=ev
    if total<=0 then return end
    local g=Duel.GetMatchingGroup(s.qfilter,tp,LOCATION_SZONE,0,nil)
    if #g==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tc=g:Select(tp,1,1,nil):GetFirst()
    tc:AddCounter(0x1BEE,total)
end
--summon
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil,e,tp,1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return a or b end
	if b and g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,5,REASON_COST) and Duel.IsPlayerCanDraw(tp,2) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			if #g==1 then
				g:GetFirst():RemoveCounter(tp,0x1BEE,5,REASON_COST)
				e:SetLabel(1)
			else
				local ct=0
				while ct<5 do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
					local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
					tc:RemoveCounter(tp,0x1BEE,1,REASON_COST)
					ct=ct+1
				end
				e:SetLabel(1)
			end
		end
	else
		e:SetLabel(0)
	end
end
function s.costfilter(c)
	return c:IsCode(61517904)
end
function s.nsfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsSummonable(true,nil)
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	if e:GetLabel()==1 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
--Remove 2 Honey Counter on your Standby Phase or destroy this card
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,2,REASON_COST) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			if #g==1 then
				g:GetFirst():RemoveCounter(tp,0x1BEE,2,REASON_COST)
			else
				local ct=0
				while ct<2 do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
					local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
					tc:RemoveCounter(tp,0x1BEE,1,REASON_COST)
					ct=ct+1
				end
			end
		end
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
