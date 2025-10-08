local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={99171160}
function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(99171160)
end
function s.hfilter(c)
	return c:IsCode(99171160) or c:ListsCode(99171160)
end
function s.nhfilter(c)
	return not (c:IsCode(99171160) or c:ListsCode(99171160))
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac
	local ck=Duel.GetMatchingGroupCount(s.atkfilter,e:GetHandler():GetOwner(),LOCATION_ONFIELD,0,nil)
	local mmn=(ck+1)*3
	local ct=math.min(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),mmn)
	if ct==0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<mmn then
	ac=ct==1 and ct or Duel.AnnounceNumberRange(tp,1,ct)
	else ac=mmn end
	local g=Duel.GetDecktopGroup(tp,ac)
	local hs=g:Filter(s.nhfilter,nil)
	local hg=g:Filter(s.hfilter,nil)
	if #hg~=0 then
	Duel.DisableShuffleCheck()
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
	Duel.ShuffleHand(tp)
	end
	if #hs~=0 then
	Duel.SortDecktop(tp,tp,#hs)
	end
end