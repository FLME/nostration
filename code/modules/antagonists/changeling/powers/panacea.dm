/obj/effect/proc_holder/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing parasites, sobering us, purging toxins and radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious."
	chemical_cost = 20
	dna_cost = 1
	req_stat = UNCONSCIOUS
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_anatomic_panacea"
	action_background_icon_state = "bg_ling"

//Heals the things that the other regenerative abilities don't.
/obj/effect/proc_holder/changeling/panacea/sting_action(mob/user)
	to_chat(user, "<span class='notice'>We cleanse impurities from our form.</span>")

	var/list/bad_organs = list(
		user.getorgan(/obj/item/organ/body_egg),
		user.getorgan(/obj/item/organ/zombie_infection))

	for(var/o in bad_organs)
		var/obj/item/organ/O = o
		if(!istype(O))
			continue

		O.Remove()
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.vomit(0, toxic = TRUE)
		O.forceMove(get_turf(user))

	user.reagents.add_reagent(/datum/reagent/medicine/mutadone, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/pen_acid/pen_jelly, 20)
	user.reagents.add_reagent(/datum/reagent/medicine/antihol, 10)
	user.reagents.add_reagent(/datum/reagent/medicine/mannitol, 25)

	if(isliving(user))
		var/mob/living/L = user
		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.severity == DISEASE_SEVERITY_POSITIVE)
				continue
			D.cure()
	return TRUE