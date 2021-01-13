--serket
function c100000819.initial_effect(c)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c100000819.htg)
	e1:SetOperation(c100000819.hop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000819,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,100000819)
	e4:SetTarget(c100000819.sptg)
	e4:SetOperation(c100000819.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100000819,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,100000819)
	e7:SetTarget(c100000819.stg)
	e7:SetOperation(c100000819.sop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--no damage
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CHANGE_DAMAGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
	e10:SetValue(c100000819.damval)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e11)
		--avoid
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e12:SetValue(1)
	c:RegisterEffect(e12)
		--synchro limit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetValue(c100000819.synlimit)
	c:RegisterEffect(e13)
	--damage
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e14:SetCategory(CATEGORY_DAMAGE)
	e14:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetCondition(c100000819.damcon)
	e14:SetTarget(c100000819.damtg)
	e14:SetOperation(c100000819.damop)
	c:RegisterEffect(e14)
		--cannot link material
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e20:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e20:SetValue(c100000819.synlimit)
	c:RegisterEffect(e20)
end
function c100000819.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c100000819.hop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c100000819.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 
	else return val end
end
function c100000819.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x758)
end
function c100000819.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000819.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c100000819.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100000819.filter(c)
	return c:IsSetCard(0x758) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100000819.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000819.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100000819.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000819.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
function c100000819.filtersg(c)
	return c:IsSetCard(0x758) and c:IsType(TYPE_MONSTER) and not c:IsCode(100000819) and not c:IsCode(100000812) and c:GetLevel()==4 and c:IsAbleToHand()
end
function c100000819.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000819.filtersg,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100000819.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000819.filtersg,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end