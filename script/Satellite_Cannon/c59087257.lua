--Debris Station
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 2 "Satellite Cannon" from your hand, Deck, or GY, and if you do, they gain 1000 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Fusion Summon 1 Machine Fusion Monster then it gains 3000 ATK if it is "Satellite Laser Balsam"
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.fusiontg)
	e2:SetOperation(s.fusionop)
	c:RegisterEffect(e2)
end
s.listed_names={50400231,100000022}
--Special Summon 2 "Satellite Cannon" from your hand, Deck, or GY, and if you do, they gain 1000 ATK
function s.confilter(c,tp)
	return (c:IsPreviousCodeOnField(50400231) or c:IsPreviousCodeOnField(100000022)) and c:IsPreviousControler(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter,1,nil,tp)
end
function s.spfilter(c,e,tp)
	return c:IsCode(50400231) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
--Fusion Summon 1 Machine Fusion Monster then it gains 3000 ATK if it is "Satellite Laser Balsam"
function s.fusionfilter(c,e,tp)
    if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
    local mg=Duel.GetFusionMaterial(tp)
    mg=mg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
    return c:CheckFusionMaterial(mg,nil,tp)
end
function s.fusiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fusionop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetFusionMaterial(tp)
	local tc=Duel.SelectMatchingCard(tp,s.fusionfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	-- Only use materials from the hand/field
	local mat=mg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	-- Ask EDOPro to perform the Fusion Summon
	if not tc:CheckFusionMaterial(mat,nil,tp) then return end
	local res=Duel.SelectFusionMaterial(tp,tc,mat,nil,tp)
	if res then
		Duel.SetFusionMaterial(res)
		Duel.SendtoGrave(res,REASON_MATERIAL+REASON_FUSION)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		-- Treat both versions of Satellite Laser Balsam identically
		if tc:IsCode(100000022) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(3000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
