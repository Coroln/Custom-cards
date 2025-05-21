--69696925 : Veldora Tempest, Die Wahre Drachokatastrophe
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,s.matfilter,aux.FilterBoolFunctionEx(Card.IsSetCard,0x69A or Card.IsSetCard,0x69B),true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--indestructable except the enemy has more ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(s.condition3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Prevent the activation of Spell/Trap Cards if it attacks
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.aclimit)
	e4:SetCondition(s.actcon)
	c:RegisterEffect(e4)
end
--s.listed_names={id}
--s.listed_series={0x69E}
-- Fusion:
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA 
end
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
-- e3:
function s.condition3(c,atk)
	return c:GetAttack()=atk
-- e4:
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end