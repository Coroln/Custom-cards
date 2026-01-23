Duel.LoadScript("Move_ST_Utillity.lua")
local s,id=GetID()
local CARD_AEOREOS = 957130033
s.listed_names={CARD_AEOREOS}
local COUNTER_AEOREOS = 0x1BBC
s.counter_place_list={COUNTER_AEOREOS}
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_AEOREOS)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_STZONE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(s.tdcon2)
    e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,tp,COUNTER_AEOREOS) end)
    e2:SetOperation(s.counterop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_MSET)
    e3:SetCondition(s.tdcon3)
    c:RegisterEffect(e3)
    --Search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_STZONE)
    e4:SetCost(Cost.RemoveCounterFromSelf(COUNTER_AEOREOS,4))
    e4:SetTarget(s.e4tg)
    e4:SetOperation(s.e4op)
    c:RegisterEffect(e4)

    -- ATK-Reset
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(s.atktg)
    e5:SetOperation(s.atkop)
    c:RegisterEffect(e5)
    --Move self to adj. ST-Zone
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,4))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_STZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(s.e6tg)
    e6:SetCondition(auxMSTU.seqmovcon)
    e6:SetOperation(s.e6op)
    c:RegisterEffect(e6)

    --cannot SP from LOCATION_EXTRA
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCondition(function(e) return e:GetHandler():GetSequence()==2 end)
    e7:SetTargetRange(1,0)
    e7:SetTarget(function(e,c,sump,sumtype,sumpos,targetp) return c:IsLocation(LOCATION_EXTRA) end)
    c:RegisterEffect(e7)

    --Atk up
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetRange(LOCATION_SZONE)
    e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetCondition(function(e) local seq = e:GetHandler():GetSequence() return seq == 1 or seq == 3 end)
    e8:SetTarget(function (e, c) local seq = e:GetHandler():GetSequence() return c:GetSequence() == seq end)
    e8:SetValue(400)
    c:RegisterEffect(e8)

    -- Negate
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_DISABLE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetTargetRange(0,LOCATION_MZONE)
    e9:SetCondition(s.edgecon)
    e9:SetTarget(s.edgetg)
    c:RegisterEffect(e9)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- If not activated in the middle Spell & Trap Zone
	if c:GetSequence()~=2 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--e2-3
function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()~=e:GetHandler() and ep==tp
		and eg:GetFirst():IsTributeSummoned()
end
function s.tdcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetMaterialCount()~=0 and ep==tp
end

function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(COUNTER_AEOREOS,1)
	end
end
--e4
function s.e4filter(c)
	return (c:ListsCode(CARD_AEOREOS) or c:IsCode(CARD_AEOREOS)) and c:IsAbleToHand() and c:GetCode()~=id
end
function s.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e4filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.e4op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.e4filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e5
function s.e5filter(c)
	return c:IsFaceup() and c:GetAttack()<c:GetTextAttack()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e5filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.e5filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetTextAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--e6
function s.e6tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,tp,COUNTER_AEOREOS)
end
function s.e6op(e,tp,eg,ep,ev,re,r,rp)
    c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(tp,tc)
    Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleDeck(tp) -- required after revealing

	if tc:IsCode(e:GetLabel()) then
		auxMSTU.seqmovop(e,tp,eg,ep,ev,re,r,rp)
        if c:IsRelateToEffect(e) then
            c:AddCounter(COUNTER_AEOREOS,1)
        end
	end
end
--e9
function s.edgecon(e)
    local seq=e:GetHandler():GetSequence()
    return seq==0 or seq==4
end

function s.edgetg(e,c)
    local seq=e:GetHandler():GetSequence()
    return c:GetSequence()==4-seq or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5)
end
