::mods_registerMod("sato_rebalanced_vanilla_origin", 0.1, "Sato's Rebalanced Vanilla Origins");

::mods_queue("sato_rebalanced_vanilla_origin", null, function() {
	::include("script_hooks/srvo_tutorial");
	::include("script_hooks/srvo_deserters");
	::include("script_hooks/srvo_cultists");
});
