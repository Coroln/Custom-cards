local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return a:IsControler(tp) and a:IsRace(RACE_FAIRY) or at and at:IsControler(tp) and at:IsFaceup() and at:IsRace(RACE_FAIRY)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function s.addfilter(c)
	return ((c:IsRitualMonster() and c:IsSetCard(0x40CF)) or  c:IsCode(957130021)) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
		local g=Duel.GetMatchingGroup(s.addfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local gt=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #gt>0 then
				if Duel.SendtoHand(gt,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
					and Duel.SelectYesNo(tp,aux.Stringid(id,1))then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
					if #g2==0 then return end
					Duel.HintSelection(g2,true)
					Duel.BreakEffect()
					Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
				end
				Duel.ConfirmCards(1-tp,gt)
			end
		end
	end
end