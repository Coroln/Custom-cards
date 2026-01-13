auxMSTU={}
--[[
	nicht getestet:
		Card.MSTUSelectAdjacent
		auxMSTU.seqmovtg
		auxMSTU.seqmovtgop
	getestet
		Card.MSTUMoveAdjacent
		Card.MSTUCheckAdjacent
		auxMSTU.seqmovcon
		auxMSTU.seqmovop
]]--


function Card.MSTUSelectAdjacent(c,sel_player)
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	local targ_player=c:GetControler()
	if seq>0 and Duel.CheckLocation(targ_player,LOCATION_SZONE,seq-1) then flag=flag|(0x1<<seq-1) end
	if seq<4 and Duel.CheckLocation(targ_player,LOCATION_SZONE,seq+1) then flag=flag|(0x1<<seq+1) end
	if flag==0 then return end
	if sel_player==targ_player then shift = 8 else shift = 24 end
	local sel_player=sel_player==nil and targ_player or sel_player
	local loc1=targ_player==sel_player and LOCATION_SZONE or 0
	local loc2=loc1==0 and LOCATION_SZONE or 0
	local shift
	if sel_player==targ_player then shift = 8 else shift = 24 end
	Duel.Hint(HINT_SELECTMSG,sel_player,HINTMSG_TOZONE)
	local zone=Duel.SelectDisableField(sel_player,1,loc1,loc2,~(flag<<shift))>>shift
	Duel.Hint(HINT_ZONE,targ_player,zone)
	return math.log(zone,2)
end

function Card.MSTUMoveAdjacent(c,sel_player)
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	local targ_player=c:GetControler()
	if seq>0 and Duel.CheckLocation(targ_player,LOCATION_SZONE,seq-1) then flag=flag|(0x1<<seq-1) end
	if seq<4 and Duel.CheckLocation(targ_player,LOCATION_SZONE,seq+1) then flag=flag|(0x1<<seq+1) end
	if flag==0 then return end
	if sel_player==targ_player then shift = 8 else shift = 24 end
	local sel_player=sel_player==nil and targ_player or sel_player
	local loc1=targ_player==sel_player and LOCATION_SZONE or 0
	local loc2=loc1==0 and LOCATION_SZONE or 0
	local shift
	if sel_player==targ_player then shift = 8 else shift = 24 end
	Duel.Hint(HINT_SELECTMSG,sel_player,HINTMSG_TOZONE)
	local zone=Duel.SelectDisableField(sel_player,1,loc1,loc2,~(flag<<shift))
	Duel.MoveSequence(c,math.log(zone>>shift,2))
end

function Card.MSTUCheckAdjacent(c)
	local p=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(p,LOCATION_SZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(p,LOCATION_SZONE,seq+1))
end
--condition for effects that make the monster change its current sequence
function auxMSTU.seqmovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():MSTUCheckAdjacent()
end
--operation for effects that make the monster change its current sequence
--where the new sequence is choosen during resolution
function auxMSTU.seqmovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	c:MSTUMoveAdjacent()
end
--target for effects that make the monster change its current sequence
--where the new sequence is choosen at target time
function auxMSTU.seqmovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(e:GetHandler():MSTUSelectAdjacent())
end
--operation for effects that make the monster change its current sequence
--where the new sequence is choosen at target time
function auxMSTU.seqmovtgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or not Duel.CheckLocation(tp,LOCATION_SZONE,seq) then return end
	Duel.MoveSequence(c,seq)
end
