--bastet
function c100000813.initial_effect(c)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000813,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c100000813.htg)
	e1:SetOperation(c100000813.hop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
		--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000813,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,100000813)
	e4:SetTarget(c100000813.sptg)
	e4:SetOperation(c100000813.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
		--no damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(c100000813.damval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e8)
		--avoid
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
		--synchro limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetValue(c100000813.synlimit)
	c:RegisterEffect(e10)
	--damage
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetDescription(aux.Stringid(100000813,1))
	e11:SetCategory(CATEGORY_DAMAGE)
	e11:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c100000813.damcon)
	e11:SetTarget(c100000813.damtg)
	e11:SetOperation(c100000813.damop)
	c:RegisterEffect(e11)
		--cannot link material
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e20:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e20:SetValue(c100000813.synlimit)
	c:RegisterEffect(e20)
end
function c100000813.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c100000813.hop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c100000813.filter(c,e,tp)
	return c:IsSetCard(0x758)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000813.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c100000813.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000813.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000813.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000813.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end	
function c100000813.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 
	else return val end
end
function c100000813.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x758)
end
function c100000813.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000813.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c100000813.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end