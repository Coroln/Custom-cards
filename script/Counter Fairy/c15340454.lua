--Cards of Gratitude
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 Fairy Normal Monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(Cost.Discard(s.spcostfilter,true,2))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_names={id,CARD_SANCTUARY_SKY}
s.listed_series={0x10a}
--Special Summon 1 Fairy Normal Monster
function s.spcostfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_FAIRY) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		--draw
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(s.drtg)
		e1:SetOperation(s.drop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)
		--treat as effect monster
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2,true)
		--remove normal type
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_REMOVE_TYPE)
		e3:SetValue(TYPE_NORMAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e3,true)
		--counter
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_CHAINING)
		e11:SetRange(LOCATION_MZONE)
		e11:SetOperation(s.chop1)
		sc:RegisterEffect(e11,true)
		local e21=Effect.CreateEffect(c)
		e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e21:SetCode(EVENT_CHAIN_SOLVED)
		e21:SetRange(LOCATION_MZONE)
		e21:SetOperation(s.chop2)
		sc:RegisterEffect(e21,true)
		--spsummon 1 "Parshath"
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(id,1))
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_DELAY)
		e4:SetCode(EVENT_CHAIN_END)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCost(Cost.SelfTribute)
		e4:SetCondition(s.spcon)
		e4:SetTarget(s.target)
		e4:SetOperation(s.operation)
		sc:RegisterEffect(e4,true)
		e11:SetLabelObject(e4)
		e21:SetLabelObject(e4)
	end
	Duel.SpecialSummonComplete()
end
--draw
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--counter
function s.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function s.chop2(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_COUNTER) then return end
	e:GetLabelObject():SetLabel(1)
end
--spsummon 1 "Parshath"
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x10a) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local locations=LOCATION_HAND|LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SANCTUARY_SKY),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		locations=locations|LOCATION_DECK
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,locations,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,locations)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local locations=LOCATION_HAND|LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SANCTUARY_SKY),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		locations=locations|LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,locations,0,1,1,nil,e,tp)
	if #g>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end