--インフィニティ・ダーク
--Infinity Dark
local s,id=GetID()
function s.initial_effect(c)
	Gemini.AddProcedure(c)
	--Change battle position of 1 face-up monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E|TIMING_MAIN_END)
	e2:SetCondition(s.poscon)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsGeminiStatus() and tp==Duel.GetTurnPlayer()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,tp,POS_FACEDOWN_DEFENSE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.setmfilter(c,tp)
	return c:IsMonster() and c:IsCanTurnSet()
end
function s.setsfilter(c,tp)
	return c:IsSpellTrap() and c:IsSSetable(false,1-tp)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local gm=Duel.GetMatchingGroup(s.setmfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	local gs=Duel.GetMatchingGroup(s.setsfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	Duel.ChangePosition(gm,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
	Duel.ChangePosition(gs,POS_FACEDOWN)
end