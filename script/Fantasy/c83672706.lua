--Blue Mana Rose
--Coroln
local s,id=GetID()
function s.initial_effect(c)
    --Place Counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_place_list={0xFF}
RACE_LEGENDARY = 0x100000000
--Place Counter
function s.filter(c)
	return c:IsFaceup() and c:IsMonster() and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_MAGICALKNIGHT) or c:IsRace(RACE_CELESTIALWARRIOR) or c:IsRace(RACE_LEGENDARY)) and c:IsCanAddCounter(0xFF,2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xFF)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        tc:AddCounter(0xFF,2)
	end
end