local s,id=GetID()
function s.initial_effect(c)
	local params = {nil,nil,nil,nil,nil}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(function(e,tp) return Duel.HasFlagEffect(tp,id) end)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Special Summon 1 "Watt" Synchro Monster from your Extra Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.spsynccon)
	e3:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e3:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e3)
	--Check that a monster inflicted battle damage to the opponent
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local player=eg:GetFirst():GetControler()
	if ep==1-player then
		Duel.RegisterFlagEffect(player,id,RESET_PHASE|PHASE_DAMAGE,0,1)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spsynccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.relfilter(c)
	return c:HasLevel() and not c:IsType(TYPE_TUNER) and c:IsReleasableByEffect()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function s.spfilter(c,e,tp,matg,lv)
	return c:IsSetCard(SET_WATT) and c:IsType(TYPE_SYNCHRO)
		and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,matg,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg,sg:GetSum(Card.GetLevel))
end