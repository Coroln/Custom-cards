local s,id=GetID()
function s.initial_effect(c)
    -- Link Summon
    c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x356),3,3)

    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)

    --atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atktg)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)

    --equipp
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(s.eftg2)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)

    --Cards this points to cannot be targeted
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(function(e,c) return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x356) end)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end
s.listed_series={0x56}
--e1
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	--local tc=e:GetLabelObject()
	if(Duel.IsPlayerCanDiscardDeck(tp,4))then
        Duel.DiscardDeck(tp,4,REASON_EFFECT)
    end
end

--e2
function s.atktg(e,c)
	return c:IsSetCard(0x356) and c~=e:GetHandler()
end

function s.val(e,c)
    return c:GetAttack()*0.3
end

--e3
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x356)
end

function s.eftg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():GetLinkedGroupCount() >1 end
    local g=Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
    e:SetCategory(CATEGORY_EQUIP)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
    local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g2=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    e:SetLabelObject(g1:GetFirst())
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
        local tc1=e:GetLabelObject()
        local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
        local tc2=g:GetFirst()
        if tc1==tc2 then tc2=g:GetNext() end
        if tc1:IsFaceup() and tc2:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) and Duel.Equip(tp,tc1,tc2,false) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(s.eqlimit)
            e1:SetLabelObject(tc2)
            tc1:RegisterEffect(e1)
            --Destroy instead
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
            e2:SetValue(1)
            tc1:RegisterEffect(e2)
        end
end
function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end