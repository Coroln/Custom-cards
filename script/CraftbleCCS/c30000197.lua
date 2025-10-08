--フュージョン・ゲート
--Fusion Gate
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(Fusion.SummonEffTG(nil,Card.IsAbleToRemove,s.fextra,Fusion.BanishMaterial))
	e2:SetOperation(Fusion.SummonEffOP(nil,Card.IsAbleToRemove,s.fextra,Fusion.BanishMaterial))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function s.fextra2(e,tp,mg)
	return Duel.GetDecktopGroup(tp,5)
end
function s.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,m)
	return c:IsFusionSummonableCard() and c:CheckFusionMaterial(m)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local mg=g:Filter(s.filter1,c,e)
	local fusparams={handler=c,fusfilter=nil,matfilter=aux.FALSE,extrafil=s.fextra2,extraop=nil,extratg=nil}
		Fusion.SummonEffOP(fusparams)(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
end