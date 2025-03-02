local s,id=GetID()
function s.initial_effect(c)
    -- Aktivierung: Wenn ein deiner Warrior-Monster angegriffen wird
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

-- Eigene Filterfunktion für face-up Xyz-Monster
function s.faceupXyz(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

-- Bedingung: Ein Warrior-Monster, das du kontrollierst, wird angegriffen
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return at and at:IsFaceup() and at:IsControler(tp) and at:IsRace(RACE_WARRIOR)
end

-- Kosten: Lege 1 Xyz-Material von einem Xyz-Monster auf deiner Seite ab
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(mg) do
		g:Merge(tc:GetOverlayGroup())
	end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	
    e:SetLabelObject(sc)

	Duel.SendtoGrave(sc,REASON_COST)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
end

-- Filter für Xyz-Monster im Extra Deck, die per Effekt-Spezialbeschwörung beschworen werden können
function s.xyzfilter(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end

-- Operation:
-- Das angegriffene Monster erhält die ATK, DEF und den Level des abgelegten Materials;
-- anschließend kannst du optional ein Xyz-Monster aus deinem Extra Deck Spezialbeschwören
-- und das Angriffsziel auf jenes Monster ändern.
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    if not (at and at:IsRelateToBattle()) then return end
    local rc=e:GetLabelObject()
    if not rc then return end

    local add_atk=rc:GetAttack()
    local add_def=rc:GetDefense()
    local add_lvl=rc:GetLevel()

    -- Erhöhe ATK des angegriffenen Monsters um den ATK-Wert des abgelegten Materials
    if add_atk>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(add_atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        at:RegisterEffect(e1)
    end
    -- Erhöhe DEF des angegriffenen Monsters um den DEF-Wert des abgelegten Materials
    if add_def>0 then
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(add_def)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        at:RegisterEffect(e2)
    end
    -- Erhöhe den Level des angegriffenen Monsters um den Level des abgelegten Materials
    if add_lvl>0 and at:IsLevelAbove(1) then
        local cur_lvl=at:GetLevel()
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(cur_lvl+add_lvl)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        at:RegisterEffect(e3)
    end

    -- Optional: Xyz-Summon aus dem Extra Deck und ändere das Angriffsziel
    if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
        local g=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
        local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
        if #xyzg>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
            Duel.XyzSummon(tp,xyz,nil,g,1,99)

        end
    end
end

function s.mfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function s.xyzfilter(c,mg)
	return  c:IsXyzSummonable(nil,mg)
end
