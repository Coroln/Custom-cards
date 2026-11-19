function Card.CheckType(c, tp)
	return (c:GetType() & tp) == tp
end

function Card.GetFreeAdjacentMonsterZones(c)
	local tp = c:GetControler()
	local zones = {}
    local tc

    if c:IsSequence(0) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
        if not tc then
            table.insert(zones, 2)
        end
    end
    if c:IsSequence(1) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 0)
        if not tc then
            table.insert(zones, 1)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if not tc then
            table.insert(zones, 4)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
        if not tc then
            table.insert(zones, 32)
        end
    end
    if c:IsSequence(2) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
        if not tc then
            table.insert(zones, 2)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
        if not tc then
            table.insert(zones, 8)
        end
    end
    if c:IsSequence(3) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if not tc then
            table.insert(zones, 4)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 4)
        if not tc then
            table.insert(zones, 16)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
        if not tc then
            table.insert(zones, 64)
        end
    end
    if c:IsSequence(4) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
        if not tc then
            table.insert(zones, 8)
        end
    end
    if c:IsSequence(5) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 0)
        if not tc then
            table.insert(zones, 1)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
        if not tc then
            table.insert(zones, 2)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if not tc then
            table.insert(zones, 4)
        end
    end
    if c:IsSequence(6) then
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
        if not tc then
            table.insert(zones, 4)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
        if not tc then
            table.insert(zones, 8)
        end
        tc = Duel.GetFieldCard(tp, LOCATION_MZONE, 4)
        if not tc then
            table.insert(zones, 16)
        end
    end
    
    return zones
end

function Card.PointsToZone(c, zone)
	if not c:IsType(TYPE_LINK) then
        return false
    end

	local tp = c:GetControler()
	local seq = math.log(zone, 2)

    if c:IsSequence(0) then
        return seq == 1 and c:IsLinkMarker(LINK_MARKER_RIGHT) or seq == 5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT)
    end
    if c:IsSequence(1) then
        return seq == 0 and c:IsLinkMarker(LINK_MARKER_LEFT) or seq == 2 and c:IsLinkMarker(LINK_MARKER_RIGHT) or seq == 5 and c:IsLinkMarker(LINK_MARKER_TOP)
    end
    if c:IsSequence(2) then
        return seq == 1 and c:IsLinkMarker(LINK_MARKER_LEFT) or seq == 3 and c:IsLinkMarker(LINK_MARKER_RIGHT) or seq == 5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) or seq == 6 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT)
    end
    if c:IsSequence(3) then
        return seq == 2 and c:IsLinkMarker(LINK_MARKER_LEFT) or seq == 4 and c:IsLinkMarker(LINK_MARKER_RIGHT) or seq == 6 and c:IsLinkMarker(LINK_MARKER_TOP)
    end
    if c:IsSequence(4) then
        return seq == 3 and c:IsLinkMarker(LINK_MARKER_LEFT) or seq == 6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT)
    end
    if c:IsSequence(5) then
        return seq == 0 and c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) or seq == 1 and c:IsLinkMarker(LINK_MARKER_BOTTOM) or seq == 2 and c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT)
    end
    if c:IsSequence(6) then
        return seq == 2 and c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) or seq == 3 and c:IsLinkMarker(LINK_MARKER_BOTTOM) or seq == 4 and c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT)
    end
end

function Card.GetMatchingCardEffects(c, code, start, ent)
	local effs = {c:GetCardEffect(code)}

	if start == ent then
		return effs[start]
	end

	local t = {}
	
	for i = start, ent do
		table.insert(t, effs[i])
	end
	
	return t
end

function Card.GetMaxCounterRemoval(c, tp, cttypes, reason)
	local ct = 0
	if type(cttypes) == "table" then
		for _, cttype in ipairs(cttypes) do
			for i = 1, c:GetCounter(cttype) do
				if c:IsCanRemoveCounter(tp, cttype, i, reason) then
					ct = ct + 1
				else
					break
				end
			end
		end
	else
		for i = 1, c:GetCounter(cttypes) do
			if c:IsCanRemoveCounter(tp, cttypes, i, reason) then
				ct = ct + 1
			else
				break
			end
		end
	end
	return ct
end

function Card.MaxCounterRemovalCheck(c, tp, cttypes, ctamount, reason)
	return c:GetMaxCounterRemoval(tp, cttypes, reason) >= ctamount
end

function Card.IsAbleToLocation(c, loc, asCost)
	if asCost == true then
		if loc == LOCATION_DECK then
			return c:IsAbleToDeckAsCost()
		elseif loc == LOCATION_EXTRA then
			return c:IsAbleToExtraAsCost()
		elseif loc == LOCATION_GRAVE then
			return c:IsAbleToGraveAsCost()
		elseif loc == LOCATION_HAND then
			return c:IsAbleToHandAsCost()
		elseif loc == LOCATION_REMOVED then
			return c:IsAbleToRemoveAsCost()
		end
	else
		if loc == LOCATION_DECK then
			return c:IsAbleToDeck()
		elseif loc == LOCATION_EXTRA then
			return c:IsAbleToExtra()
		elseif loc == LOCATION_GRAVE then
			return c:IsAbleToGrave()
		elseif loc == LOCATION_HAND then
			return c:IsAbleToHand()
		elseif loc == LOCATION_REMOVED then
			return c:IsAbleToRemove()
		end
	end

	return false
end
