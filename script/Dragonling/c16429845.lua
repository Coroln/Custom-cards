--Lord of the Seasons - Spring Dragon
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),3)
	--contact fusion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
--contact fusion
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsRace(RACE_PLANT) and re:IsActiveType(TYPE_MONSTER) and (re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_DECKDES)))
end
function s.matfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_FUSION)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,2,nil)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
--destroy
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local max=math.min(3,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if max<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	local ct=Duel.AnnounceNumber(tp,table.unpack({1,2,3}))
	ct=math.min(ct,max)
	if Duel.SendtoGrave(Duel.GetDecktopGroup(tp,ct),REASON_EFFECT)==ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
