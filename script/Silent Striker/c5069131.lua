--Silent Circus
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon as many "Silent Striker Mirage Token"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_sereis={0x132F}
--Special Summon as many "Silent Striker Mirage Token"
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x132F)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,5069134,0,TYPES_TOKEN,0,0,1,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,5069134,0,TYPES_TOKEN,0,0,1,RACE_PLANT,ATTRIBUTE_WIND) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sg=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,5069134)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		sg:AddCard(token)
	end
	Duel.SpecialSummonComplete()
	--atk limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.atcon)
	e1:SetValue(s.atlimit)
	sg:RegisterEffect(e1)
	--effect limit
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.atcon)
	e2:SetValue(s.atlimit)
	sg:RegisterEffect(e2)
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,5069134)
end
function s.atlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end