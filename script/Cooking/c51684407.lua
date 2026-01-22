--Princess of Baking Royaa
--Coroln
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_cooking_materials={51684405,51684408}
s.listed_names={51684406}
s.listed_series={0x1430}
--indes
function s.indtg(e,c)
	return c:IsMonster() and c:IsType(TYPE_EFFECT) and c~=e:GetHandler()
end
--to hand
function s.filter(c)
	return c:IsMonster() and c:IsType(TYPE_EFFECT) and ((c:IsAttack(800) and c:IsDefense(750)) or (c:IsAttack(750) and c:IsDefense(800))) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_DISCARD+REASON_EFFECT,nil) then
				local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
				if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local tg=g2:Select(tp,1,1,nil)
					Duel.HintSelection(tg)
					Duel.Destroy(tg,REASON_EFFECT)
				end
			end
		end
	end
end
