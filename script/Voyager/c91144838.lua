--Voyager ET1701
--Script by Coroln
local s,id=GetID()
function s.initial_effect(c)
	--Union procedure
	aux.AddUnionProcedure(c)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--When sent to GY because equipped monster left field
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.eqcon)
    e2:SetTarget(s.eqtg)
    e2:SetOperation(s.eqop)
    c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x943}
--When sent to GY because equipped monster left field
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetPreviousEquipTarget()
	return e:GetHandler():IsReason(REASON_LOST_TARGET) and not ec:IsLocation(LOCATION_ONFIELD|LOCATION_OVERLAY)
end
function s.voyagerfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x943) and c:IsMonster()
end
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x943) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.voyagerfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.voyagerfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.voyagerfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
    if Duel.Equip(tp,c,tc) then
        aux.SetUnionState(c)
        if tc:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
            if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
                if #sg>0 then
                    local sc=sg:GetFirst()
                    if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
                        -- Negate its effects
                        local e1=Effect.CreateEffect(c)
                        e1:SetType(EFFECT_TYPE_SINGLE)
                        e1:SetCode(EFFECT_DISABLE)
                        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                        sc:RegisterEffect(e1,true)
                        local e2=e1:Clone()
                        e2:SetCode(EFFECT_DISABLE_EFFECT)
                        sc:RegisterEffect(e2,true)
                    end
                end
            end
        end
    end
end