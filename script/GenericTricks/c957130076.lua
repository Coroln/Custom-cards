
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
	-- Zerstörung (Pflichteffekt)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
--Trick Summon
--Monster filter
function s.tfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
-- Prüft, ob genau 1 Monster spezialbeschworen wurde
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and not eg:IsContains(e:GetHandler())
end

-- Target & Cost (Tribut ist hier Teil der Operation/Kosten bei Trigger_F)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)>0 then
		if tc and tc:IsLocation(LOCATION_MZONE) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		-- End Phase Reborn registrieren
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabelObject(c)
		e2:SetCondition(s.spcon)
		e2:SetOperation(s.spop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

-- Special Summon in der End Phase
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsLocation(LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Damage(1-tp,200,REASON_EFFECT)
		end
	end
end
