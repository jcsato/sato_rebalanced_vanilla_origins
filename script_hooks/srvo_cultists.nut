::mods_hookBaseClass("scenarios/world/starting_scenario", function(ss) {
	local onSpawnAssets = ::mods_getMember(ss, "onSpawnAssets");
    local onInit = ::mods_getMember(ss, "onInit");

	::mods_override(ss, "onSpawnAssets", function() {
		onSpawnAssets();

        if (m.ID == "scenario.cultists") {
			World.Statistics.getFlags().set("SatoCultistsLastSacrificeEvent", 0);
			World.Statistics.getFlags().set("SatoCultistsLastSacrificeCheckedDay", 0);
			World.Statistics.getFlags().set("SatoCultistsSacrificeDelayDays", 0);
        }
	});

    ::mods_override(ss, "onInit", function() {
        onInit();

        if (m.ID == "scenario.cultists") {
            if (!(World.Statistics.getFlags().get("SatoCultistsEventsAdded"))) {
                local mundaneEvents = IO.enumerateFiles("scripts/events/cultists_events");
                foreach ( i, event in mundaneEvents ) {
                    local instantiatedEvent = new(event);
                    World.Events.m.Events.push(instantiatedEvent);
                };
            }
            World.Statistics.getFlags().set("SatoCultistsEventsAdded", true);

			World.Events.addSpecialEvent("event.sato_cultists_sacrifice_event");
        }
    });
});

::mods_hookNewObject("events/events/dlc4/cultist_origin_sacrifice_event", function(cose) {
	cose.onUpdateScore = function() {
		return;
	}
});
