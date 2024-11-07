--Evil Smith's Iron Mine
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Name becomes "Forge of Evil" while on the field on in GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(7581560)
	c:RegisterEffect(e1)
    --Activate send to GY
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
    --atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.tg)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
    --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53274132,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.listed_series={0x467}
--Activate send to GY
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0x467) and c:IsAbleToGrave()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
--atk up
function s.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsMonster() and c:IsLevelBelow(4)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
--
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
    --Cannot Special Summon anywhere bu the GY
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(_,c) return not c:IsLocation(LOCATION_GRAVE) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end