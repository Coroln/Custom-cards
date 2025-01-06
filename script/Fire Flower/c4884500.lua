--Ashes of the World Tree
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Send cards from the Deck to the GY with a total Levels equal to or lower than the destroyed monster's Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
end
--Send cards from the Deck to the GY with a total Levels equal to or lower than the destroyed monster's Level
function s.desfilter(c,tp)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:HasLevel()
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function s.tgfilter(c,lv)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsMonster() and c:IsLevelBelow(lv) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.rescon(lv)
	return function(sg,e,tp,mg)
		return sg:GetSum(Card.GetLevel)<=lv 
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local lv=tc:GetLevel()
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil,lv)
		local sg=aux.SelectUnselectGroup(g,e,tp,1,lv,s.rescon(lv),1,tp,HINTMSG_TOGRAVE,s.rescon(lv))
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end