--Empress of the Crimson Serpent
--Script by Coroln
Duel.LoadScript("proc_trick2.lua")
local s,id=GetID()
function s.initial_effect(c)
    Trick.AddProcedure(c,nil,nil,{{s.tfilter,1,1}},{{s.tfilter2,1,1}})
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA) and not e:GetHandler():IsReason(REASON_EFFECT) end)
    e1:SetTarget(s.milltg)
    e1:SetOperation(s.millop)
	c:RegisterEffect(e1)
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

--e1
function s.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsTrap()
end
function s.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,3)
end
function s.millop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,3,REASON_EFFECT)
    local dg=Duel.GetOperatedGroup()
    local d=dg:FilterCount(s.filter,nil)

    Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
    local dg=Duel.GetOperatedGroup()
    d=d+dg:FilterCount(s.filter,nil)

	if d>0 then
        c = e:GetHandler()
        c:UpdateAttack(d*300)
	end
end
