--Gorgonic Eye
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(s.indes)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
end
--search
function s.remfilter(c,tp)
	lv=c:GetLevel()
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ROCK) and lv>0 and c:IsMonster()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,c,lv)
end
function s.thfilter(c,lv)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ROCK) and c:IsMonster() and c:IsLevel(lv) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.remfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.remfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.remfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetFirstTarget():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--indes
function s.indes(e,c)
	return c:GetAttack()>=1500
end
--atk
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a and d and a:IsFaceup() and a:IsAttribute(ATTRIBUTE_DARK) and a:IsRace(RACE_ROCK) and a:IsRelateToBattle() and d:IsFaceup() and d:IsRelateToBattle()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
