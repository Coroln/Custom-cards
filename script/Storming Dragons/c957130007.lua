local s,id=GetID()
function s.initial_effect(c)
    -- Quick-Play aktivieren
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

---------------------------------------------
-- 1) Hilfsfunktionen/Filter
---------------------------------------------
-- Filter für Drachen-Normalmonster (zum Senden & Zählen)
function s.gy_filter(c)
    return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL)
end

-- Filter zum Hinzufügen auf die Hand (für Option 4)
function s.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

---------------------------------------------
-- 2) Zielauswahl (target)
---------------------------------------------
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.gy_filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
    end
    -- Senden wird jetzt als Effekt behandelt, daher wird es hier nicht ausgeführt
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end

---------------------------------------------
-- 3) Effekt ausführen (activate)
---------------------------------------------
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Wir wählen bis zu 3 passende Monster und senden sie ins GY
    local g=Duel.SelectMatchingCard(tp,s.gy_filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,3,nil)
    local ct=#g
    if ct>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
    
    -- Falls nicht genau 3 gesendet wurden, wird der Effekt abgebrochen
    if ct~=3 then return end

    -- Zähle nun alle Drachen-Normalmonster im Friedhof
    local gc=Duel.GetMatchingGroupCount(s.gy_filter,tp,LOCATION_GRAVE,0,nil)
    
    -- Liste der möglichen Effekte
    local op_table={}
    local op_val={}
    
    -- 3+ : Ziehe 1 Karte
    if gc>=3 then
        table.insert(op_table,aux.Stringid(id,0)) -- "Draw 1 card"
        table.insert(op_val,1)
    end
    -- 5+ : Special Summon aus GY
    if gc>=5 then
        table.insert(op_table,aux.Stringid(id,1)) -- "Special Summon"
        table.insert(op_val,2)
    end
    -- 7+ : Zerstöre 1 Karte
    if gc>=7 then
        if Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
            table.insert(op_table,aux.Stringid(id,2)) -- "Destroy 1 card"
            table.insert(op_val,3)
        end
    end
    -- 10+ : Monster suchen + Burn
    if gc>=10 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
        table.insert(op_table,aux.Stringid(id,3)) -- "Add 1 monster + burn"
        table.insert(op_val,4)
    end
    -- 20+ : Du gewinnst das Duell
    if gc==20 then
        table.insert(op_table,aux.Stringid(id,4)) -- "Win the Duel"
        table.insert(op_val,5)
    end
    
    -- Wenn mindestens eine Option möglich ist
    if #op_table>0 then
        if Duel.SelectYesNo(tp,aux.Stringid(id,6)) then

            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
            local sel=Duel.SelectOption(tp,table.unpack(op_table))
            local op_sel = op_val[sel+1] -- Effektwahl speichern
            
            -- Jetzt je nach Auswahl den Effekt ausführen
            if op_sel==1 then
                -- 1) Ziehe 1 Karte
                Duel.Draw(tp,1,REASON_EFFECT)
                
            elseif op_sel==2 then
                -- 2) Special Summon 1 Drachen-Normalmonster in DEF
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local g=Duel.SelectMatchingCard(tp,s.gy_filter,tp,LOCATION_GRAVE,0,1,1,nil)
                if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
                    local tc=g:GetFirst()
                    -- Kann diese Runde nicht angreifen
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_CANNOT_ATTACK)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    tc:RegisterEffect(e1)
                    -- Kann nicht als Material für Fusion/Synchro/Xyz/Link benutzt werden
                    local e2=Effect.CreateEffect(e:GetHandler())
                    e2:SetType(EFFECT_TYPE_SINGLE)
                    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e2:SetCode(EFFECT_CANNOT_BE_MATERIAL)
                    e2:SetValue(function(e,rc,sumtype)
                        return (sumtype&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
                            or (sumtype&SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
                            or (sumtype&SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
                            or (sumtype&SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
                    end)
                    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    tc:RegisterEffect(e2)
                end
                
            elseif op_sel==3 then
                -- 3) Zerstöre 1 Karte
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
                if #dg>0 then
                    Duel.HintSelection(dg)
                    Duel.Destroy(dg,REASON_EFFECT)
                end
                
            elseif op_sel==4 then
                -- 4) Füge 1 Monster (Deck/GY) deiner Hand hinzu und füge Burn-Damage zu
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
                if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
                    Duel.ConfirmCards(1-tp,tg)
                    -- 200 Schaden für jede Karte auf dem Spielfeld
                    local count=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
                    Duel.Damage(1-tp,count*200,REASON_EFFECT)
                end
                
            elseif op_sel==5 then
                -- 5) Du gewinnst das Duell
                Duel.Win(tp,0x60)
            end
        end
    end
end
