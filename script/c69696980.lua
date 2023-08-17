--69696980	Kaiserwaffe Incursio
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	-- Release control during the End Phase
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetCountLimit(1)
    e2:SetOperation(s.releaseControl)
    c.RegisterEffect(e2)
end
s.listed_series={0x69AA}
s.listed_names={id}

function s.spfilter(c,sp)
	return c:GetSummonPlayer() == sp and c:IsType(TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsAbleToChangeControler() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end

