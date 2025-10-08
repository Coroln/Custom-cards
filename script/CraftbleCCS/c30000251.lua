local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.atcon)
	e4:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsCode,140000085)))
	c:RegisterEffect(e4)
end
s.roll_dice=true
function s.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,140000085)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2,d3=Duel.TossDice(tp,3)
	if d1==6 or d2==6 or d3==6 then
	if d1==6 then d1=7 end
	if d2==6 then d2=7 end
	if d3==6 then d3=7 end
	Duel.SetDiceResult(d1,d2,d3)
	end
	if d1==d2 and d2==d3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3000)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e:GetHandler():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(s.efilter)
		e:GetHandler():RegisterEffect(e2)
	end
	local da=0 local db=0 local dc=0 local dd=0 local de=0 local df=0
	if d1==1 then da=da+1 elseif d1==2 then db=db+1 elseif d1==3 then dc=dc+1 elseif d1==4 then dd=dd+1 elseif d1==5 then de=de+1 elseif d1==7 then df=df+1 end
	if d2==1 then da=da+1 elseif d2==2 then db=db+1 elseif d2==3 then dc=dc+1 elseif d2==4 then dd=dd+1 elseif d2==5 then de=de+1 elseif d2==7 then df=df+1 end
	if d3==1 then da=da+1 elseif d3==2 then db=db+1 elseif d3==3 then dc=dc+1 elseif d3==4 then dd=dd+1 elseif d3==5 then de=de+1 elseif d3==7 then df=df+1 end
	local count=da
	while count>0 do
	Duel.Recover(e:GetHandlerPlayer(),700,REASON_EFFECT)
	count=count-1 end
	count=db
	while count>0 do
	Duel.Damage(1-e:GetHandlerPlayer(),700,REASON_EFFECT)
	count=count-1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	e1:SetValue(dc*300)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e:GetHandler():RegisterEffect(e2)
	count=dd
	local ctn=false
	if count>0 then ctn=Duel.SelectYesNo(tp,aux.Stringid(id,1)) end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then count=1 end
	if count>0 then
	while count>0 and ctn do
		local token=Duel.CreateToken(tp,140000085)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		count=count-1
		if count<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
	end
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if de>#dg then de=#dg end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ddg=dg:Select(tp,0,de,nil)
	Duel.HintSelection(ddg)
	Duel.Destroy(ddg,REASON_EFFECT)
	count=df
	while count>0 do
	local token=Duel.CreateToken(tp,67048711)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	count=count-1 end
end
