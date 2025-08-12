--Silent Striker Spruzzard
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	c:EnableUnsummonable()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--special summon (left)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--special summon (right)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	--place pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100219001,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.pencon)
	e3:SetTarget(s.pentg)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
	--Special summon 1 monster from pendulum zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end
s.listed_series={0x132F}
--splimit
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	if se and se:GetHandler()==c then return true end
	if (st&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local lpz=Duel.GetFieldCard(sp,LOCATION_PZONE,0)
		local rpz=Duel.GetFieldCard(sp,LOCATION_PZONE,1)
		if lpz and rpz and lpz:IsSetCard(0x132F) and rpz:IsSetCard(0x132F) then
			return true
		end
	end
	return false
end
--special summon (left)
function s.condition(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(Card.IsMonster,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_MZONE,LOCATION_MZONE,0)
	if #g<3 then return end
	local dg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_DESTROY)
	if #dg==3 and Duel.Destroy(dg,REASON_EFFECT)==3 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		c:CompleteProcedure()
	end
end
--special summon (right)
function s.condition2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	if chk==0 then return #g>=3 and aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1),0)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	if #g<3 then return end
	local dg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_DESTROY)
	if #dg==3 and Duel.Destroy(dg,REASON_EFFECT)==3 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		c:CompleteProcedure()
	end
end
--place pendulum zone
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--Special summon 1 monster from pendulum zone
function s.filter(c,e,tp)
	return c:IsSetCard(0x132F) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local pzone_index=tc:GetSequence()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if pzone_index==0 then
				local tc=Duel.GetFirstTarget()
				local e1=Effect.CreateEffect(c)
				e1:SetCategory(CATEGORY_ATKCHANGE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(tc:GetScale()*100)
				c:RegisterEffect(e1)
			elseif pzone_index==4 then
				local tc=Duel.GetFirstTarget()
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetRange(LOCATION_MZONE)
				e2:SetTargetRange(0,LOCATION_MZONE)
				e2:SetValue(tc:GetScale()*-100)
				c:RegisterEffect(e2)
			end
		end
	end
end