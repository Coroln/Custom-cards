local s,id=GetID()
function s.initial_effect(c)
    local params = {nil,Fusion.CheckWithHandler(Fusion.OnFieldMat),s.fextra,nil,Fusion.ForcedHandler}
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
    e1:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
    c:RegisterEffect(e1)
end
function s.fextra(e,tp,mg)
	local grup=Group.CreateGroup()
	grup:AddCard(e:GetHandler())
		return grup
end