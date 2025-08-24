--Illusory Shadow Moonlight Hunter
local s,id=GetID()
function s.initial_effect(c)

    -- Special Summon from Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH) -- "once per turn this way"
	e1:SetTarget(s.hstg)
	e1:SetOperation(s.hsop)
	c:RegisterEffect(e1)

	--Neither monster can be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indestg)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	-- Set"Shadows in the Mist"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)

	-- Special Summon from GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.gyspcon)
	e4:SetTarget(s.gysptg)
	e4:SetOperation(s.gyspop)
	c:RegisterEffect(e4)

    --destroy self
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.destge5)
	e5:SetOperation(s.desope5)
	c:RegisterEffect(e5)
end
--e1
function s.indestg(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end

function s.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.mz_to_szone_filter(c)
	return c:IsFaceup() and c:IsSetCard(0xBBB) and c:IsMonster()
end

function s.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end

    -- Set Monster in Spell Trap Zone as Continuous Spell if possible
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.mz_to_szone_filter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
	end
end

--e3 Set"Shadows in the Mist" if sent to GY
function s.setfilter(c)
	return c:IsCode(957110014) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--e4 Special Summon if Trap is activated
function s.gyspcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:IsActiveType(TYPE_TRAP) and re:GetHandlerPlayer()==tp then
		local rc=re:GetHandler()
		return rc and rc:IsSetCard(0xBBB)
	end
	return false
end

function s.szone_monster_filter(c,e,tp)
	return c:IsSetCard(0xBBB)
		and c:IsLocation(LOCATION_SZONE)
		and c:IsFaceup()
		and c:IsOriginalType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.gysptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Duel.GetMatchingGroup(s.szone_monster_filter,tp,LOCATION_SZONE,0,nil,e,tp)
		if #g>0 then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
		end
	end
end

function s.gyspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not c or not c:IsRelateToEffect(e))
        or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end

	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.szone_monster_filter,tp,LOCATION_SZONE,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--e5
function s.destge5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desope5(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end