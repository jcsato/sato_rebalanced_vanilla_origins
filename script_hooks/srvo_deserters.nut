::mods_hookExactClass("skills/special/morale_check", function(mc) {
	local getTooltip = ::mods_getMember(mc, "getTooltip");
	local onUpdate = ::mods_getMember(mc, "onUpdate");

	::mods_override(mc, "getTooltip", function() {
		local ret = getTooltip();

		if (getContainer().getActor().isPlayerControlled() && World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.deserters") {
			switch(getContainer().getActor().getMoraleState()) {
				case Const.MoraleState.Wavering:
					local ret = [
						{ id = 1, type = "title", text = getName() }
						{ id = 2, type = "description", text = "Uh oh. This character is wavering and unsure if the battle will turn out to his advantage." }
						{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Resolve" }
						{ id = 12, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Melee Skill" }
						{ id = 13, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Ranged Skill" }
						{ id = 14, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Melee Defense" }
						{ id = 15, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Ranged Defense" }
					];
					return ret;

				case Const.MoraleState.Breaking:
					local ret = [
						{ id = 1, type = "title", text = getName() }
						{ id = 2, type = "description", text = "We can't win this! This character's morale is breaking and he is close to fleeing the battlefield." }
						{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Resolve" }
						{ id = 11, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Melee Skill" }
						{ id = 13, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Skill" }
						{ id = 14, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Melee Defense" }
						{ id = 15, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Defense" }
					];
					return ret;

				case Const.MoraleState.Fleeing:
					local ret = [
						{ id = 1, type = "title", text = getName() }
						{ id = 2, type = "description", text = "Run for your lives! This character has lost it and is fleeing the battlefield in panic." }
						{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-15%[/color] Resolve" }
						{ id = 11, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-15%[/color] Melee Skill" }
						{ id = 13, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-15%[/color] Ranged Skill" }
						{ id = 14, type = "text", icon = "ui/icons/melee_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-15%[/color] Melee Defense" }
						{ id = 15, type = "text", icon = "ui/icons/ranged_defense.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-15%[/color] Ranged Defense" }
						{ id = 16, type = "text", icon = "ui/icons/special.png", text = "Acts at the end of the round" }
					];
					return ret;
			}
		}

		return ret;
	});

	::mods_override(mc, "onUpdate", function(_properties) {
		if (getContainer().getActor().isPlayerControlled() && World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.deserters") {
			m.IsHidden = getContainer().getActor().getMoraleState() == Const.MoraleState.Steady;
			m.Name = Const.MoraleStateName[getContainer().getActor().getMoraleState()];

			switch(getContainer().getActor().getMoraleState()) {
				case Const.MoraleState.Confident:
					m.Icon		= "skills/status_effect_14.png";
					m.IconMini	= "status_effect_14_mini";

					_properties.MeleeSkillMult		*= 1.1;
					_properties.RangedSkillMult		*= 1.1;
					_properties.MeleeDefenseMult	*= 1.1;
					_properties.RangedDefenseMult	*= 1.1;
					break;

				case Const.MoraleState.Wavering:
					m.Icon		= "skills/status_effect_02_c.png";
					m.IconMini	= "status_effect_02_c_mini";

					_properties.BraveryMult			*= 0.95;
					_properties.MeleeSkillMult		*= 0.95;
					_properties.RangedSkillMult		*= 0.95;
					_properties.MeleeDefenseMult	*= 0.95;
					_properties.RangedDefenseMult	*= 0.95;
					break;

				case Const.MoraleState.Breaking:
					m.Icon		= "skills/status_effect_02_b.png";
					m.IconMini	= "status_effect_02_b_mini";

					_properties.BraveryMult			*= 0.9;
					_properties.MeleeSkillMult		*= 0.9;
					_properties.RangedSkillMult		*= 0.9;
					_properties.MeleeDefenseMult	*= 0.9;
					_properties.RangedDefenseMult	*= 0.9;
					break;

				case Const.MoraleState.Fleeing:
					m.Icon		= "skills/status_effect_02_a.png";
					m.IconMini	= "status_effect_02_a_mini";

					_properties.BraveryMult			*= 0.85;
					_properties.MeleeSkillMult		*= 0.85;
					_properties.RangedSkillMult		*= 0.85;
					_properties.MeleeDefenseMult	*= 0.85;
					_properties.RangedDefenseMult	*= 0.85;

					_properties.InitiativeForTurnOrderAdditional	-= 1000;
					break;
			}
		} else
			onUpdate(_properties);
	});
});

::mods_hookExactClass("entity/tactical/player", function(p) {
	local worsenMood = ::mods_getMember(p, "worsenMood");

	::mods_override(p, "worsenMood", function(_a = 1.0, _reason = "") {
		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.deserters")
			_a *= 1.75;

		worsenMood(_a, _reason);
	});
});

::mods_hookExactClass("skills/special/stats_collector", function(sc) {
	local onUpdate = ::mods_getMember(sc, "onUpdate");

	::mods_override(sc, "onUpdate", function(_properties) {
		onUpdate(_properties);

		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.deserters") {
			if (!("State" in Tactical) || Tactical.State == null || Tactical.State.isScenarioMode())
				return;

			if (Time.getRound() <= 1 && World.Assets.getOrigin().getID() == "scenario.deserters")
				_properties.InitiativeForTurnOrderAdditional -= 4000;
		}
	});
});

::mods_hookExactClass("scenarios/world/deserters_scenario", function(ds) {
	local onGetBackgroundTooltip = ::mods_getMember(ds, "onGetBackgroundTooltip");

	::mods_override(ds, "onGetBackgroundTooltip", function(_background, _tooltip) {
		_tooltip.push({ id = 16, type = "text", icon = "ui/icons/special.png", text = "Halves the malus of negative morale effects" });
		_tooltip.push({ id = 17, type = "text", icon = "ui/icons/special.png", text = "All mood loss is [color=" + Const.UI.Color.NegativeValue + "]75%[/color] greater" });
	});
});

::mods_hookBaseClass("scenarios/world/starting_scenario", function(ss) {
    local create = ::mods_getMember(ss, "create");

    ::mods_override(ss, "create", function() {
        create();

        if (m.ID == "scenario.deserters") {
            m.Description = "[p=c][img]gfx/ui/events/event_88.png[/img][/p][p]For too long have you been dragged from one bloody battle to another at the whim of lords sitting in high towers. Last night, you absconded from camp together with three others. You're dressed like soldiers still, but you're deserters, and the noose will be your end if you stay here for too long.\n\n[color=#bcad8c]Deserters:[/color] Start with three deserters and decent armor, but lower funds and a noble house that wants to hunt you down.\n[color=#bcad8c]Downtrodden:[/color] All morale loss is increased by 75%.\n[color=#bcad8c]Better Part of Valor:[/color] The malus of negative morale effects is halved.[/p]";
        }
    });
});
