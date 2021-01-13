--Es war einmal ein kleiner Hans, der spielte gern mit seinem Schwanz. Im Wald er immer onanierte, bis er sich dort auch noch verirrte. Die Gretel juckt der Fummel sehr, denn ihr Vibrator tuts nicht mehr. Sie folgt der Spur am Waldesboden, vom Samen aus des Hänsels Hoden. Am Baumstamm sieht den Hans sie sitzen und ruft ihm zu: "Jetzt noch nicht spritzen!!" Sie setzt sich stürmisch auf den Rasen und tut dem Hansi einen blasen. Dann gingen beide durch den Wald, und kamen an ein Häuschen bald. Sogleich erwachten die Gelüste aus Schokozipfelzuckerbrüste. Und drinnen ladet zum Duett, ein wunderschönes Wasserbett. Derweil die Gretel Samen schluckt, die Hexe durch das Fenster guckt und denkt mit megageilen Blicken: "Den Kleinen muss ich auch mal f.....!!" Doch als sie hinkam, wars zu spät, des Hänsels Stengel nicht mehr steht. Darüber war sie sehr empört, worauf ihn in den Käfig sperrt. "Du bleibst solange in dem Stall, bis deine Nudel wieder prall!" Mit einer Rübe wie man sieht, täuscht er ihr vor ein steifes Glied. Die Hexe spricht und tut sich bücken: "Du wirst mich jetzt von hinten f......!" Sie freut sich schon auf seinen Grossen, und wird in den Kamin gestoßen. Nach großem, staunenden Entsetzen die Gretel sagt: "Jetzt gemma wetzen!" Die Hexe war nicht mehr dabei, nun frönen sie der Vogelei. Sie machten noch so manche Nummer, doch eines Tages kam der Kummer der Hänsel wurde impotent, drum ist das Märchen jetzt zu End by Tobiz
function c100001134.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c100001134.condition)
	e1:SetTarget(c100001134.target)
	e1:SetOperation(c100001134.activate)
	c:RegisterEffect(e1)
end
function c100001134.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001100) or c:IsFaceup() and c:IsCode(100001101) or c:IsFaceup() and c:IsCode(100001102) or c:IsFaceup() and c:IsCode(100001103) or c:IsFaceup() and c:IsCode(100001112)
end
function c100001134.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100001134.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100001134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100001134.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c100001134.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c100001134.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
