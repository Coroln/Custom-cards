--DERZimmermann
--Script by: Coroln
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--summon with 5 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,5,5)
	local e2=aux.AddNormalSetProcedure(c)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--summon success (restrict effects)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(s.sumsuc)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4a)
	local e4b=e4:Clone()
	e4b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4b)
    --immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
    --summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	--Special summon procedure (from hand or GY)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e7:SetCondition(s.spcon)
	e7:SetCost(s.spcost)
	e7:SetTarget(s.sptg)
	e7:SetOperation(s.spop)
	c:RegisterEffect(e7)
	if not s.global_check then
		s.global_check=true
		s.init_globals()
	end
	--Special summon a 3000< ATK monster
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e9:SetTarget(s.psptg)
	e9:SetOperation(s.pspop)
	c:RegisterEffect(e9)
	--Increase its own ATK
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_UPDATE_ATTACK)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(s.atkcon)
	e10:SetValue(s.adval)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e11)
	--ATK check
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(id)
	c:RegisterEffect(e12)
	--cannot release
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_UNRELEASABLE_SUM)
	e13:SetCondition(s.atkconcon)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e14)
	--Trick matlimit
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetCondition(s.atkconconcon)
	e15:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_TRICK))
	c:RegisterEffect(e15)
	--send to grave
	local e16=Effect.CreateEffect(c)
	e16:SetCategory(CATEGORY_TOGRAVE)
	e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e16:SetCode(EVENT_ATTACK_ANNOUNCE)
	e16:SetRange(LOCATION_MZONE)
	e16:SetTarget(s.destg)
	e16:SetOperation(s.desop)
	c:RegisterEffect(e16)
end
s.listed_names={id}
s.listed_series={0x4879}
--
function s.conconfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>=3000
end
function s.atkconcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.conconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.conconconfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>=3000
end
function s.atkconconcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.conconconfilter,tp,LOCATION_MZONE,0,1,nil)
end
--summon success (restrict effects)
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
--immune
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--Special summon procedure (from hand or GY)
function s.init_globals()
	-- reset every turn
	local ge0=Effect.GlobalEffect()
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ge0:SetOperation(function()
		s.destroyed_this_turn=false
		s.banished_this_turn=false
		s.drawn_this_turn=false
		s.extra_summoned_this_turn=false
		s.damage_this_turn=false
	end)
	Duel.RegisterEffect(ge0,0)
	-- a card destroyed
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_DESTROYED)
	ge1:SetOperation(function() s.destroyed_this_turn=true end)
	Duel.RegisterEffect(ge1,0)
	-- a card banished
	local ge2=Effect.GlobalEffect()
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_REMOVE)
	ge2:SetOperation(function() s.banished_this_turn=true end)
	Duel.RegisterEffect(ge2,0)
	-- a card drawn (but not during Draw Phase)
	local ge3=Effect.GlobalEffect()
	ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge3:SetCode(EVENT_DRAW)
	ge3:SetOperation(function(_,tp,eg,ep,ev,re,r,rp)
		if Duel.GetCurrentPhase()~=PHASE_DRAW then
			s.drawn_this_turn=true
		end
	end)
	Duel.RegisterEffect(ge3,0)
	-- summon from Extra Deck
	local ge4=Effect.GlobalEffect()
	ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge4:SetOperation(function(_,tp,eg,ep,ev,re,r,rp)
		if eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA) then
			s.extra_summoned_this_turn=true
		end
	end)
	Duel.RegisterEffect(ge4,0)
	-- damage taken
	local ge5=Effect.GlobalEffect()
	ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge5:SetCode(EVENT_DAMAGE)
	ge5:SetOperation(function() s.damage_this_turn=true end)
	Duel.RegisterEffect(ge5,0)
end
-- Special Summon condition
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	-- check banished "Hypercosmic"
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0x4879),tp,LOCATION_REMOVED,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct>=7
		and s.destroyed_this_turn
		and s.banished_this_turn
		and s.drawn_this_turn
		and s.extra_summoned_this_turn
		and s.damage_this_turn
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,13)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==13 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
--Special summon a 3000< ATK monster
function s.filter(c,e,tp)
	return c:IsAttackAbove(3000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA)
end
function s.pspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
--Increase its own ATK
function s.confilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>=3000
end
function s.atkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsMonster() and c:GetAttack()~=0 and not c:IsHasEffect(id)
end
function s.adval(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then 
		return 0
	else
		local val=g:GetSum(Card.GetAttack)
		return val
	end
end
--send to grave
function s.desfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) 
		and Duel.GetMatchingGroupCount(s.desfilter,tp,LOCATION_MZONE,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_RULE,PLAYER_NONE,1-tp)
	end
end