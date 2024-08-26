--Forbidden Weapon of Heroes
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x8))
	--Equipped monster gains 200 ATK/DEF per banished Exiled HERO or Spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0x9008) or c:IsCode(90000010,id,90000011)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,e:GetHandler():GetControler(),LOCATION_REMOVED,0,nil)*200
end