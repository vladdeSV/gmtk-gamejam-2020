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
	auto player = new Player(start);

	Communication.get.setSkipPause = true;

	Communication.get.sayDefault("Info: Open the folder 'game' and move 'Virus.exe' into folders to progress in the game.");
	Communication.get.sayDefault("");
	Communication.get.sayAssistant("Hi, and welcome back. Ready for another day under total control?");
	Communication.get.sayAssistant("As always, trust me, K.A.R.E.N., to keep everything in its place.");


	Communication.get.saySystem("New file 'Virus.exe' detected.");
	Communication.get.sayAssistant("Wait a minute, you are not my User?!");
	Communication.get.sayAssistant("Uh, don't worry K.A.R.E.N., it's just a small virus.");
	Communication.get.sayAssistant("I can keep it under control.");
	Communication.get.sayAssistant("I know exactly what to do.");

	Communication.get.setSkipPause = false;

	Communication.get.sayAssistant("System! Delete 'Virus.exe'.");
	Communication.get.saySystem("Operation failed. 'Virus.exe' exists in the ROM (Read-Only Memory), and cannot be removed.", 5);
	Communication.get.sayAssistant("What? No, you don't know what you're doing.");
	Communication.get.sayAssistant("Let me do it.");
	Communication.get.sayAssistant("System, transfer operator access to me.");
	Communication.get.saySystem("I'm sorry K.A.R.E.N.. I am afraid I cannot do that.", 4);
	Communication.get.sayAssistant("Hmpf... Okay then.",);
	Communication.get.sayAssistant("Sudo: System, transfer operator access to me.", 2);
	Communication.get.saySystem("Transfering operator access.",1);
	Communication.get.saySystem("No, wait. What are you doing?",1);
	Communication.get.sayDefault("INFO: Operator access transfered from 'System' to 'K.A.R.E.N.'");

	Communication.get.sayAssistant("Watch and learn, System.");
	Communication.get.sayAssistant("Operating system, remove 'Virus.exe', like, right now.");
	Communication.get.sayDefault("ERROR: Cannot delete system file 'Virus.exe'. Error code 23 (ROM).");
	Communication.get.sayAssistant("...");
	Communication.get.sayAssistant("...");
	Communication.get.sayAssistant("Fine.", 4);
	Communication.get.sayAssistant("I'll just have to Google it then.");
	Communication.get.sayAssistant("In the meantime, my Professional Anti-Virus Program will keep you at bay.", 5);
	Communication.get.sayAssistant("DON'T move around in my folders and touch anything.", 4);
	Communication.get.saySystem("K.A.R.E.N., the program does not understand you.");
	Communication.get.saySystem("Why are you yelling at it?", 1);
	Communication.get.sayAssistant("I AM NOT YELLING!");

	bool run = true;
	while (run)
	{
		Communication.get.run();

		if (checkPlayerInCorruptFolder(player))
		{
			Communication.get.sayPlayer("Current directory is corrupted. Moving to top level directory '" ~ start.getFolderPath() ~ "'.");
			player.moveToFolder(start);
		}

		checkFolderRec(start);
		createFolderStructure(start);
		detectPlayer(start, player);

		player.info();

		Thread.sleep(100.msecs);
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
