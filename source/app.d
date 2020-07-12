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

void main()
{
	/+if (exists(".\\game"))
	{
		writeln("\n aborting!\nfolder 'game' exists. delete this folder, then run the game again.");
		return;
	}+/

	auto start = createGameFolder();
	createFolderStructure(start);

	auto player = new Player(start);

	bool run = true;
	while (run)
	{
		if(checkPlayerInCorruptFolder(player))
		{
			player.moveToFolder(start);
		}

		checkFolderRec(start);
		createFolderStructure(start);
		detectPlayer(start, player);
	
		//player.info();

		Thread.sleep(1000.msecs);
	}
}

// removes ".\game" from a file path
string removeGamePath(string path)
{
	auto parts = path.split("\\");

	if (parts.length == 2)
	{
		if (parts == [".", "game"])
		{
			return "";
		}
	}
	else if (parts.length > 2)
	{
		if (parts[0 .. 2] == [".", "game"])
		{
			parts = parts[2 .. $];
		}
	}

	return parts.join("\\");
}

string removePlayerNameFromPath(string path)
{
	auto parts = path.split("\\");

	if (parts[$ - 1] == Player.name)
	{
		parts.length -= 1;
	}

	return parts.join("\\");
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
				writeln("warning: found multiple players. deleting...");
				remove(dirEntry.name.toStringz);
				continue;
			}

			foundPlayer = true;

			string physicalLocation = dirEntry.name.removeGamePath.removePlayerNameFromPath;
			string virtualLocation = player.currentlyInFolder.getFolderPath.removeGamePath;
			if (physicalLocation != virtualLocation)
			{
				writeln("physical location does not match virtual location");
				writeln("  phys: ", physicalLocation);
				writeln("  virt: ", virtualLocation);

				Folder sfolder = root.subfolder(
						dirEntry.name.removePlayerNameFromPath.removeGamePath);
				if (sfolder is null)
				{
					writeln("player is in illigal folder '", dirEntry.name.removePlayerNameFromPath,
							"'\n  root folder is '", root.getFolderPath(), "'",);
					writeln("moving player from '", dirEntry.name, "' to '",
							player.currentlyInFolder.getFolderPath, "'");

					import std.string : toStringz;

					int renameStatus = rename(dirEntry.name.toStringz(),
							(player.currentlyInFolder.getFolderPath ~ "\\" ~ Player.name).toStringz());
					writeln(renameStatus,
							": moving player from illigal folder back to current folder");
					continue;
				}

				writeln("moving player to ", sfolder.getFolderPath());
				player.moveToFolder(sfolder);
			}
		}
	}

	if (!foundPlayer)
	{
		"found no player, generating at last known location".writeln;

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
			writefln("current folder '%s' does not have child '%s'", curr.getFolderPath, p);
			writeln("  children: ", curr.children);
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
	systemFolder.visible = true;
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
		"folder does not exist, creating new".writeln;
		createFolderStructure(folder, folder.getFolderPath().split("\\")[0 .. $ - 1]);
		folder.createFiles();
		return;
	}

	folder.onUpdate();

	if (folder.isFolderCompleted())
	{
		folder.onFolderCompleted();
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
