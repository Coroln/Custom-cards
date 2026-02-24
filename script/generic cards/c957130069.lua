local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true, function(c,fc,sumtype,tp)
                       return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) end
                       ,2)

    -- ATK Boosr
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)

    -- Mill 3 from both decks
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.millcon)
    e2:SetTarget(s.milltg)
    e2:SetOperation(s.millop)
    c:RegisterEffect(e2)

    -- Indest. by card effects
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)

    -- Equip from GY and gain effects
    local e4a=Effect.CreateEffect(c)
    e4a:SetDescription(aux.Stringid(id,1))
    e4a:SetCategory(CATEGORY_EQUIP)
    e4a:SetType(EFFECT_TYPE_IGNITION)
    e4a:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4a:SetRange(LOCATION_MZONE)
    e4a:SetCountLimit(1)
    e4a:SetCondition(s.eqcon)
    e4a:SetTarget(s.eqtg)
    e4a:SetOperation(s.eqop)
    c:RegisterEffect(e4a)
    aux.AddEREquipLimit(c,s.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,s.equipop,e4a)

    --When equipped monster is destroyed, destroy this card
    local e4b=Effect.CreateEffect(c)
    e4b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4b:SetCode(EVENT_LEAVE_FIELD)
    e4b:SetRange(LOCATION_MZONE)
    e4b:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetHandler():GetFirstCardTarget()
        return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
        end
    )
    e4b:SetOperation(function(e) Duel.Destroy(e:GetHandler(),REASON_EFFECT) end)
    c:RegisterEffect(e4b)
end

--e1
function s.atkval(e,c)
    local mg=c:GetMaterial()
    if #mg==0 then return 0 end
    return mg:FilterCount(Card.IsRace,nil,RACE_ZOMBIE)*300
end

--e2
function s.millcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,3)
end
function s.millop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,3,REASON_EFFECT)
    Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
--e4
function s.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end

function s.equipop(c,e,tp,tc)
	if not c:EquipByEffectAndLimitRegister(e,tp,tc,id) then return end

    -- Coppy Effects
    local code=tc:GetOriginalCode()
    local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)

    -- Reset Coppied Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetLabel(cid)
    e2:SetLabelObject(tc)
    e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetLabelObject()
        return eg:IsContains(tc) end
    )
    e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local cid=e:GetLabel()
        e:GetHandler():ResetEffect(cid,RESET_COPY)
        e:Reset() end)
    c:RegisterEffect(e2)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,c,tp):GetFirst()
	if tc then
		s.equipop(c,e,tp,tc)
        c:SetCardTarget(tc)
	end
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(Card.HasFlagEffect,nil,id)
	return #g==0
end
