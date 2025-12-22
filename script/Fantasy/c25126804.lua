--Fantasy Magic: Spellbook
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0xFF)
    --Activate search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --Remove counter replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_RCOUNTER_REPLACE+0xFF)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.rcon)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(s.desreptg)
	e6:SetOperation(s.desrepop)
	c:RegisterEffect(e6)
	--Add counter2
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetRange(LOCATION_FZONE)
	e7:SetOperation(s.addop2)
	c:RegisterEffect(e7)
end
s.listed_series={0xFA14}
s.counter_place_list={0xFF}
--Activate search
function s.thfilter(c)
	return c:IsSetCard(0xFA14) and c:IsMonster() and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--add counter
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(aux.FaceupFilter(Card.IsCanAddCounter,0xFF,1,false,LOCATION_MZONE),1,nil) then
		e:GetHandler():AddCounter(0xFF,1)
	end
end
--Remove counter replace
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (r&REASON_COST)~=0 and re:IsActivated() and ep==e:GetOwnerPlayer() and c:GetCounter(0xFF)>=ev
		and re:GetHandler()~=c
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xFF,ev,REASON_EFFECT)
end
--Destroy replace
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and e:GetHandler():GetCounter(0xFF)>1 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xFF,2,REASON_EFFECT)
end
--Add counter2
function s.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	for c in aux.Next(eg) do
		if not c:IsCode(id) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0xFF)
		end
	end
	if count>0 then
		e:GetHandler():AddCounter(0xFF,count)
	end
end
