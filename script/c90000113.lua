--Alkdrache Bond der Martini
local s,id=GetID()
function s.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_series={0x14EC}
--tohand
function s.thfilter(c)
	return (c:IsCode(6853254) or c:IsCode(90173539) or c:IsCode(28596933) or c:IsCode(22007085) or c:IsCode(34995106) or c:IsCode(39701395) 
	or c:IsCode(41620959) or c:IsCode(43973174) or c:IsCode(46382143) or c:IsCode(48800175) or c:IsCode(55991637) or c:IsCode(61606250) 
	or c:IsCode(71867500) or c:IsCode(72549351) or c:IsCode(81385346) or c:IsCode(89181369) or c:IsCode(90887783) or c:IsCode(100100011) 
	or c:IsCode(100100039) or c:IsCode(100100061) or c:IsCode(100100083) or c:IsCode(511000351) or c:IsCode(511000354) or c:IsCode(511000360) 
	or c:IsCode(511000361) or c:IsCode(511000441) or c:IsCode(511001100) or c:IsCode(511001340) or c:IsCode(511001362) or c:IsCode(511001631) 
	or c:IsCode(511002256) or c:IsCode(511002419) or c:IsCode(511002572) or c:IsCode(27770341) or c:IsCode(66156348) or c:IsCode(89450409) 
	or c:IsCode(95697223) or c:IsCode(140000075) or c:IsCode(504700049) or c:IsCode(511000352) or c:IsCode(511000353) or c:IsCode(511000357) 
	or c:IsCode(511000358) or c:IsCode(511001578) or c:IsCode(511009144) or c:IsCode(365213) or c:IsCode(16960351) or c:IsCode(69868555) 
	or c:IsCode(85590798) or c:IsCode(87571563) or c:IsCode(99659159) or c:IsCode(511000808) or c:IsCode(511009330) or c:IsCode(1435851) 
	or c:IsCode(25231813) or c:IsCode(39049051) or c:IsCode(61405855) or c:IsCode(269510) or c:IsCode(2106266) or c:IsCode(50186558) 
	or c:IsCode(58406094) or c:IsCode(62265044) or c:IsCode(511600022) or c:IsCode(32437102) or c:IsCode(63300440) or c:IsCode(60004971) 
	or c:IsCode(511000355) or c:IsCode(511000416) or c:IsCode(511008025) or c:IsCode(511002914) or c:IsCode(810000089) or c:IsCode(90000125) 
	or c:IsCode(90000126) or c:IsCode(90000123) or c:IsCode(90000124)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end