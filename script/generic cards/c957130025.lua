Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Trick Summon
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,99}},{{s.tfilter2,2,99}})

    --Special Summon up to 3 Tokens
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

    --Special summon itself from GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.sscost)
	e2:SetTarget(s.sstg)
	e2:SetOperation(s.ssop)
	c:RegisterEffect(e2)

    --Halve ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)

    --Double ATK
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(s.e4con)
	e4:SetTarget(s.e4tg)
	e4:SetOperation(s.e4op)
	c:RegisterEffect(e4)

    --immune
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(s.e5con)
    e5:SetValue(s.efilter)
    c:RegisterEffect(e5)
end

--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsMonster()
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end

s.listed_names={TOKEN_ADVENTURER,id+1}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,id+1),tp,LOCATION_ONFIELD,0,1,nil)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,1200,1000,3,RACE_FIEND,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=5
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	ft=math.min(ft,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,1200,1000,3,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local i=0
	repeat
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
        --Cannot be used as material for any Special Summon
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_MATERIAL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
        token:RegisterEffect(e1,true)
		ft=ft-1
		i=i+1
	until ft<=0 or i >=3 or not Duel.SelectYesNo(tp,aux.Stringid(id,1))
	Duel.SpecialSummonComplete()
end


--e2

--Tribute 2 monsters as cost
function s.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,3,false,aux.ReleaseCheckMMZ,nil) end
    local g=Duel.SelectReleaseGroupCost(tp,nil,3,3,false,aux.ReleaseCheckMMZ,nil)
    Duel.Release(g,REASON_COST)
end
    --Activation legality
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
    --Special summon itself from GY
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
            local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
            if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then --Destroy 1 of your opponent's cards
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local sg=dg:Select(tp,1,1,nil)
                Duel.HintSelection(sg,true)
                Duel.Destroy(sg,REASON_EFFECT)
            end
        end
    end
end

--e3
function s.e3con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	return c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsReason(REASON_EFFECT) and c:GetMaterialCount()>=4
end
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(function(tc) return tc:IsFaceup() and tc ~= c end,
			tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
end

function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local c = e:GetHandler()
	for tc in g:Iter() do
        if tc~=c then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(tc:GetAttack()/2)
            e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
            tc:RegisterEffect(e1)
        end
	end
end

--e4
function s.e4con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_TRICK) and c:GetMaterialCount()>=5
end
function s.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function s.e4op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in g:Iter() do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		tc:RegisterEffect(e1)
	end
end

--e5
function s.e5con(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_TRICK) and c:GetMaterialCount()>=6
end
--Unaffected by opponent's card effects
function s.efilter(e,re)
    return e:GetOwnerPlayer()==1-re:GetOwnerPlayer()
end