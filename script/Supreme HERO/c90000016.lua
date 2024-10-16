--Supreme HERO Darkest Day
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(0x9008)
	c:RegisterEffect(e0)
    local e1=e0:Clone()
    e1:SetValue(0xA008)
    c:RegisterEffect(e1)
    --race
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ALL)
	e2:SetValue(RACE_FIEND)
    c:RegisterEffect(e2)
    --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(0)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--fusion substitute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e4:SetCondition(s.subcon)
	c:RegisterEffect(e4)
end
s.listed_series={0x8}
function s.subcon(e)
	return e:GetHandler():IsLocation(0x1e)
end
function s.filter(c,e,tp,m,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.fil(c,tp)
	return c:IsCanBeFusionMaterial(nil,MATERIAL_FUSION) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM)
		and c:IsReleasable()
end
function s.fil2(c)
	return c:IsCanBeFusionMaterial(nil,MATERIAL_FUSION) and c:IsReleasable()
end
function s.fcheck(mg)
	return function(tp,sg,fc)
		return #(sg&mg)<2
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chkf=tp|FUSPROC_NOTFUSION
	if chk==0 then
		if e:GetLabel()~=1 or not c:IsReleasable() then return false end
		e:SetLabel(0)
		local mg=Duel.GetMatchingGroup(s.fil2,tp,LOCATION_MZONE,0,nil,nil,MATERIAL_FUSION)
		local mg2=Duel.GetMatchingGroup(s.fil,tp,0,LOCATION_MZONE,nil,tp)
		Fusion.CheckAdditional=s.fcheck(mg2)
		local res=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg+mg2,c,chkf)
		Fusion.CheckAdditional=nil
		return res
	end
	local mg=Duel.GetMatchingGroup(s.fil2,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(s.fil,tp,0,LOCATION_MZONE,nil,tp)
	Fusion.CheckAdditional=s.fcheck(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg+mg2,c,chkf)
	local mat=Duel.SelectFusionMaterial(tp,g:GetFirst(),mg+mg2,c,chkf)
	Fusion.CheckAdditional=nil
	if #(mat&mg2)>0 then
		local eff=(mat&mg2):GetFirst():IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM)
		if eff then
			eff:UseCountLimit(tp,1)
			Duel.Hint(HINT_CARD,0,eff:GetHandler():GetCode())
		end
	end
	Duel.Release(mat,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.filter2(c,e,tp,code)
	return c:IsCode(code) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,code)
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
	end
end