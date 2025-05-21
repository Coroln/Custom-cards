--69696937 : Demon Lord Dagruel
function s.initial_effect(c)
--Attack while in defense position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
--s.listed_names={id}
--s.listed_series={0x69D}