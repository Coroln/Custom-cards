function Auxiliary.AddUnionEquipFromGYEffect(c,f)
	local e=Effect.CreateEffect(c)
	e:SetDescription(1068) -- Same hint as regular equip
	e:SetCategory(CATEGORY_EQUIP)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetRange(LOCATION_GRAVE)
	e:SetCountLimit(1,c:GetOriginalCode()) -- HOPT based on card ID
	e:SetTarget(Auxiliary.UnionEquipGYTarget(f))
	e:SetOperation(Auxiliary.UnionEquipGYOperation(f))
	c:RegisterEffect(e)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,c:GetOriginalCode())
	e2:SetTarget(Auxiliary.UnionSumTarget())
	e2:SetOperation(Auxiliary.UnionSumOperation())
	c:RegisterEffect(e2)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(Auxiliary.UnionLimit(f))
	c:RegisterEffect(e4)
end
function Auxiliary.UnionEquipGYTarget(f)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and Auxiliary.UnionFilter(chkc,f,false) end
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(Auxiliary.UnionFilter,tp,LOCATION_MZONE,0,1,nil,f,false) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectTarget(tp,Auxiliary.UnionFilter,tp,LOCATION_MZONE,0,1,1,nil,f,false)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	end
end

function Auxiliary.UnionEquipGYOperation(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and (not f or f(tc)) then
			-- Setup equip limit manually in case EFFECT_UNION_LIMIT isn't active yet
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(e,cc) return cc==tc end)
			c:RegisterEffect(e1)

			if Duel.Equip(tp,c,tc,false) then
				Auxiliary.SetUnionState(c)
			end
		end
	end
end
function Auxiliary.UnionSumTarget()
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		local pos=POS_FACEUP
		if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,pos) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		c:RegisterFlagEffect(code,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
	end
end
function Auxiliary.UnionSumOperation()
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local pos=POS_FACEUP
		if Duel.SpecialSummon(c,0,tp,tp,true,false,pos)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false,pos) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
