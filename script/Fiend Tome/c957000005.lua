--An Spirit Eater's Fiend Tome of Desire
local s,id=GetID()
function s.initial_effect(c)
    --Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
    e1:SetCost(Cost.PayLP(1000))
	e1:SetTarget(s.tge1)
	e1:SetOperation(s.ope1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tge2)
	e2:SetOperation(s.ope2)
	c:RegisterEffect(e2)
    --Activate
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,id)
    e3:SetCost(s.coste3)
	e3:SetTarget(s.tge3)
	e3:SetOperation(s.ope3)
	c:RegisterEffect(e3)
end
local SET_SPIRIT_EATER = 0xAAA
local SET_FIEND_TOME = 0xAAB
s.listed_series={SET_SPIRIT_EATER,SET_FIEND_TOME}
--e1
function s.tge1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(SET_SPIRIT_EATER) or c:IsSetCard(SET_FIEND_TOME) and not c:IsCode(id)
end
function s.ope1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
--2
function s.tgfilter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_DECK,0,1,nil,lv)
end
function s.tgfilter2(c,lv)
	return c:IsMonster() and c:IsSetCard(SET_SPIRIT_EATER) and not c:IsLevel(lv) and c:IsAbleToGrave()
end
function s.spfilter1(c,tp)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(SET_SPIRIT_EATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tge2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter1(chkc,tp)
	end
    if chk==0 then return Duel.IsExistingTarget(s.tgfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
    e:SetCategory(CATEGORY_TOGRAVE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,s.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.ope2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
    if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
        and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local lv=g:GetFirst():GetLevel()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(lv)
        e1:SetReset(RESETS_STANDARD_PHASE_END)
        tc:RegisterEffect(e1)
    end
end
--e3
function s.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function s.coste3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.filtere3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tge3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filtere3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filtere3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filtere3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.ope3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end