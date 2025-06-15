--This file contains a useful list of functions and constants which can be used for a lot of things.

--constants
REGISTER_FLAG_FILTER=16
HINTMSG_REMOVE_COUNTER=10001
HINTMSG__MATERIAL=10002
HINTMSG_TRICK_MATERIAL=10003
--functions
local function arg_dump(e, func, kind, ...)
	if DEBUG_ID == e:GetHandler():GetCode() then
		Debug.Message(kind.." of "..e:GetHandler():GetCode())
		local t = table.pack(...)
		local str = "  "
		for i = 1, t.n do
			str = str..i..": "..type(t[i]).." "
		end
		Debug.Message(str)
	end
	return func(...)
end

local SetTg = Effect.SetTarget
Effect.SetTarget = function (e, func)
	return SetTg(e, function (...)
		return arg_dump(e, func, "Target", ...)
	end)
end
local SetCon = Effect.SetCondition
Effect.SetCondition = function (e, func)
	return SetCon(e, function (...)
		return arg_dump(e, func, "Condition", ...)
	end)
end
local SetOp = Effect.SetOperation
Effect.SetOperation = function (e, func)
	return SetOp(e, function (...)
		return arg_dump(e, func, "Operation", ...)
	end)
end

function Card.GetMaxCounterRemoval(c,tp,cttypes,reason)
	local ct=0
	if type(cttypes)=="table" then
		for _,cttype in ipairs(cttypes) do
			for i=1,c:GetCounter(cttype) do
				if c:IsCanRemoveCounter(tp,cttype,i,reason) then
					ct=ct+1
				else
					break
				end
			end
		end
	else
		for i=1,c:GetCounter(cttypes) do
			if c:IsCanRemoveCounter(tp,cttypes,i,reason) then
				ct=ct+1
			else
				break
			end
		end
	end
	return ct
end

function Card.MaxCounterRemovalCheck(c,tp,cttypes,ctamount,reason)
	return c:GetMaxCounterRemoval(tp,cttypes,reason)>=ctamount
end

function Group.GetMaxCounterRemoval(g,tp,cttypes,reason)
	local ct=0
	if type(cttypes)=="table" then
		for _,cttype in ipairs(cttypes) do
			for tc in g:Iter() do
				ct=ct+tc:GetMaxCounterRemoval(tp,cttype,reason)
			end
		end
	else
		for tc in g:Iter() do
			ct=ct+tc:GetMaxCounterRemoval(tp,cttypes,reason)
		end
	end
	return ct
end

function Group.CanRemoveCounter(g,tp,cttypes,ctamount,reason)
	return g:GetMaxCounterRemoval(tp,cttypes,reason)>=ctamount
end

function Group.RemoveCounter(g,tp,cttypes,ctamount,reason)
	if type(cttypes)=="table" then
		local ct=0
		for _,cttype in ipairs(cttypes) do
			ct=ct+g:GetMaxCounterRemoval(tp,cttype,reason)
		end
		if ct<ctamount then return end
		local choices,tc,choice
		for i=1,ctamount do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE_COUNTER)
			tc=g:FilterSelect(tp,Card.MaxCounterRemovalCheck,1,1,nil,tp,cttypes,1,reason):GetFirst()
			choices={}
			for _,cttype in ipairs(cttypes) do
				table.insert(choices,{tc:IsCanRemoveCounter(tp,cttype,1,reason),tonumber(cttype)})
			end
			choice=Duel.SelectEffect(tp,table.unpack(choices))
			tc:RemoveCounter(tp,cttypes[choice],1,reason)
		end
	else
		if not g:CanRemoveCounter(tp,cttypes,ctamount,reason) then return end
		local tc
		for i=1,ctamount do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE_COUNTER)
			tc=g:FilterSelect(tp,Card.IsCanRemoveCounter,1,1,nil,tp,cttypes,1,reason):GetFirst()
			tc:RemoveCounter(tp,cttypes,1,reason)
		end
	end
end

function Synchro.Tuner(f,...)
	local params={...}
	return function(target,scard,sumtype,tp)
		return target:IsType(TYPE_TUNER,scard,sumtype,tp) and (not f or f(target,table.unpack(params)))
	end
end

function Card.CheckType(c,tp)
	return (c:GetType()&tp)==tp
end

function contains(tab,element)
	for _,value in pairs(tab) do
		if value==element then
			return true
		end
	end
	return false
end

function removeall(tab,element)
	for _,value in pairs(tab) do
		if value==element then
			table.remove(tab,value)
		end
	end
end

