--Star Fleet - Eklips Class
--Scripts by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1226),2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--Attack while in defense position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
s.listed_series={0x1226}
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g,tp,c)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	--gain Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetValue(#g*400)
	c:RegisterEffect(e1)
end
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end