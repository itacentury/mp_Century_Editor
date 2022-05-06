#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

//OUTFIT
initOutfitEditor(player)
{
	self maps\mp\gametypes\_clientids::exitMenu();
	outfits = self initOutfitArray();
	level.currentValue = outfits[0];
	self.currentStep = 0;
	self drawCustomEditor("Outfit");
	self.editorButtons setText("Up/down [{+actionslot 1}] / [{+actionslot 2}] | Set [{+activate}] | Close [{+melee}]");
	wait 0.5;
	self thread customEditorButtonMonitor(player);
}

customEditorButtonMonitor(player)
{
	self endon("death");
	self endon("disconnect");
	self endon("stop_dvarEditor");

	for (;;)
	{
		if (self actionslotonebuttonpressed())
		{
			self customCount(1);
			wait .12;
		}

		if (self actionslottwobuttonpressed())
		{
			self customCount(-1);
			wait .12;
		}

		if (self UseButtonPressed())
		{
			self setNewOutfit(player);
			wait .12;
		}

		if (self MeleeButtonPressed())
		{
			self exitEditor();
			wait .12;
		}

		wait 0.01;
	}
}

customCount(num)
{
	val = self.currentStep + num;
	if (val >= 0 && val <= 4)
	{
		self.currentStep = val;
	}
	else if (val < 0)
	{
		self.currentStep = 4;
	}
	else if (val > 4)
	{
		self.currentStep = 0;
	}

	self updateCustomEditorText();
}

setNewOutfit(player)
{
	class = self resolveOutfitToClass(level.currentValue);
	player.cac_body_type = level.default_armor[class]["body"];
	player.cac_head_type = player maps\mp\gametypes\_armor::get_default_head();
	player.cac_hat_type = "none";
	player maps\mp\gametypes\_armor::set_player_model();
	self iprintln(level.currentValue + " ^2set");
}

updateCustomEditorText()
{
	level.currentValue = self resolveStepToOutfit(self.currentStep);
	self.editorText setText(level.currentValue);
}

//DVAR
initDvarEditor(dvar)
{
	self maps\mp\gametypes\_clientids::exitMenu();
	level.currentValue = getDvarFloat(dvar);
	stepUp = self getDvarSteps(dvar)[0];
	stepDown = self getDvarSteps(dvar)[1];
	self drawCustomEditor(dvar);
	self.editorButtons setText("Up/down [{+actionslot 1}] / [{+actionslot 2}] | Set [{+activate}] | Reset [{+gostand}] | Close [{+melee}]");
	wait 0.5;
	self thread dvarEditorButtonMonitor(dvar, stepUp, stepDown);
}

dvarEditorButtonMonitor(dvar, stepUp, stepDown)
{
	self endon("death");
	self endon("disconnect");
	self endon("stop_dvarEditor");

	for (;;)
	{
		if (self actionslotonebuttonpressed())
		{
			self countValue(stepUp);
			wait .12;
		}

		if (self actionslottwobuttonpressed())
		{
			self countValue(stepDown);
			wait .12;
		}

		if (self UseButtonPressed())
		{
			self setEditedDvar(dvar);
			wait .12;
		}

		if (self MeleeButtonPressed())
		{
			self exitEditor();
			wait .12;
		}

		if (self jumpButtonPressed())
		{
			self resetEditedDvar();
			wait .12;
		}

		wait 0.01;
	}
}

countValue(num)
{
	val = level.currentValue + num;
	if (val > 0)
	{
		level.currentValue = val;
	}
	self updateEditorText();
}

setEditedDvar(dvar)
{
	setDvar(dvar, level.currentValue);
}

resetEditedDvar(dvar)
{
	level.currentValue = level.timescaleDefault;
	self updateEditorText();
}

exitEditor()
{
	self.dvarName destroy();
	self.editorBackground destroy();
	self.editorText destroy();
	self.editorButtons destroy();
	self ClearAllTextAfterHudelem();
	self notify("stop_dvarEditor");
}

updateEditorText()
{
	self.editorText setText(level.currentValue);
}

//SUPPORT FUNCTIONS
drawCustomEditor(text)
{
	self.dvarName = self maps\mp\gametypes\_clientids::createText("small", 1, "CENTER", "CENTER", 0, -5, 3, "");
	self.dvarName setText(text);
	self.editorBackground = self maps\mp\gametypes\_clientids::createRectangle("CENTER", "CENTER", 0, 0, 125, 30, 2, "black");
	self.editorText = self maps\mp\gametypes\_clientids::createText("small", 1, "CENTER", "CENTER", 0, 5, 3, "");
	self.editorText setText(level.currentValue);
	self.editorButtons = self maps\mp\gametypes\_clientids::createText("small", 1, "CENTER", "CENTER", 0, 20, 3, "");
}

initOutfitArray()
{
	outfitArray = [];
	outfitArray[0] = "Lightweight";
	outfitArray[1] = "Scavenger";
	outfitArray[2] = "Flak Jacket";
	outfitArray[3] = "Hardliner";
	outfitArray[4] = "Ghost";
	return outfitArray;
}

resolveStepToOutfit(step)
{
	outfit = "";
	switch (step)
	{
		case 0:
			outfit = "Lightweight";
			break;
		case 1:
			outfit = "Scavenger";
			break;
		case 2:
			outfit = "Flak Jacket";
			break;
		case 3:
			outfit = "Hardliner";
			break;
		case 4:
			outfit = "Ghost";
			break;
		default:
			outfit = "Lightweight";
			break;
	}

	return outfit;
}

resolveOutfitToClass(outfit)
{
	class = "";
	switch (outfit)
	{
		case "Lightweight":
			class = "CLASS_SMG";
			break;
		case "Scavenger":
			class = "CLASS_ASSAULT";
			break;
		case "Flak Jacket":
			class = "CLASS_LMG";
			break;
		case "Hardliner":
			class = "CLASS_QCB";
			break;
		case "Ghost":
			class = "CLASS_SNIPER";
			break;
		default:
			class = "CLASS SMG";
			break;
	}

	return class;
}

getDvarSteps(dvar)
{
	step[0] = 1;
	step[1] = -1;
	switch (dvar)
	{
		case "timescale":
			step[0] = 0.1;
			step[1] = -0.1;
			break;
		default:
			step[0] = 1;
			step[1] = -1;
			break;
	}

	return step;
}