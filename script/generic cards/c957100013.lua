--Harmonizing Fairy Bloom
--Scripted for Project Ignis EDOPro
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon: 2 non-Token Plant monsters
	Link.AddProcedure(c,s.matfilter,2,2)
	--Banish 1 linked Plant; Special Summon from GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Cannot be destroyed by battle while pointing to a Plant Synchro Monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Plant Synchro Monsters this card points to gain 200 ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.atktg)
	e3:SetValue(200)
	c:RegisterEffect(e3)
end
function s.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_PLANT,lc,sumtype,tp) and not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end
--Effect 1
function s.spfilter(c,e,tp,lv,tuner)
	return c:IsRace(RACE_PLANT) and c:IsLevelBelow(lv) and c:IsType(TYPE_TUNER)~=tuner
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.costfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsRace(RACE_PLANT) and lv>0 and c:IsAbleToRemoveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv,c:IsType(TYPE_TUNER))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	if chk==0 then return g:IsExists(s.costfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=g:FilterSelect(tp,s.costfilter,1,1,nil,e,tp):GetFirst()
	e:SetLabel(rc:GetLevel(),rc:IsType(TYPE_TUNER) and 1 or 0)
	Duel.Remove(rc,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv,t=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv,t==1)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Effects 2 & 3
function s.plantsynchro(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_SYNCHRO)
end
function s.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(s.plantsynchro,1,nil)
end
function s.atktg(e,c)
	return s.plantsynchro(c) and e:GetHandler():GetLinkedGroup():IsContains(c)
end