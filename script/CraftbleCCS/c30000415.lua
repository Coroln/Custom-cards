local s,id=GetID()
function s.initial_effect(c)
	--Toss a coin and Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
s.toss_coin=true
function s.spchkfilter(c,e,sp,tg_p)
	return Duel.GetLocationCount(tg_p,LOCATION_MZONE,sp)>0 and c:IsCanBeSpecialSummoned(e,1,sp,false,false,POS_FACEUP,tg_p)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return s.spchkfilter(c,e,tp,tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==COIN_HEADS then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsMonster()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not s.condition1(e,tp) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(s.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CountHeads(Duel.TossCoin(tp,1))==1 then
	Duel.NegateEffect(ev)
	end
end