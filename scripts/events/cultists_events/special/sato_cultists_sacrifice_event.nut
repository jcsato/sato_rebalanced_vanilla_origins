sato_cultists_sacrifice_event <- inherit("scripts/events/event", {
	m = {
		Sacrifice			= null
		Sacrifice1			= null
		Sacrifice2			= null
	}

	function create()
	{
		m.ID		= "event.sato_cultists_sacrifice_event";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_140.png[/img]{Most would consider the dream to have been a nightmare: the darkness surrounded you, a black so flat you could reach out and touch it. The voice spoke a language you'd never heard before, and yet you understood it nonetheless. Two faces emerged for the infinite shade: %sac1% and %sac2%. The men seemed so close, yet when you reached out they shrank, as though your fingers stretched infinitely into the void.\n\n Upon waking, you knew what must be done. But a trust had been put in you here, a trust by Davkul. A trust to do what few men can: make a choice. | Davkul's presence arrived during a campfire. The rest of the men faded into the aether of infinite black, and a strange entity replaced them. An entity which you could not see, but whose presence was but a penumbra of crossing shadows. It requested a sacrifice, not by speaking to you, but by showing: %sac1% and %sac2%. First one melted away before revivifying, then the other repeated the process until both existed with their hands out and eyes closed. It was clear that Davkul was trusting you with a choice. \n\n When the shadows snapped away, the campfire was blinding. %sac1% and %sac2% were staring at you.%SPEECH_ON%Is all alright, sir?%SPEECH_OFF% | You traveled to the place. You knew you were sleeping, but you knew damn well you traveled there nonetheless, shifting beyond your mind, beyond your body, coursing over the earth, over its rivers, across its dry earth, and past the mountains which would crumble. There you found Davkul, the immutable darkness, the inviting shade.\n\n %sac1% and %sac2% were already there, standing closest to you and Davkul's shape shifted restlessly behind their images. A black hand of fog pushed one man forward and then yanked him back, then repeated it with the other man. You nodded in understanding. A sacrifice was required and you were to choose.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
							{
								Text = "Though inexperienced, %sac1% will have the honor to meet Davkul."
								function getResult(_event) {
									_event.m.Sacrifice = _event.m.Sacrifice1;
									return "B";
								}
							},
							{
								Text = "Few have dealt out such death as our veteran, %sac2%. Davkul will be pleased to meet him."
								function getResult(_event) {
									_event.m.Sacrifice = _event.m.Sacrifice2;
									return "B";
								}
							}
						]

			function start(_event) {
				Characters.push(_event.m.Sacrifice1.getImagePath());
				Characters.push(_event.m.Sacrifice2.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_140.png[/img]{%sacrifice% is bound and put to the fire. The smell of burnt pork fills the air and the men around you rejoice with tears in their eyes. You see a face twisting in the smoke of the sacrifice, a knowing visage that approves. The men are emboldened. | %sacrifice% is chopped to pieces until he is but a torso and head. The blood has emptied across the ground and yet there's still light in his eyes and a perverse smile upon his face. You take an axehead and run it into his throat until he is no more. Every bodypart is separated and put upon a pole, caked in grease, and lit aflame. You and the men dance beneath the pyres as the night comes and the night goes. | The procession is such: %sacrifice% is flayed alive and pierced with sharpened sticks through each limb and held aloft, spread-eagled over a fire which cooks him until death. The men watch his passing in silence, but as soon as one of his charred limbs breaks and collapses his corpse into the flames the men cheer and hoot and holler, some pray, others roll around in the ashes of %sacrifice%, some licking it off their fingertips like it were sweets. It is a good night. | A long stick is pierced through %sacrifice% from posterior to out the side of his neck. He is tilted up into the sky and held there by one man while others use long spears to stab him through until his corpse is the apex of an uncovered tent. The conical corpse is then covered with grass and mud until there stands a tipi, a torso and head of %sacrifice% all that remains above, and should you enter the tent you would find his legs dangling from its ceiling. The monument should stand as an omen for those to come, and a sign that they should come to accept that which awaits us all.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
							{
								Text = "A reminder for us all."
								function getResult(_event) { return 0; }
							}
						]

			// Welcome to the code gore zone, all ye who enter, here be dragons, etc. etc.
			function start(_event) {
				Characters.push(_event.m.Sacrifice.getImagePath());

				local veteranSacrifice = _event.m.Sacrifice.getID() == _event.m.Sacrifice2.getID();
				local sacrificeRank = 0;
				if (_event.m.Sacrifice.getBackground().getID() == "background.cultist" || _event.m.Sacrifice.getBackground().getID() == "background.converted_cultist") {
					if (_event.m.Sacrifice.getSkills().hasSkill("trait.cultist_chosen"))
						sacrificeRank = 5;
					else if (_event.m.Sacrifice.getSkills().hasSkill("trait.cultist_disciple"))
						sacrificeRank = 4;
					else if (_event.m.Sacrifice.getSkills().hasSkill("trait.cultist_acolyte"))
						sacrificeRank = 3;
					else if (_event.m.Sacrifice.getSkills().hasSkill("trait.cultist_zealot"))
						sacrificeRank = 2;
					else if (_event.m.Sacrifice.getSkills().hasSkill("trait.cultist_fanatic"))
						sacrificeRank = 1;
				}

				local dead = _event.m.Sacrifice;
				local fallen = {
					Name				= dead.getName()
					Time				= World.getTime().Days
					TimeWithCompany		= Math.max(1, dead.getDaysWithCompany())
					Kills				= dead.getLifetimeStats().Kills
					Battles				= dead.getLifetimeStats().Battles
					KilledBy			= "Sacrificed to Davkul"
					Expendable			= dead.getBackground().getID() == "background.slave"
				};
				World.Statistics.addFallen(fallen);

				List.push( { id = 13, icon = "ui/icons/kills.png", text = _event.m.Sacrifice.getName() + " has died" } );
				_event.m.Sacrifice.getItems().transferToStash(World.Assets.getStash());
				World.getPlayerRoster().remove(_event.m.Sacrifice);

				local brothers = World.getPlayerRoster().getAll();
				local hasProphet = false;
				local highestRankBro = null;
				local highestRankBroRank = 0;

				// If you sacrificed your highest rank bro, your next highest bro will get auto-bumped to his rank before normal rank up logic
				foreach ( bro in brothers ) {
					if (bro.getBackground.getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist") {
						if (bro.getSkills().hasSkill("trait.cultist_prophet")) {
							hasProphet = true;
							highestRankBro = bro;
							highestRankBroRank = 6;
						} else {
							if (bro.getSkills().hasSkill("trait.cultist_chosen") && highestRankBroRank < 5) {
								highestRankBro = bro;
								highestRankBroRank = 5;
							} else if (bro.getSkills().hasSkill("trait.cultist_disciple") && highestRankBroRank < 4) {
								highestRankBro = bro;
								highestRankBroRank = 4;
							} else if (bro.getSkills().hasSkill("trait.cultist_acolyte") && highestRankBroRank < 3) {
								highestRankBro = bro;
								highestRankBroRank = 3;
							} else if (bro.getSkills().hasSkill("trait.cultist_zealot") && highestRankBroRank < 2) {
								highestRankBro = bro;
								highestRankBroRank = 2;
							} else if (bro.getSkills().hasSkill("trait.cultist_fanatic") && highestRankBroRank < 1) {
								highestRankBro = bro;
								highestRankBroRank = 1;
							}
						}
					}
				}

				if (highestRankBro != null && sacrificeRank > highestRankBroRank) {
					local skills = highestRankBro.getSkills();
					local skill = null;

					switch (highestRankBroRank) {
						case 4:
							skills.removeByID("trait.cultist_disciple");
							break;
						case 3:
							skills.removeByID("trait.cultist_acolyte");
							break;
						case 2:
							skills.removeByID("trait.cultist_zealot");
							break;
						case 1:
							skills.removeByID("trait.cultist_fanatic");
							break;
					}

					switch (sacrificeRank) {
						case 5:
							skill = new("scripts/skills/traits/cultist_chosen_trait");
							skills.add(skill);
							break;
						case 4:
							skill = new("scripts/skills/traits/cultist_disciple_trait");
							skills.add(skill);
							break;
						case 3:
							skill = new("scripts/skills/traits/cultist_acolyte_trait");
							skills.add(skill);
							break;
						case 2:
							skill = new("scripts/skills/traits/cultist_zealot_trait");
							skills.add(skill);
							break;
						case 1:
							skill = new("scripts/skills/traits/cultist_fanatic_trait");
							skills.add(skill);
							break;
					}
				}

				foreach ( bro in brothers ) {
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist") {
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= Const.MoodState.Neutral)
							List.push( { id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] } );

						if (Math.rand(1, 100) > 50 || veteranSacrifice)
							continue;

						local skills = bro.getSkills();
						local skill = null;

						if (skills.hasSkill("trait.cultist_prophet"))
							continue;
						else if (skills.hasSkill("trait.cultist_chosen")) {
							if (hasProphet || !veteranSacrifice)
								continue;

							hasProphet = true;

							updateAchievement("VoiceOfDavkul", 1, 1);

							skills.removeByID("trait.cultist_chosen");
							skill = new("scripts/skills/actives/voice_of_davkul_skill");
							skills.add(skill);
							skill = new("scripts/skills/traits/cultist_prophet_trait");
							skills.add(skill);
						} else if (skills.hasSkill("trait.cultist_disciple")) {
							skills.removeByID("trait.cultist_disciple");
							skill = new("scripts/skills/traits/cultist_chosen_trait");
							skills.add(skill);
						} else if (skills.hasSkill("trait.cultist_acolyte")) {
							skills.removeByID("trait.cultist_acolyte");
							skill = new("scripts/skills/traits/cultist_disciple_trait");
							skills.add(skill);
						} else if (skills.hasSkill("trait.cultist_zealot")) {
							skills.removeByID("trait.cultist_zealot");
							skill = new("scripts/skills/traits/cultist_acolyte_trait");
							skills.add(skill);
						} else if (skills.hasSkill("trait.cultist_fanatic")) {
							skills.removeByID("trait.cultist_fanatic");
							skill = new("scripts/skills/traits/cultist_zealot_trait");
							skills.add(skill);
						} else {
							skill = new("scripts/skills/traits/cultist_fanatic_trait");
							skills.add(skill);
						}

						if (skill != null)
							List.push( { id = 10, icon = skill.getIcon(), text = bro.getName() + " is now " + Const.Strings.getArticle(skill.getName()) + skill.getName() } );
					} else if (!bro.getSkills().hasSkill("trait.mad")) {
						bro.worsenMood(4.0, "Horrified by the sacrifice of " + _event.m.Sacrifice.getName());

						if (bro.getMoodState() < Const.MoodState.Neutral)
							List.push( { id = 10, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] } );
					}
				}

				World.Statistics.getFlags().set("SatoCultistsLastSacrificeEvent", World.getTime().Days);
			}
		});
	}

	function isValid() {
		if (!Const.DLC.Wildmen)
			return false;

		if (World.Assets.getOrigin().getID() != "scenario.cultists")
			return false;

		if (Time.getVirtualTimeF() - World.Events.getLastBattleTime() < 5.0)
			return false;

		local brothers = World.getPlayerRoster().getAll();
		local prophetIndex = -1;

		for (local i = 0; i != brothers.len(); ++i) {
			if (brothers[i].getSkills().hasSkill("trait.cultist_prophet")) {
				prophetIndex = i;
				break;
			}
		}

		if (prophetIndex >= 0)
			brothers.remove[prophetIndex];

		brothers.sort(function(_a, _b) {
			if (_a.getXP() < _b.getXP())
				return -1;
			else if (_a.getXP() > _b.getXP())
				return 1;
			return 0;
		});

		local r = Math.rand(0, 3);
		m.Sacrifice1 = brothers[r];
		brothers.remove(r);

		r = Math.rand(brothers.len() - 4, brothers.len() - 1);
		m.Sacrifice2 = brothers[r];

		if (brothers.len() < 4 || r < 0) {
			World.Statistics.getFlags().set("SatoCultistsSacrificeDelayDays", 2);
			return false;
		} else if (World.Statistics.getFlags().getAsInt("SatoCultistsSacrificeDelayDays") > 0)
			World.Statistics.getFlags().increment("SatoCultistsSacrificeDelayDays", -1);

		if (World.getTime().Days > World.Statistics.getFlags().getAsInt("SatoCultistsLastSacrificeCheckedDay")) {
			World.Statistics.getFlags().set("SatoCultistsLastSacrificeCheckedDay", World.getTime().Days);

			if (Math.rand(1, 100) <= 25 * (World.getTime().Days - World.Statistics.getFlags().getAsInt("SatoCultistsLastSacrificeEvent") - World.Statistics.getFlags().getAsInt("SatoCultistsSacrificeDelayDays") - 19))
				return true;
		}

		return false;
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "sac1", m.Sacrifice1.getName() ]);
		_vars.push([ "sac2", m.Sacrifice2.getName() ]);
		_vars.push([ "sacrifice", m.Sacrifice != null ? m.Sacrifice.getName() : "" ]);
	}

	function onClear() {
		m.Sacrifice1 = null;
		m.Sacrifice2 = null;
		m.Sacrifice = null;
	}
});