function Auxiliary.doccost(min,max,label,cost,order)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ct,eff,set,label=c:GetOverlayCount(),Duel.IsPlayerAffectedByEffect(tp,CARD_NUMERON_NETWORK),c:IsSetCard(0x14b),label or false
		local min=min or ct
		local max=max or min
			if chk==0 then 
				if cost then
					return (c:CheckRemoveOverlayCard(tp,min,REASON_COST) or (eff and set)) and cost(e,tp,eg,ep,ev,re,r,rp,0)
					else return c:CheckRemoveOverlayCard(tp,min,REASON_COST) or (eff and set)
				end
			end
			if cost then
				if order==0 then
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						return true
							else
								cost(e,tp,eg,ep,ev,re,r,rp,1)
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
					end
				elseif order==1 then
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						cost(e,tp,eg,ep,ev,re,r,rp,1)
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
								cost(e,tp,eg,ep,ev,re,r,rp,1)
					end
				else
					if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
					end
				end
			else
				if (eff and set) and (ct==0 or (ct>0 and Duel.SelectYesNo(tp,aux.Stringid(CARD_NUMERON_NETWORK,1)))) then
						return true
							else
								c:RemoveOverlayCard(tp,min,max,REASON_COST)
				end
			end
		if label==true then 
			e:SetLabel(#Duel.GetOperatedGroup())
		end
	end
end

function Auxiliary.spfilter(e,tp,sumtype,nocheck,nolimit,f,...)
	local params={...}
	return function(c)
		if f then return c:IsCanBeSpecialSummoned(e,sumtype,tp,nocheck,nolimit) and f(c,table.unpack(params))
		else return c:IsCanBeSpecialSummoned(e,sumtype,tp,nocheck,nolimit) end
	end
end

Auxiliary.MultiRegister=aux.FunctionWithNamedArgs(
	function(c,codes,desc,cat,prop,typ,range,con,cost,tg,op,opt,flags)
	local effs,flags={},flags or {}
	local e=Effect.CreateEffect(c)
	if desc then e:SetDescription(desc) end
	if cat then e:SetCategory(cat) end
	if prop then e:SetProperty(prop) end
	if range then e:SetRange(range) end
	e:SetType(typ)
	if con then e:SetCondition(con) end
	if cost then e:SetCost(cost) end
	if tg then e:SetTarget(tg) end
	e:SetOperation(op)
	if opt then
		if opt=="sopt" then e:SetCountLimit(1)
		elseif type(opt)=="number" and opt>0 then e:SetCountLimit(opt)
		elseif opt=="hopt" then e:SetCountLimit(1,c:GetOriginalCode())
		end
	end
	for i=1,#codes do
		e:SetCode(codes[i])
		c:RegisterEffect(e:Clone(),false,flags[i])
	end
	e:Reset()
end,"handler","codes","desc","cat","prop","typ","range","con","cost","tg","op","opt","flags")

function Auxiliary.SumtypeCon(c,st,con)
	return function(e,tp,eg,ep,ev,re,r,rp) 
		return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and c:IsSummonType(st)
	end
end

function merge(t1, t2, filter)
	filter=filter or false
	if filter==true then
		local dup=false
		for _, i in ipairs(t2) do
			for _, j in ipairs(t1) do
				dup = (i == j)
				if dup then break end
			end
			if not dup then
				table.insert(t1, i)
			end
		end
	else
		for _, i in ipairs(t2) do
			table.insert(t1, i)
		end
	end
end

function Fusion.AddSpellTrapRep(c,s,value,f,...)
	f(...)
	aux.GlobalCheck(s,function()
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD)
		ge:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge:SetTargetRange(LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE+LOCATION_HAND)
		ge:SetTarget(function(e,cc) return cc:IsType(TYPE_SPELL+TYPE_TRAP) end)
		ge:SetValue(value or function(e,cc) if not cc then return false end return cc:IsOriginalCode(c:GetOriginalCode()) end)
		Duel.RegisterEffect(ge,0)
	end)
end

function GetMinMaxMaterialCount(i,...)
	local params={...}
	local min,max=0,0
	for _,t in ipairs(params) do
		for _,val in ipairs(t) do
			min,max=min+val[i],max+val[i+1]
		end
	end
	return min,max
end

--sp_summon condition for Trick monster
function Auxiliary.tricklimit(e,se,sp,st)
	return aux.sumlimit(SUMMON_TYPE_TRICK)(e,se,sp,st)
end

--Filter for unique on field "Ancient Treasure" Traps
function Auxiliary.AncientUniqueFilter(cc)
	local mt=cc:GetMetatable()
	local t= mt.has_ancient_unique or {}
	t[cc]=true
	mt.has_ancient_unique=t
	return 	function(c)
				return not Duel.IsPlayerAffectedByEffect(c:GetControler(),70000111) and c:IsSetCard(0xADFF) and c:IsTrap() and c:IsType(TYPE_CONTINUOUS)
			end
end

