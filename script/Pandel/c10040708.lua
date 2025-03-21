--Jester Archfiend
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
    --Place 2 "Pandel" or "Archfiend" monsters from your Deck to your Pendulum Zones
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
    --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    --Special Summon 1 Level 4 or lower DARK "Archfiend" monster from your Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --Choose die result for Archfiend dice rolls
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_TOSS_DICE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(s.dicecon)
    e6:SetOperation(s.repop(true,Duel.SetDiceResult,function(tp)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        return Duel.AnnounceNumberRange(tp,1,6)
    end))
    c:RegisterEffect(e6)
end
s.listed_names={id}
s.listed_series={0x45,0x9F1}
--Place 2 "Pandel" or "Archfiend" monsters from your Deck to your Pendulum Zones
function s.pcfilter(c)
	return (c:IsSetCard(0x45) or c:IsSetCard(0x9F1)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
	--Activation legality
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
        local gg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,e:GetHandler())
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,gg,1,tp,0)
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_DECK,0,nil)
    local c=e:GetHandler()
    local pc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    pc:AddCard(e:GetHandler())
    if c:IsRelateToEffect(e) and pc and Duel.Destroy(pc,REASON_COST)==2 then
        if Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
            local pg=aux.SelectUnselectGroup(g,e,tp,2,2,aux.TRUE,1,tp,HINTMSG_TOFIELD)
            if #pg~=2 then return end
            local pc1,pc2=pg:GetFirst(),pg:GetNext()
            if Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
                if Duel.MoveToField(pc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
                    pc2:SetStatus(STATUS_EFFECT_ENABLED,true)
                end
                pc1:SetStatus(STATUS_EFFECT_ENABLED,true)
            end
        end
    end
end
--special summon
function s.spfilter(c)
	return c:IsSetCard(0x45) and c:IsAbleToGraveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,nil,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,c)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_TOGRAVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject():GetFirst()
	if not g then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
    Duel.Damage(tp,g:GetAttack(),REASON_EFFECT)
end
--Special Summon 1 Level 4 or lower DARK "Archfiend" monster from your Deck
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x45) and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
        e2:SetDescription(aux.Stringid(id,2))
        e2:SetReset(RESET_PHASE+PHASE_END)
        e2:SetTargetRange(1,0)
        Duel.RegisterEffect(e2,tp)
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FIEND)
end
--Choose die result for Archfiend dice rolls
function s.dicecon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return rc:IsMonster() and rc:IsSetCard(0x45)
end
function s.repop(isdice,func2,func3)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ResetFlagEffect(ep,id)
		local total=(ev&0xff)+(ev>>16)
		local res={}
		res[1]=func3(ep)
		for i=2,total do
			if isdice then
				table.insert(res,Duel.GetRandomNumber(1,6))
			end
		end
		func2(table.unpack(res))
	end
end