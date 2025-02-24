--Purple Gadget
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Add 1 "Gadget" monster from the Deck to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --Equip this card to a "Gadget" or "Hole" monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_HAND|LOCATION_MZONE)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
	--Special Summon this card that was equipped to a monster by its own effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(function(e,tp) return e:GetHandler():HasFlagEffect(id) and not Duel.IsExistingMatchingCard(Card.IsSpellTrap,tp,LOCATION_GRAVE,0,1,nil) end)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
    --disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.discon)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
end
s.listed_series={0x51,0x89}
s.listed_names={id}
function Card.IsBootUp(c)
    return c:IsCode(36322312,938717,13316346)
end
--Add 1 "Gadget" monster from the Deck to the hand
function s.filter(c)
	return c:IsSetCard(0x51) and c:IsMonster() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.eqfilter(c)
    return c:IsFaceup() and c:IsMonster() and (c:IsSetCard(0x51) or (c:IsSetCard(0x89) and (c:GetOriginalType()&TYPE_TRAP)~=0) or c:IsBootUp())
end
--Equip this card to a "Gadget" or "Hole" monster
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		 and c~=chkc and chkc:IsFaceup() and (chkc:IsSetCard(0x51) or chkc:IsSetCard(0x89)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
		and Duel.Equip(tp,c,tc,true)) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1)
	--Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(function(_,c) return c==tc end)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
--Special Summon this card that was equipped to a monster by its own effect
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--disable
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end