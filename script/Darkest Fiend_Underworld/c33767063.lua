--Darkest Castle from the Underworld
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Activate (search)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --Special Summon Fiend Synchro
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.syntg)
    e2:SetOperation(s.synop)
    c:RegisterEffect(e2)
    --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--defup
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
s.listed_names={id}
--Activate (search)
function s.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
--Special Summon Fiend Synchro
function s.tuner_filter(c)
    return c:IsMonster() and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function s.nontuner_filter(c)
    return c:IsMonster() and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.nontuner_filter,tp,LOCATION_HAND,0,1,nil) -- 1 from Hand
            and Duel.IsExistingMatchingCard(s.tuner_filter,tp,LOCATION_GRAVE,0,1,nil) -- At least 1 Tuner from GY
            and Duel.GetLocationCountFromEx(tp)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.synop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    
    -- Select 1 non-Tuner from the hand (MANDATORY)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local hand_mon=Duel.SelectMatchingCard(tp,s.nontuner_filter,tp,LOCATION_HAND,0,1,1,nil)
    if #hand_mon==0 then return end -- If selection fails, stop

    -- Select at least 1 monster from the GY (MANDATORY, must include a Tuner)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local gy_tuner=Duel.SelectMatchingCard(tp,s.tuner_filter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #gy_tuner==0 then return end -- If no Tuner is selected, stop

    -- Select additional non-Tuners from the GY (OPTIONAL, at least 0, up to 99)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local gy_nontuner=Duel.SelectMatchingCard(tp,s.nontuner_filter,tp,LOCATION_GRAVE,0,0,99,nil) -- 0 or more

    -- Combine selected cards
    local banish_group=Group.FromCards(hand_mon:GetFirst(),gy_tuner:GetFirst())
    banish_group:Merge(gy_nontuner)

    -- Banish them
    if Duel.Remove(banish_group,POS_FACEUP,REASON_EFFECT)~=banish_group:GetCount() then return end

    -- Calculate total Level
    local lv_sum=hand_mon:GetFirst():GetLevel() + gy_tuner:GetFirst():GetLevel()
    for tc in aux.Next(gy_nontuner) do
        lv_sum=lv_sum+tc:GetLevel()
    end

    -- Find a matching Synchro Monster in the Extra Deck
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local synchro=Duel.SelectMatchingCard(tp,s.synchro_filter,tp,LOCATION_EXTRA,0,1,1,nil,lv_sum,e,tp)
    if #synchro>0 then
        Duel.SpecialSummon(synchro,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
        synchro:GetFirst():CompleteProcedure()
    end
end

function s.synchro_filter(c,lv,e,tp)
    return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FIEND) and c:IsLevel(lv) 
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
