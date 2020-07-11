import std.stdio;

import game.folders.folder;
import game.folders.chapta.folder_chapta_1;
import std.array : join;
import std.file : mkdirRecurse;
import core.thread : Thread, msecs;

void main()
{
	auto start = createGameFolder();
	createFolderStructure(start);

	initFolderRec(start);

	bool run = true;
	while (run)
	{
		checkFolderRec(start);
		createFolderStructure(start);

		Thread.sleep(1000.msecs);
	}
}

Folder createGameFolder()
{
	auto start = new Folder("Control Panel");

	auto chaptaFolder = new FolderChapta1();
	start.addChild(chaptaFolder);

	return start;
}

void initFolderRec(Folder folder)
{
	folder.onCreate();

	foreach (child; folder.children)
	{
		initFolderRec(child);
	}
}

void checkFolderRec(Folder folder)
{
	if (!folder.isVisible())
	{
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

void createFolderStructure(Folder folder, string[] pathParts = [])
{
	string path = pathParts.join("\\") ~ "\\" ~ folder.name;
	mkdirRecurse(path);

	foreach (child; folder.children)
	{
		if (!child.isVisible())
		{
			continue;
		}

		createFolderStructure(child, pathParts ~ folder.name);
	}
}
