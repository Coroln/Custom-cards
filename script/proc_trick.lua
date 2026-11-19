Duel.LoadScript("customutility.lua")

if not Trick then
	Trick={}
end

--Parameter:
--c: Das Trick-Monster.
--desc: Optionale Beschreibung des Effektes.
--monsterTable: Table, der weitere Table der Form {Filter, min, max} beinhält und die benötigten Monster mit ihrer Anzahl klassifiziert.
--trapTable: Wie oben, aber mit den Fallen.
--matCheck: Optionaler Filter mit der Signatur (sg, e, tp), den die gewählten Materialien durlaufen.
--materialDestination: Optionale Location, wohin die Materialien geschickt werden. GY ist Standard.
--extracon: Optionale Beschwörungsbedingung mit der Signatur (e, tp) 
--extraop: Optionale Operation mit der Signatur (e, tp, mg) die nach der Beschwörung ausgeführt wird. Hierbei ist mg die Materialgruppe.

--[[Kleines Beispiel: 2 LIGHT Monsters + 2 Fiend Monsters including a LIGHT Fiend Monster Special Summoned from your Extradeck + 2 "Fiendsmith" Traps including "Fiendsmith Kyrie". 
	Materials that are used for this card's Trick Summon are shuffeled into the Deck instead of going to the GY. 
	You can only Trick Summon this card if you control a "Fiendsmith" card.
	When this card is Trick Summoned, you can gain LP equal to the combined ATK of all monsters used as Material for this card.

Trick.AddProcedure(c, nil, {{s.lightfilter, 2, 2}, {s.fiendfilter, 2, 2}}, {{s.trapfilter, 2, 2}}, s.matCheck, LOCATION_DECK, s.extracon, s.extraop)

function s.matCheck(sg, e, tp)
	return sg:IsExists(s.lightfiendfilter, 1, nil, tp) and sg:IsExists(Card.IsCode, 1, nil, CODE_FIENDSMITH_KYRIE)
end

function s.extracon(e, tp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard, 1, tp, LOCATION_ONFIELD, 0, 1, nil, SET_FIENDSMITH)
end

function s.extraop(e, tp, mg)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Recover(tp, mg:Filter(Card.IsMonster, nil):GetSum(Card.GetAttack), REASON_EFFECT)
	end
end

Filter hierhin xD
--]]
function Trick.AddProcedure(c, desc, monsterTable, trapTable, matCheck, materialDestination, extracon, extraop)
	if c:IsStatus(STATUS_COPYING_EFFECT) then 
		return
	end
	local min, max = aux.GetMinMaxMaterialCount(2, monsterTable, trapTable)
	local mt = c:GetMetatable()
	mt.minTrickMaterialCount = min
	mt.maxTrickMaterialCount = max
	mt.requiredMonsters = monsterTable
	mt.requiredTraps = trapTable
	mt.materialDestination = materialDestination
	local e = Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_SPSUMMON_PROC)
	if desc then
		e:SetDescription(desc)
	else 
		e:SetDescription(3500)
	end
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(SUMMON_TYPE_TRICK)
	e:SetCondition(Trick.Condition(extracon, matCheck))
	e:SetTarget(Trick.Target(matCheck))
	e:SetOperation(Trick.Operation(extraop))
	c:RegisterEffect(e)
end

function Trick.Condition(extracon, matCheck)
	return function(e, c)
		if c == nil then 
			return true
		end
		local tp = e:GetHandlerPlayer()
		return (not extracon or extracon(e, tp)) and c:IsFacedown() and c:CheckTrickMaterial(matCheck)
	end
end

function Trick.Target(matCheck)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local sg = Duel.SelectTrickMaterial(e, matCheck)
		if #sg > 0 then
			e:SetLabelObject(sg)
			sg:KeepAlive()
			return true
		end 
		return false
	end
end

