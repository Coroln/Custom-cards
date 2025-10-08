local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself from the GY if you control "King's Sarcophagus"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
function s.spcon(e,c)
	return Duel.IsEnvironment(CARD_UMI)
end
