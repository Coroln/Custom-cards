--thot
function c100000818.initial_effect(c)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000818,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c100000818.htg)
	e1:SetOperation(c100000818.hop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
		local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c100000818.spcon)
	e4:SetCountLimit(1,100000818)
	c:RegisterEffect(e4)
	--no damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(c100000818.damval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e6)
	--avoid
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--synchro limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetValue(c100000818.synlimit)
	c:RegisterEffect(e8)
	--damage
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetDescription(aux.Stringid(100000818,1))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c100000818.damcon)
	e9:SetTarget(c100000818.damtg)
	e9:SetOperation(c100000818.damop)
	c:RegisterEffect(e9)
		--cannot link material
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e20:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e20:SetValue(c100000818.synlimit)
	c:RegisterEffect(e20)
end
function c100000818.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c100000818.hop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c100000818.cfilter(c)
	return c:IsFaceup() and c:GetLevel()==4 and c:IsSetCard(0x758)
end
function c100000818.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000818.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c100000818.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 
	else return val end
end
function c100000818.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x758)
end
function c100000818.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000818.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c100000818.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end