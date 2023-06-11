::mods_hookBaseClass("scenarios/world/starting_scenario", function(ss) {
	local onSpawnAssets = ::mods_getMember(ss, "onSpawnAssets");

	::mods_override(ss, "onSpawnAssets", function() {
		onSpawnAssets();

        if (m.ID == "scenario.tutorial") {
            local bros = World.getPlayerRoster().getAll();
            bros[0].m.PerkPoints = 2;
            bros[0].m.LevelUps = 2;
            bros[0].m.Level = 3;

            local items = bros[0].getItems();
            items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));
            items.equip(new("scripts/items/shields/heater_shield"));

            bros[1].m.PerkPoints = 2;
            bros[1].m.LevelUps = 2;
            bros[1].m.Level = 3;

            items = bros[1].getItems();
            items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
            local armors = [ "gambeson", "padded_leather", "leather_lamellar" ]
            items.equip(new("scripts/items/armor/" + armors[Math.rand(0, armors.len() - 1)]));

            bros[2].m.PerkPoints = 2;
            bros[2].m.LevelUps = 2;
            bros[2].m.Level = 3;

            items = bros[2].getItems();
            items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
            local helmets = [ "hood", "headscarf" ]
            items.equip(new("scripts/items/helmets/" + helmets[Math.rand(0, helmets.len() - 1)]));
        }
	});
});
