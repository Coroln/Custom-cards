--Trick Monster (Platzhalter-Name)
--1 non-Token monster + 1 Trap Card
local s,id=GetID()
Duel.LoadScript("proc_trick2.lua")
function s.initial_effect(c)
	--Trick Summon
	Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
	--Once per turn: target 1 monster your opponent controls; it gains 500 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--Gains ATK equal to the combined ATK of all other monsters in this card's column
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.colatkval)
	c:RegisterEffect(e2)
	--Once per turn, if you activate a Trap Card (Quick Effect): You can move this card to another of your Main Monster Zones
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.movecon)
	e3:SetTarget(s.movetg)
	e3:SetOperation(s.moveop)
	c:RegisterEffect(e3)
end
--Trick Summon
--Monster filter (non-Token)
function s.tfilter(c)
	return c:IsMonster() and not c:IsType(TYPE_TOKEN)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap() and c:IsType(TYPE_CONTINUOUS)
end
--Effect 1: +500 ATK to an opponent's monster
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--Effect 2: ATK = combined ATK of all other monsters in this card's column
function s.colfilter(c,self)
	return c~=self and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function s.colatkval(e,c)
	local g=c:GetColumnGroup():Filter(s.colfilter,nil,c)
	return g:GetSum(Card.GetAttack)
end
--Effect 3: move to another Main Monster Zone when you activate a Trap Card
function s.movecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.freezones(tp,c)
	local zones=0
	local seq=c:GetSequence()
	for i=0,4 do
		if i~=seq and Duel.CheckLocation(tp,LOCATION_MZONE,i) then
			zones=zones|(1<<i)
		end
	end
	return zones
end
function s.movetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return s.freezones(tp,c)~=0 end
end
function s.moveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local zones=s.freezones(tp,c)
	if zones==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local sel=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~zones)
	local nseq=math.floor(math.log(sel,2))
	Duel.MoveSequence(c,nseq)
end