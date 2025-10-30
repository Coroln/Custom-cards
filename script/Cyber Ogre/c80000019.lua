-- 
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,64268668,37057012)
	--atk up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.atkcon)
	e0:SetValue(s.atkval)
	c:RegisterEffect(e0)
	--on attack or effect target: Tribute "Cyber Ogre" to destroy up to 3 cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon1)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	--e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCondition(s.descon2)
	c:RegisterEffect(e2)
end
s.material_setcode=SET_CYBER
s.listed_names={64268668,37057012}
--atk up
function s.atkcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL)
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function s.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()/2
end
--on attack or effect target: Tribute "Cyber Ogre" to destroy up to 3 cards
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker() and Duel.GetAttacker():GetControler()==1-tp
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp then return false end
    local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return tg and tg:IsExists(Card.IsControler,1,nil,tp)
end
function s.cyberogrefilter(c)
    return c:IsCode(64268668) and c:IsReleasable()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,s.cyberogrefilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,s.cyberogrefilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil)
    if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