function Trick.Operation(extraop)
	return function(e, tp, eg, ep, ev, re, r, rp, c)
		local mg = e:GetLabelObject()
		local dest = c.materialDestination or LOCATION_GRAVE
		c:SetMaterial(g)
		Duel.ConfirmCards(1 - tp, mg:Filter(Card.IsLocation, nil, LOCATION_SZONE))
		Duel.Sendto(mg, dest, REASON_TRICK + REASON_MATERIAL, POS_FACEUP)
		if dest == LOCATION_DECK then
			if mg:IsExists(Card.IsControler, 1, nil, tp) then
				Duel.ShuffleDeck(tp)
			end
			if mg:IsExists(Card.IsControler, 1, nil, 1 - tp) then
				Duel.ShuffleDeck(1 - tp)
			end
		end
		if extraop then
			extraop(e, tp, mg)
		end
		mg:DeleteGroup()
	end
end

function Trick.Rescon(monsterTable, trapTable, min, max, mustg, materialDestination, matCheck)
	local g, ct
	local dest = materialDestination or LOCATION_GRAVE
	return function(sg, e, tp, mg)
		for _,t in pairs(monsterTable) do
			g = Duel.GetMatchingGroup(t[1], tp, LOCATION_MZONE, 0, nil)
			ct = #(sg & g)
			if ct < t[2] or ct > t[3] or ct <= 0 then
				return false
			end
		end
		for _,t in pairs(trapTable) do
			g = Duel.GetMatchingGroup(t[1], tp, LOCATION_SZONE, 0, nil)
			ct = #(sg & g)
			if ct < t[2] or ct > t[3] or ct <= 0 then
				return false
			end
		end
		return max >= #sg and #sg >= min and Duel.GetLocationCountFromEx(tp, tp, sg, e:GetHandler()) > 0 and (not matCheck or matCheck(sg, e, tp)) and sg:Includes(mustg) and sg:FilterCount(Card.IsAbleToLocation, nil, dest, false) == #sg
	end
end

function Card.CheckTrickMaterial(c, matCheck)
	if not c:IsType(TYPE_TRICK) then
		return false
	end
	local tp = c:GetControler()
	local effs = {c:GetOwnEffects(EFFECT_SPSUMMON_PROC)}
	local e
	for _, v in pairs(effs) do
		if v:GetValue() == SUMMON_TYPE_TRICK then
			e = v
			break
		end
	end
	if not e then
		return false
	end
	local monsterTable = c.requiredMonsters
	local trapTable = c.requiredTraps
	local min = c.minTrickMaterialCount
	local max = c.maxTrickMaterialCount
	local mustg = aux.GetMustBeMaterialGroup(tp, nil, tp, c, nil, REASON_TRICK)
	local g = Duel.GetMatchingGroup(Trick.Matfilter, tp, LOCATION_MZONE + LOCATION_SZONE, 0, nil, e:GetHandler())
	return aux.SelectUnselectGroup(g, e, tp, min, math.min(max, #g), Trick.Rescon(monsterTable, trapTable, min, max, mustg, c.materialDestination, matCheck), 0)
end

function Duel.SelectTrickMaterial(e, matCheck)
	local c = e:GetHandler()
	local tp = c:GetControler()
	local monsterTable = c.requiredMonsters
	local trapTable = c.requiredTraps
	local min = c.minTrickMaterialCount
	local max = c.maxTrickMaterialCount
	local mustg = aux.GetMustBeMaterialGroup(tp, nil, tp, c, nil, REASON_TRICK)
	local g = Duel.GetMatchingGroup(Trick.Matfilter, tp, LOCATION_MZONE + LOCATION_SZONE, 0, nil, e:GetHandler())
	return aux.SelectUnselectGroup(g, e, tp, min, math.min(max, #g), Trick.Rescon(monsterTable, trapTable, min, max, mustg, c.materialDestination, matCheck), 1, tp, HINTMSG_TRICK_MATERIAL, Trick.Rescon(monsterTable, trapTable, min, max, mustg, c.materialDestination, matCheck), nil, true)
end

function Trick.Matfilter(c, mc)
	return c:IsCanBeTrickMaterial(mc) and ((c:IsFaceup() and c:IsMonster()) or c:IsType(TYPE_TRAP))
end

function Card.IsCanBeTrickMaterial(c)
	return c:IsCanBeMaterial(SUMMON_TYPE_TRICK)
end

function Card.IsTrick(c)
	return c:IsType(TYPE_TRICK)
end
