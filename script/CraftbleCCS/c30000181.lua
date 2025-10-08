local s,id=GetID()
function s.initial_effect(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.colcheck(c,fc1,fc2,fc11,fc22,choice)
if choice==0 then
if fc1 then
return c:GetSequence()>0 and fc1:GetSequence()>0 and not fc11
else
return c:GetSequence()>0
end
else 
if fc2 then
return c:GetSequence()<4 and fc2:GetSequence()<4 and not fc22
else
return c:GetSequence()<4
end
end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
local fc1 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-1)
local fc2 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+1)
local fc11 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-2)
local fc22 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+2)
if chk==0 then return c:IsFaceup() and (s.colcheck(c,fc1,fc2,fc11,fc22,0) or s.colcheck(c,fc1,fc2,fc11,fc22,1)) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local fc1 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-1)
local fc2 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+1)
local fc11 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()-2)
local fc22 = Duel.GetFieldCard(tp,LOCATION_MZONE,c:GetSequence()+2)
if not c or not c:IsFaceup() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or (not s.colcheck(c,fc1,fc2,fc11,fc22,0) and not s.colcheck(c,fc1,fc2,fc11,fc22,1)) or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)==0 then return end
local choice=Duel.SelectEffect(tp,{s.colcheck(c,fc1,fc2,fc11,fc22,0),aux.Stringid(id,1)},{s.colcheck(c,fc1,fc2,fc11,fc22,1),aux.Stringid(id,2)})
if choice==1 then
if fc1 and fc1:GetCode()==14291024 and fc1:GetFirstCardTarget()==e:GetHandler() then
Duel.MoveSequence(fc1,fc1:GetSequence()-1)
end
Duel.MoveSequence(c,c:GetSequence()-1)
if fc2 and fc2:GetCode()==14291024 and fc2:GetFirstCardTarget()==e:GetHandler() then
Duel.MoveSequence(fc2,fc2:GetSequence()-1)
end
else
if fc2 and fc2:GetCode()==14291024 and fc2:GetFirstCardTarget()==e:GetHandler() then
Duel.MoveSequence(fc2,fc2:GetSequence()+1)
end
Duel.MoveSequence(c,c:GetSequence()+1)
if fc1 and fc1:GetCode()==14291024 and fc1:GetFirstCardTarget()==e:GetHandler() then
Duel.MoveSequence(fc1,fc1:GetSequence()+1)
end
end
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c,e,tp)
	return e:GetHandler()==c or (c:GetCode()==14291024 and c:GetFirstCardTarget()==e:GetHandler())
end
function s.cgfilter(c,g)
	return g:IsContains(c)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local directhit=0
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil,e)
	for ccc in g:Iter() do
	local cg=ccc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #cg<=0 then directhit=directhit+1
	elseif #Duel.GetMatchingGroup(s.cgfilter,tp,0,LOCATION_EMZONE,ccc,cg)>=1 then
Duel.Destroy(Duel.GetMatchingGroup(s.cgfilter,tp,0,LOCATION_EMZONE,ccc,cg),REASON_EFFECT) elseif #Duel.GetMatchingGroup(s.cgfilter,tp,0,LOCATION_MMZONE,ccc,cg)>=1 then Duel.Destroy(Duel.GetMatchingGroup(s.cgfilter,tp,0,LOCATION_MMZONE,ccc,cg),REASON_EFFECT)
	else Duel.Destroy(Duel.GetMatchingGroup(s.cgfilter,tp,0,LOCATION_SZONE,ccc,cg),REASON_EFFECT)
	end
	end
	while directhit>0 do
	Duel.Damage(1-tp,e:GetHandler():GetAttack()/2,REASON_EFFECT)
	directhit=directhit-1
	end
end