--setcode for "D.D." cards
function Card.IsDD(c)
	return (c:IsCode(86498013,15574615,80208158,56790702,82112775,95291684,48092532,9870789,70074904,7572887,52702748,37043180,44792253,89015998,48148828,504700079,75991479,3773196,51701885,24508238,16638212,33423043,60912752,9622164,1127737,511247019,5606466,8628798,76552147) 
	or c:IsSetCard(0xADDD))
end
--Spirisoul return
function Auxiliary.EnableSpirisoulReturn(c,extracat,extrainfo,extraop,returneff)
	if not extracat then extracat=0 end
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND | extracat)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(Auxiliary.SpirisoulReturnCondition1)
	e1:SetTarget(Auxiliary.SpirisoulReturnTarget(c,extrainfo))
	e1:SetOperation(Auxiliary.SpirisoulReturnOperation(c,extraop))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(0)
	e2:SetCondition(Auxiliary.SpirisoulReturnCondition2)
	c:RegisterEffect(e2)
	if returneff then
		e1:SetLabelObject(returneff)
		e2:SetLabelObject(returneff)
	end
end
function Auxiliary.SpirisoulReturnCondition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not e:GetHandler():IsHasEffect(80000753) and 
		(c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_SPSUMMON_TURN) or c:IsStatus(STATUS_FLIP_SUMMON_TURN))
end
function Auxiliary.SpirisoulReturnCondition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsHasEffect(80000753) and 
		(c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_SPSUMMON_TURN) or c:IsStatus(STATUS_FLIP_SUMMON_TURN))
end
function Auxiliary.SpirisoulReturnTarget(c,extrainfo)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
		if extrainfo then extrainfo(e,tp,eg,ep,ev,re,r,rp,chk) end
	end
end
--[[function Auxiliary.SpirisoulReturnSubstituteFilter(c)
	return c:IsCode(14088859) and c:IsAbleToRemoveAsCost()
end]]
function Auxiliary.SpirisoulReturnOperation(c,extraop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		--local sc=Duel.GetFirstMatchingCard(Auxiliary.NecroValleyFilter(Auxiliary.SpirisoulReturnSubstituteFilter),tp,LOCATION_GRAVE,0,nil)
		--if sc and Duel.SelectYesNo(tp,aux.Stringid(14088859,0)) then
			--Duel.Remove(sc,POS_FACEUP,REASON_COST)
		if c:IsType(TYPE_EXTRA) then
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		else
			Duel.SendtoHand(c,nil,2,REASON_EFFECT)
		end
		if c:IsLocation(LOCATION_EXTRA) then
			if extraop then
				extraop(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end

--CanCon summon procedures
function Auxiliary.AddCanConProcedure(c,required,position,filter,value,description)
	if not required or required < 1 then
		required = 1
	end
	filter = filter or aux.TRUE
	value = value or 0
	local e1=Effect.CreateEffect(c)
	if description then
		e1:SetDescription(description)
	end
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(position,1)
	e1:SetValue(value)
	e1:SetCondition(Auxiliary.CanConCondition(required,filter))
	e1:SetTarget(Auxiliary.CanConTarget(required,filter))
	e1:SetOperation(Auxiliary.CanConOperation(required,filter))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.CanConCheck(sg,e,tp,mg)
	return Duel.GetMZoneCount(1-tp,sg,tp)>0
end
function Auxiliary.CanConCondition(required,filter)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		if not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_SPELLCASTER),tp,LOCATION_MZONE,0,1,nil)
        or not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x356),tp,LOCATION_MZONE,0,1,nil) then
            return false
        end
		local mg=Duel.GetMatchingGroup(aux.AND(Card.IsReleasable,filter),tp,0,LOCATION_MZONE,nil)
		return aux.SelectUnselectGroup(mg,e,tp,required,required,Auxiliary.CanConCheck,0)
	end
end
function Auxiliary.CanConTarget(required,filter)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=Duel.GetMatchingGroup(aux.AND(Card.IsReleasable,filter),tp,0,LOCATION_MZONE,nil)
		local g=aux.SelectUnselectGroup(mg,e,tp,required,required,Auxiliary.CanConCheck,1,tp,HINTMSG_RELEASE,nil,nil,true)
		if #g > 0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else
			return false
		end
	end
end
function Auxiliary.CanConOperation(required,filter)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		Duel.Release(g,REASON_COST)
		g:DeleteGroup()
	end
end
--Checks for cards with different names (to be used with Aux.SelectUnselectGroup)
Auxiliary.drcheck=Auxiliary.dpcheck(Card.GetRace)
--d12 dice roll
function Auxiliary.d12(tp)
    local d = Duel.TossDice(tp, 1) -- real dice roll
    local useAlt = Duel.GetTurnCount() % 2 == 1 -- toggle logic or replace with something else
    local d12_map_a = {1,3,5,7,9,11}
    local d12_map_b = {2,4,6,8,10,12}
    local result = useAlt and d12_map_b[d] or d12_map_a[d]
    return result
end
