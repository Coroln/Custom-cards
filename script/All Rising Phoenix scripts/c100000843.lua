local s,id=GetID()
--Created and coded by Rising Phoenix
function s.initial_effect(c)
   --salvage
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(id,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetCountLimit(1)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCost(s.thcost)
   e1:SetTarget(s.thtg)
   e1:SetOperation(s.thop)
   c:RegisterEffect(e1)
   --tograve
   local e3=Effect.CreateEffect(c)
   e3:SetDescription(aux.Stringid(id,0))
   e3:SetCategory(CATEGORY_TOGRAVE)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e3:SetCode(EVENT_SUMMON_SUCCESS)
   e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
   e3:SetTarget(s.target)
   e3:SetOperation(s.operation)
   c:RegisterEffect(e3)
   local e4=e3:Clone()
   e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
   c:RegisterEffect(e4)
   local e5=e3:Clone()
   e5:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e5)
   --1000atk 
   local e8=Effect.CreateEffect(c)
   e8:SetDescription(aux.Stringid(id,0))
   e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e8:SetType(EFFECT_TYPE_IGNITION)
   e8:SetRange(LOCATION_GRAVE)
   e8:SetCost(s.costat)
   e8:SetTarget(s.targetat)
   e8:SetOperation(s.operationat)
   c:RegisterEffect(e8)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
   Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c)
   return c:IsSetCard(0x75B) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
   if #g>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
   end
end
function s.gfilter(c)
   return c:IsSetCard(0x75B) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(s.gfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g=Duel.SelectMatchingCard(tp,s.gfilter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then end
	   Duel.SendtoGrave(g,REASON_EFFECT)
   if not e:GetHandler():IsRelateToEffect(e) then return end
   if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
   local g=Duel.GetDecktopGroup(1-tp,1)
   Duel.DisableShuffleCheck()
   Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)	
   end
function s.costat(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsAbleToDeck() end
	   Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function s.targetat(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
   if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
   Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.operationat(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local tc=Duel.GetFirstTarget()
   if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetValue(-1000)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
   end
end
