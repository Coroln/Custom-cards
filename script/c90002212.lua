--Chrono-Shifters: Time Gate
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=aux.FilterBoolFunction(Card.IsSetCard,0x1AC0),lv=8,extrafil=s.extragroup,extraop=s.extraop,matfilter=s.matfilter,location=LOCATION_HAND|LOCATION_GRAVE,forcedselection=s.ritcheck,specificmatfilter=s.specificfilter,extratg=s.extratg})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(s.ctcost)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end
s.listed_series={0x1AC0}
s.counter_place_list={0x100A}
s.listed_names={id}
--Ritual Summon
function s.extragroup(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.specificfilter(c,rc,mg,tp)
	return mg:IsExists(s.matfilter2,1,nil,c,tp,rc)
end
function s.matfilter2(c,gc,tp,rc)
	if ((c:GetAttribute()|gc:GetAttribute())&(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK))==(ATTRIBUTE_LIGHT|ATTRIBUTE_DARK) and ((c:GetLocation()|gc:GetLocation())&(LOCATION_HAND|LOCATION_DECK))==(LOCATION_HAND|LOCATION_DECK) then
		return Group.FromCards(c,gc):CheckWithSumEqual(Card.GetRitualLevel,8,2,2,rc) 
	end
	return false
end
function s.matfilter(c,e,tp)
	return s.matfilter1(c)
end
function s.matfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsLocation(LOCATION_HAND+LOCATION_DECK) and c:IsAbleToGrave()
end
function s.ritcheck(e,tp,g,sc)
	return #g==2 and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK),#g>2
end
--counter
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1AC0)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x100A)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x100A,1)
	end
end