--Supreme HERO Solar Flare Neos
--Coroln
Duel.LoadScript("customutility2.lua")
local s,id=GetID()
function s.initial_effect(c)
    local sets={0x3008,0x9008,0x5008,0x6008,0xa008,0xc008,0x9}
    for _,sc in ipairs(sets) do
        local e=Effect.CreateEffect(c)
        e:SetType(EFFECT_TYPE_SINGLE)
        e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
        e:SetCode(EFFECT_ADD_SETCODE)
        e:SetValue(sc)
        c:RegisterEffect(e)
    end
    --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_NEOS,90000002)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	aux.EnableSupremeNeosReturn(c)
    --summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
    --Shuffle up to 2 "HERO" cards to the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_NEOS,90000002}
s.material_setcode={SET_HERO,SET_ELEMENTAL_HERO,SET_NEOS,0x9008}
s.listed_series={0x3008,0x9008,0x5008,0x6008,0xa008,0xc008,0x9}
s.neos_add={CARD_NEOS,0x9008}
--fusion
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST|REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--Shuffle up to 2 "HERO" cards to the Deck
function s.rescon(sg,e,tp,mg)
	return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,#sg,nil)
end
function s.tdfilter(c)
    return c:IsSetCard(0x8) and c:IsAbleToDeckAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #rg>0 end
	local g=aux.SelectUnselectGroup(rg,e,tp,1,2,s.rescon,1,tp,HINTMSG_TODECK)
	e:SetLabel(#g)
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end