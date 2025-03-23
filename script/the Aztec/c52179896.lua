--Bone Sword of the Aztecs
--Script by ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    -- Equip procedure: Equip only to a Rock monster
    aux.AddEquipProcedure(c,nil,function(c) return c:IsRace(RACE_ROCK) end)
    -- ATK/DEF boost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --Force attack + Position change effect
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(s.postg)
    e3:SetOperation(s.posop)
    c:RegisterEffect(e3)
end
--Force attack + Position change effect
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ec=e:GetHandler()
    local eq=ec:GetEquipTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end
    -- If in Defense Position, change to Attack Position
    if tc:IsDefensePos() and tc:IsCanChangePosition() then
        Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
    end
    -- Apply EFFECT_MUST_ATTACK and EFFECT_ONLY_ATTACK_MONSTER to tc
    local e1=Effect.CreateEffect(ec)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MUST_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    if eq then
        local e2=Effect.CreateEffect(ec)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
        e2:SetValue(function(e,c) return c==eq end)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
