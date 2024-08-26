--Alkdrache Saitama der Sake
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	--Must be Special Summoned by a Alkdrache monster effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1) end)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
	---indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(s.drcon)
	e4:SetOperation(s.indop)
	c:RegisterEffect(e4)
end
--Must be Special Summoned by a Alkdrache monster effect
function s.splimit(e,se,sp,st)
	return se:IsMonsterEffect() and se:GetHandler():IsSetCard(0x14EC)
end
--Special Summon procedure
function s.spfilter(c,tp)
	return c:IsSetCard(0x14EC) and (c:IsControler(tp) or c:IsFaceup())
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetReleaseGroup(tp)
	local rg2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	return aux.SelectUnselectGroup(rg1,e,tp,3,3,aux.ChkfMMZ(1),0)
		and aux.SelectUnselectGroup(rg2,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	local mg1=aux.SelectUnselectGroup(rg1,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg1>0 then
		local sg=mg1:GetFirst()
		local rg2=Duel.GetReleaseGroup(tp)
		rg2:RemoveCard(sg)
		local mg2=aux.SelectUnselectGroup(rg2,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
		mg1:Merge(mg2)
	end
	if #mg1==3 then
		mg1:KeepAlive()
		e:SetLabelObject(mg1)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
--destroy
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
--indes
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsRace(RACE_DRAGON) and c~=e:GetHandler()
end