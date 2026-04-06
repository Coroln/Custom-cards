--Buzzing Flor
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--place Honey Counter/ revive
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(s.cost)
	e1:SetOperation(s.addc1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(s.addct)
	e4:SetOperation(s.addc)
	c:RegisterEffect(e4)
end
s.listed_series={0xBEE}
s.listed_names={id,61517904}
s.counter_list={0x1BEE}
--place Honey Counter/ revive
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,0)
	local b=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,1)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return a or b end
	if #g==0 then
		e:SetLabel(0)
	else
		if b and g:GetFirst():IsCanRemoveCounter(tp,0x1BEE,1,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				if #g==1 then
					g:GetFirst():RemoveCounter(tp,0x1BEE,1,REASON_COST)
					e:SetLabel(1)
				else
					local ct=0
					while ct<1 do
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
end
function s.costfilter(c)
	return c:IsCode(61517904)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xBEE) and c:IsMonster() and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.addc1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,1) then
		local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0x1BEE,2)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--counter
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1BEE)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,1) then
		local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0x1BEE,1)
	end
end
