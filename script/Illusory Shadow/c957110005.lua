local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1)
    e2:SetCondition(s.skcon)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    --recover
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(s.reccon)
    e3:SetTarget(s.rectg)
    e3:SetOperation(s.recop)
    c:RegisterEffect(e3)
end
--e2
function s.skconfilter(c,tp)
    if  not c:IsReason(REASON_EFFECT) then return false end
    local re=c:GetReasonEffect()
    return re:IsMonsterEffect() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function s.skcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.skconfilter,1,nil,tp)
end

function s.cfilter(c,e,tp)
    local vDebug2 = 0
    return c:IsSetCard(0xBBB) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and (c:GetPreviousSetCard()&0xBBB)~=0 and
            Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,c:GetAttack(),c:GetAttribute(),e,tp)
end
function s.filter(c,atk,att,e,tp)
    local a=c:GetAttack()
    return a>=0 and a<atk and c:IsSetCard(0xBBB) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(s.cfilter,1,nil,e,tp)
    end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.cfilter2(c,e,tp)
    return c:IsSetCard(0xBBB) and c:IsControler(tp) and c:IsRelateToEffect(e)
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,c:GetAttack(),nil,e,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local sg=eg:Filter(s.cfilter2,nil,e,tp)
    if #sg==1 then
        local tc=sg:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttack(),nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    else
        local tc=sg:GetFirst()
        if not tc then return end
        local atk=tc:GetAttack()
        tc=sg:GetNext()
        if tc then
            if tc:GetAttack()>atk then atk=tc:GetAttack() end
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,atk,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

--e3
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0xBBB)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end