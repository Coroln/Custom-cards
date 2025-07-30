--Kagemane Yokai Queen - Yaegaki
--Script by Coroln and ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    -- Xyz summon procedure
    c:EnableReviveLimit()
    Xyz.AddProcedure(c,nil,4,2,nil,nil,Xyz.InfiniteMats,nil,false,s.xyzcheck)
    -- Add 1 "Kuransain" card from GY to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.thcost)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    -- Store material count when leaving the field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_LEAVE_FIELD_P)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(s.regop)
    c:RegisterEffect(e2)
    -- Draw and discard when destroyed
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.drcon)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
    -- Link e2 and e3 for proper label handling
    e2:SetLabelObject(e3)
end
s.listed_series={0x75A0}
-- Custom Xyz summon filter (different Attribute for each material)
function s.xyzcheck(g,tp,xyz)
    return g:GetClassCount(Card.GetAttribute)==#g
end
-- Effect 1: Add "Kuransain" card from GY to hand
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thfilter(c)
    return c:IsSetCard(0x75A0) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Effect 2: Store material count before leaving the field
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetHandler():GetOverlayCount()
    if ct>0 then
        e:GetLabelObject():SetLabel(ct)
    end
end
-- Effect 3: Draw and discard when destroyed
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()>0 and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=e:GetLabel()
    if chk==0 then return ct>0 end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct>0 and Duel.Draw(tp,ct+1,REASON_EFFECT)>0 then
        local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        if #hand<=2 then
            Duel.SendtoGrave(hand,REASON_EFFECT+REASON_DISCARD)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
            local dg=hand:Select(tp,2,2,nil)
            Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
        end
    end
end
