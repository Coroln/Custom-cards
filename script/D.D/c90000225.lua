--D.D.F. Different Dimension Fusion
--Script by Coroln
Duel.LoadScript("customutility2.lua")
local s, id = GetID()
function s.initial_effect(c)
    --Fusion summon 1 Fiend monster
	local params = {fusfilter=aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),extrafil=s.fextra,extraop=s.extraop,extratg=s.extratarget}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Fusion.SummonEffTG(params))
	e1:SetOperation(Fusion.SummonEffOP(params))
	c:RegisterEffect(e1)
    --add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.checkmat(tp,sg,fc)
	return fc:IsDD() or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil),s.checkmat
	end
	return nil
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function s.extratarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0 and ep==tp
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,200)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
        Duel.Damage(1-tp,200,REASON_EFFECT)
        Duel.Damage(tp,200,REASON_EFFECT)
    end
end