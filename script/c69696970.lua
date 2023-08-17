--Kaiserwaffe Cross Tail
local s, id = GetID()
function s.initial_effect(c)
    -- -500 ATK
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    -- +800 DEF
    local e2=e1:Clone()
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DEFCHANGE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetOperation(s.defop)
    c:RegisterEffect(e2)
end
s.listed_series={0x69AA}
s.listed_names={id}
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local value = -250
        if tc:IsAttribute(ATTRIBUTE_DARK) then
            value = -500 -- Set the value to -500 for DARK monsters
        end
    end
end

function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local value = 400
        if tc:IsAttribute(ATTRIBUTE_DARK) then
            value = 800 -- Set the value to 800 for DARK monsters
        end
    end
end
