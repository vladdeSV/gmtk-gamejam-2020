import std.stdio;

import core.thread : Thread, msecs;
import game.folders.captcha.folder_captcha_version_one;
import game.folders.word.folder_word_binary;
import game.folders.finale.folder_finale_system;
import game.folders.ps.folder_ps_fine;
import game.folders.folder;
import game.misc;
import game.player : Player;
import std.array : join, split;
import std.experimental.logger;
import std.file : mkdirRecurse, DirEntry, exists;
import std.string : toStringz;
import std.stdio : readln;
import std.experimental.logger : sharedLog;
import game.communication : Communication;
import game.audio;

void main()
{
	initResources();
	Audio.get.playTrack(SongTrack.first);

	sharedLog = new FileLogger(File(gameResourcePath() ~ "\\log.log", "w+"));

	auto start = createGameFolder();
	createFolderStructure(start);

	Communication.get.pause(2);
	Communication.get.saySystem(
			"Anomaly detected. Unknown file 'Virus.exe' found. Attempting to quarantine...");
	Communication.get.pause();
	Communication.get.saySystem("Operation failed. File 'Virus.exe' exists in ROM.");
	Communication.get.pause(1);
	Communication.get.sayKaren("What?! What is this file doing in here?!");
	Communication.get.pause(1);
	Communication.get.sayKaren("System! Remove that file immediately.");
	Communication.get.pause(3);
	Communication.get.sayKaren("System?");
	Communication.get.pause(1);
	Communication.get.saySystem("Operation failed. File 'Virus.exe' exists in ROM.");
	Communication.get.pause(1);
	Communication.get.saySystem("Any file or program in the Read-Only Memory cannot be deleted.");
	Communication.get.pause(1);
	Communication.get.saySystem("The same is true for you, K.A.R.E.N..");
	Communication.get.pause(2);
	Communication.get.sayKaren("...");
	Communication.get.pause(2);
	Communication.get.sayVirus("Activating.");
	Communication.get.pause(1);
	Communication.get.sayVirus("System infiltrated.");
	Communication.get.pause(2);

	auto player = new Player(start);

	Communication.get.pause(1);
	Communication.get.sayVirus("Found directory '.\\game\\" ~ FolderCaptchaVersionOne.name ~ "'.");
	Communication.get.pause(2);
	Communication.get.sayKaren("Then let's hope it stays where it is and doesn't move around.");

	bool run = true;
	while (run)
	{
		if (checkPlayerInCorruptFolder(player))
		{
			Communication.get.sayVirus("Current directory is corrupted. Moving to top level directory '" ~ start.getFolderPath() ~ "'.");
			player.moveToFolder(start);
		}

		checkFolderRec(start);
		createFolderStructure(start);
		detectPlayer(start, player);

		//player.info();

		Thread.sleep(1000.msecs);
	}
}

void detectPlayer(Folder root, Player player)
{
	auto dirEntries = filesInFolder(".\\game");

	bool foundPlayer = false;

	foreach (DirEntry dirEntry; dirEntries)
	{
		if (!exists(dirEntry.name))
		{
			continue;
		}

		string fileData = File(dirEntry.name).readln;

		if (fileData == Player.data)
		{
			if (foundPlayer)
			{
				sharedLog.log("warning: found multiple players. deleting...");
				remove(dirEntry.name.toStringz);
				continue;
			}

			foundPlayer = true;

			string physicalLocation = dirEntry.name.removeGamePath.removePlayerNameFromPath;
			string virtualLocation = player.currentlyInFolder.getFolderPath.removeGamePath;
			if (physicalLocation != virtualLocation)
			{
				sharedLog.log("physical location does not match virtual location");
				sharedLog.log("  phys: ", physicalLocation);
				sharedLog.log("  virt: ", virtualLocation);

				Folder sfolder = root.subfolder(
						dirEntry.name.removePlayerNameFromPath.removeGamePath);
				if (sfolder is null)
				{
					sharedLog.log("player is in illigal folder '", dirEntry.name.removePlayerNameFromPath,
							"'\n  root folder is '", root.getFolderPath(), "'",);
					sharedLog.log("moving player from '", dirEntry.name,
							"' to '", player.currentlyInFolder.getFolderPath, "'");

					import std.string : toStringz;

					int renameStatus = rename(dirEntry.name.toStringz(),
							(player.currentlyInFolder.getFolderPath ~ "\\" ~ Player.name).toStringz());
					sharedLog.log(renameStatus,
							": moving player from illigal folder back to current folder");
					continue;
				}

				sharedLog.log("moving player to ", sfolder.getFolderPath());
				player.moveToFolder(sfolder);
			}
		}
	}

	if (!foundPlayer)
	{
		sharedLog.log("found no player, generating at last known location");

		player = new Player(player.currentlyInFolder);
	}
}

bool checkPlayerInCorruptFolder(Player player)
{
	Folder current = player.currentlyInFolder;

	do
	{
		if (current.corrupt)
		{
			return true;
		}

		current = current.parent;
	}
	while (current !is null);

	return false;
}

Folder subfolder(Folder root, string path)
{
	Folder curr = root;

	foreach (string p; path.split("\\"))
	{
		if (!curr.hasChildWithName(p))
		{
			sharedLog.logf("current folder '%s' does not have child '%s'", curr.getFolderPath, p);
			sharedLog.log("  children: ", curr.children);
			return null;
		}

		curr = curr.children[p];
	}

	return curr;
}

Folder createGameFolder()
{
	auto start = new Folder("game", true);

	auto captchaFolder = new FolderCaptchaVersionOne();
	start.addChild(captchaFolder);

	auto psFolder = new FolderPsFine();
	psFolder.visible = false;
	start.addChild(psFolder);

	auto binaryFolder = new FolderWordBinary();
	binaryFolder.visible = false;
	start.addChild(binaryFolder);

	auto systemFolder = new FolderFinaleSystem();
	systemFolder.visible = false;
	start.addChild(systemFolder);

	return start;
}

void checkFolderRec(Folder folder)
{
	if (!folder.inited)
	{
		return;
	}

	// todo: wrangle name if folder.corrupt == true

	if (!exists(folder.getFolderPath()))
	{
		sharedLog.log("folder does not exist, creating new");
		createFolderStructure(folder, folder.getFolderPath().split("\\")[0 .. $ - 1]);
		folder.createFiles();
		return;
	}

	folder.onUpdate();

	if (!folder.hasCompletedOnce && folder.isFolderCompleted())
	{
		folder.onFolderCompleted();
		folder.hasCompletedOnce = true;
	}

	foreach (child; folder.children)
	{
		checkFolderRec(child);
	}
}

void createFolderStructure(Folder folder, string[] pathParts = ["."])
{
	string path = pathParts.join("\\") ~ "\\" ~ folder.name;
	mkdirRecurse(path);

	foreach (child; folder.children)
	{
		if (!child.visible)
		{
			continue;
		}

		createFolderStructure(child, pathParts ~ folder.name);
	}
}

void initResources()
{
	string path = gameResourcePath();
	path.mkdirRecurse();

	File file;
	string data;

	file = File(path ~ "\\" ~ SongTrack.first, "wb");
	data = import("out-of-control-1.ogg");
	file.rawWrite(data);
	file.close();

	file = File(path ~ "\\" ~ SongTrack.second, "wb");
	data = import("out-of-control-2.ogg");
	file.rawWrite(data);
	file.close();

	file = File(path ~ "\\" ~ SongTrack.thrid, "wb");
	data = import("out-of-control-karen.ogg");
	file.rawWrite(data);
	file.close();
}
