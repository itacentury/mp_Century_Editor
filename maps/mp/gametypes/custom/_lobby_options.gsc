#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

addMinuteToTimer()
{
	timeLimit = getDvarInt("scr_" + level.currentGametype + "_timelimit");
	setDvar("scr_" + level.currentGametype + "_timelimit", timelimit + 1);
}

removeMinuteFromTimer()
{
	timeLimit = getDvarInt("scr_" + level.currentGametype + "_timelimit");
	setDvar("scr_" + level.currentGametype + "_timelimit", timelimit - 1);
}

toggleTimer()
{
	if (!level.timerPaused)
	{
		maps\mp\gametypes\_globallogic_utils::pausetimer();
		level.timerPaused = true;
	}
	else 
	{
		self maps\mp\gametypes\_globallogic_utils::resumetimer();
		level.timerPaused = false;
	}
}

addDummies()
{
	level.spawned_bots++;
	team = self.pers["team"];
	otherTeam = getOtherTeam(team);

	bot = AddTestClient();
	bot.pers["isBot"] = true;
	bot thread maps\mp\gametypes\_bot::bot_spawn_think(otherTeam);
	bot ClearPerks();
}
