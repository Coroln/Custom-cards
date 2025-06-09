--The Fiendish Demon Empress, Luciela
--Script by Rika
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
    c:EnableCounterPermit(0x0999)
    --summon success
    
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.addct)
	e1:SetOperation(s.addc)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)

    -- E2: On Trap Activation - Add 1 counter
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.ctcon)
    e3:SetOperation(s.ctop)
    c:RegisterEffect(e3)

    -- E5: Quick Effect - Remove up to 2 counters to change ATK position monsters with ATK >= this card's
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_POSITION)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e4:SetCountLimit(1)
    e4:SetCost(s.poscost)
    e4:SetTarget(s.postg)
    e4:SetOperation(s.posop)
    c:RegisterEffect(e4)

    -- E6 Destroy 1 monster whose current ATK is different from its original ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	e5:SetHintTiming(TIMINGS_CHECK_MONSTER_E,TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e5)
end

--Trick Summon
--Monster filter
function s.tfilter(c)
	return c:IsType(TYPE_EFFECT)
end
--Trap filter
function s.tfilter2(c)
	return c:IsTrap()
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x0999 )
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(0x0999  ,1)
	end
end


--e4 
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_TRAP)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x0999  ,1)
end
--e5

function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
    local ct=c:GetCounter(0x0999 )
    local max_ct=math.min(2,ct,#g)
    if chk==0 then return max_ct>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
    local num=Duel.AnnounceNumber(tp,table.unpack(aux.TableRange(1,max_ct)))
    e:SetLabel(num)
    c:RemoveCounter(tp,0x0999 ,num,REASON_COST)
end

function s.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
    local ct=c:GetCounter(0x0999 )
    local max_ct=math.min(2,ct,#g)
    if chk==0 then return max_ct>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
    local DeclareTable={}
    table.insert(DeclareTable,1)
    if max_ct > 1 then
        table.insert(DeclareTable,2)
        local num=Duel.AnnounceNumber(tp,table.unpack(DeclareTable))
        e:SetLabel(num)
        c:RemoveCounter(tp,0x0999 ,num,REASON_COST)
    else
        e:SetLabel(1)
        c:RemoveCounter(tp,0x0999 ,1,REASON_COST)
    end
end

function s.posfilter(c,atk)
    return c:IsFaceup() and c:IsAttackPos() and c:GetAttack()>=atk and c:IsCanChangePosition()
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=e:GetLabel()
    local atk=e:GetHandler():GetAttack()
    if chkc then return true end-- chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc,atk) end
    if chk==0 then return true end--Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,ct,nil,atk) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil,atk)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetCards(e)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end

--e6
function s.filtere6(c,e)
	return c:IsPosition(POS_FACEUP) and c:GetAttack()<c:GetBaseAttack()
		and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filtere6(chkc,e) end
	if chk==0 then
		--retain applicable targets in case cost makes an indirect change to ATK
		local g=Duel.GetMatchingGroup(s.filtere6,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		if #g==0 then return end
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=e:GetLabelObject()
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)		
	end
end
