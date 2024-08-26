--Phantom Beast Fusion Shrine
function c53790720.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,nil,c53790720.matfilter,c53790720.fextra,c53790720.extraop)
	c:RegisterEffect(e1)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53790720,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,53790720)
	e2:SetTarget(c53790720.tdtg)
	e2:SetOperation(c53790720.tdop)
	c:RegisterEffect(e2)
end
function c53790720.matfilter(c)
	return (c:IsLocation(LOCATION_HAND) and c:IsAbleToGrave()) or (c:IsOnField() and c:IsAbleToRemove())
end
function c53790720.checkmat(tp,sg,fc)
	return fc:IsSetCard(0x1B) or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c53790720.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil),c53790720.checkmat
	end
	return nil,c53790720.checkmat
end
function c53790720.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_ONFIELD)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function c53790720.thfilter(c)
	return c:IsFaceup() and c:IsCode(5818798) and c:IsAbleToDeck()
end
function c53790720.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c53790720.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c53790720.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c53790720.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c53790720.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end