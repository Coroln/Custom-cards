-- 69696928 : Veldanava, Die Wahre Drachogottheit
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,s.matfilter,aux.FilterBoolFunctionEx(Card.IsSetCard,0x69E),true)
	--Cannot negate its Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e1)
end