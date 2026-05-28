local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetCode(EVENT_TO_GRAVE)
	e1a:SetOperation(s.spr)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetDescription(aux.Stringid(id,4))
	e1b:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1b:SetCondition(s.spcon)
	e1b:SetTarget(s.sptg)
	e1b:SetOperation(s.spop)
	e1b:SetLabelObject(e1a)
	c:RegisterEffect(e1b)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE|PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)

    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.atkcon)
    e3:SetTarget(s.atktg)
    e3:SetOperation(s.atkop)
    c:RegisterEffect(e3)
end
--e1
function s.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (r&(REASON_DESTROY|REASON_EFFECT)~=(REASON_DESTROY|REASON_EFFECT)) or rp==tp or not c:IsPreviousControler(tp) then return end
	if Duel.IsTurnPlayer(tp) and Duel.IsPhase(PHASE_STANDBY) then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,0,1)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(id)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(id)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
	local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function s.tgfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToGrave()
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	local num = 1
	local type = 0
	if e:GetLabel()==0 then type = TYPE_MONSTER
    elseif e:GetLabel()==1 then type = TYPE_SPELL
    else type = TYPE_TRAP end
    if  Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,type)>1 then
        num = 2
    end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_DECK,0,num,num,nil,type)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
--e3
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function s.filter(c)
	return c:GetLevel()>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
