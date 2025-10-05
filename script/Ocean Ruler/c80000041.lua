--Serrina, Ober-Ozeanherrscherin der Kraken
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_SEASERPENT),4,4)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.remcon)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(s.defval)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.damcon)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(s.descost)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
end
--remove
function s.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x1e,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1e)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--def up
function s.defval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetRank)*200
end
--damage
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and ep~=tp and c:GetFlagEffect(id)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,600,REASON_EFFECT)
end
--destroy
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.desfilter(c,def)
	return c:IsFaceup() and c:IsDefenseBelow(def)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetDefense()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,c:GetDefense())
	Duel.Destroy(g,REASON_EFFECT)
end
