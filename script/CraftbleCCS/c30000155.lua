local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_ONFIELD)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #g==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp):GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD) then tc:CreateEffectRelation(e) end
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsControler(1-tp)
		or not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	local seq1=tc:GetSequence()
	local seq2=c:GetSequence()
	if seq1>4 then return end
	if seq2<5 then seq2=4-seq2
	elseif seq2==5 then seq2=3
	elseif seq2==6 then seq2=1 end
	local nseq=seq1+(seq2>seq1 and 1 or -1)
	if seq1~=seq2 and (Duel.CheckLocation(1-tp,tc:GetLocation(),nseq)) then
		Duel.MoveSequence(tc,nseq)
	end
	--Debug.Message(seq1)
	--Debug.Message(seq2)
	--Debug.Message(nseq)
	--Debug.Message(Duel.CheckLocation(tp,tc:GetLocation(),nseq))
end