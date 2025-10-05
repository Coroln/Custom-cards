--Possaido, Ozeanherrscher von Atlantis
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--def up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.defcon)
	e1:SetCost(s.defcost)
	e1:SetTarget(s.deftg)
	e1:SetOperation(s.defop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--defense attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_UMI}
s.listed_series={0x1864}
--def up
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,22702055)
end
function s.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.deffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1864) and aux.nzdef(c)
end
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and c44891812.deffilter(chkc) and chkc~=e:GetLabelObject() end
	if chk==0 then return a:IsDefensePos() and d and d:IsControler(1-tp)
		and Duel.IsExistingTarget(s.deffilter,tp,LOCATION_MZONE,0,1,a) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.deffilter,tp,LOCATION_MZONE,0,1,1,a)
	e:SetLabelObject(a)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ac=e:GetLabelObject()
	if ac:IsRelateToBattle() and ac:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(tc:GetDefense())
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ac:RegisterEffect(e1)
	end
end
--special summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and s.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
