--Blazing Soul
--Coroln
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Move to another MMZ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.seqtg)
	e1:SetOperation(s.seqop)
	c:RegisterEffect(e1)
	--You can activate this card from your hand by discarding 1 card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetValue(function(e,c) e:SetLabel(1) end)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(s.trickcon)
	c:RegisterEffect(e4)
end
--Move to another MMZ
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then e:GetLabelObject():SetLabel(0) return true end
	if e:GetLabelObject():GetLabel()>0 then
		e:GetLabelObject():SetLabel(0)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_DISCARD+REASON_COST,nil)
	end
end
function s.seqfilter(c)
	local tp=c:GetControler()
	return c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	Duel.SelectTarget(tp,s.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ttp=tc:GetControler()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(ttp,LOCATION_MZONE,ttp,LOCATION_REASON_CONTROL)<=0 then return end
	local p1,p2,i
	if tc:IsControler(tp) then
		i=0
		p1=LOCATION_MZONE
		p2=0
	else
		i=16
		p2=LOCATION_MZONE
		p1=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)-i) and tc:IsType(TYPE_TRICK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	end
end
--destroy
function s.trickcon(e,tp,eg,ep,ev,re,r,rp)
    if not re then return false end
    local c=e:GetHandler() -- the material
    local rc=e:GetHandler():GetReasonCard() -- the monster that was summoned using this card as material
    return rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsPreviousLocation(LOCATION_EXTRA)
        and not (rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK))
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack()/2)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()/2
		if atk<0 or tc:IsFacedown() then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end