#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

toggleGodmode()
{
	if (!self.godmodeEnabled)
	{
		self EnableInvulnerability();
		self iprintln("Godmode ^2Enabled");
		self.godmodeEnabled = true;
	}
	else
	{
		self DisableInvulnerability();
		self iprintln("Godmode ^1Disabled");
		self.godmodeEnabled = false;
	}
}

refillAmmo()
{
	curWeapons = self GetWeaponsListPrimaries();
	offHandWeapons = array_exclude(self GetWeaponsList(), curWeapons);
	offHandWeapons = array_remove(offHandWeapons, "knife_mp");
	for (i = 0; i < curWeapons.size; i++)
	{
		weapon = curWeapons[i];
		self GiveStartAmmo(weapon);
	}

	for (i = 0; i < offHandWeapons.size; i++)
	{
		weapon = offHandWeapons[i];
		self GiveStartAmmo(weapon);
	}
}

ToggleThirdPerson()
{
	if (!self.thirdPerson)
	{
		self setClientDvar("cg_thirdPerson", "1");
		self.thirdPerson = true;
	}
	else
	{
		self setClientDvar("cg_thirdPerson", "0");
		self.thirdPerson = false;
	}
}

doSuicide()
{
	self suicide();
	self.currentMenu = "main";
}