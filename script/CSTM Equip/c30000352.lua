local s,id=GetID()
function s.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE|PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Special Summon itself
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(s.spcon)
	e4:SetValue(aux.ChangeBattleDamage(0,HALF_DAMAGE))
	c:RegisterEffect(e4)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local seq=tc:GetSequence()
	local dc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	if dc then Duel.Destroy(dc,REASON_RULE) end
	if Duel.CheckLocation(tp,LOCATION_SZONE,seq)
		and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,tc:IsMonsterCard(),1<<seq) then
		--Treated as a Continuous Spell
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
		tc:RegisterEffect(e1)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetColumnZone(LOCATION_MZONE)&ZONES_MMZ
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and zone>0 and not Duel.IsExistingMatchingCard(aux.IsZone,tp,LOCATION_MZONE,0,1,nil,zone,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local zone=c:GetColumnZone(LOCATION_MZONE)&ZONES_MMZ
	if not (c:IsRelateToEffect(e) and zone>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then Debug.Message(c) return end
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP,zone)
	Duel.SpecialSummonComplete()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0
end