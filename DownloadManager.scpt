
property audioKeywords : {"mp3", "aac", "flac", "wav"}
property videoExtensions : {"mkv", "m4v", "mov", "mp4"}

on run
	set {button returned:buttonReturned} to display dialog "Choose files or folders" buttons {"Cancel", "Choose Files", "Choose Folders"}
	if buttonReturned is "Choose Files" then
		classifyItems for (choose file with multiple selections allowed)
	else
		classifyItems for (choose folder with multiple selections allowed)
	end if
	
end run

on open theItems
	classifyItems for theItems
end open

to classifyItems for myFiles
	repeat with anItem in myFiles
		set anItem to anItem as text
		set isVideo to false
		set isTV to false
		set isMovie to false
		set isAudio to false
		set isSports to false
		tell application "System Events" to set {theClass, theName, theExt, theContainer} to {class, name, name extension, container} of disk item anItem --set variables
		set className to theClass as text
		(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Files  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		if className is "file" then
			###########  Video ############
			if theExt is in videoExtensions then --search through all video extensions
				set isVideo to true
				###########  TV ############
				try
					find text "\\.S\\d{2}E" in theName with regexp
					set isTV to true
				on error
					###########  Sports ############
					try
						find text "(nhl|nfl|ncaa)" in theName with regexp
						set isSports to true
					on error
						###########  Movies ############
						set isMovie to true
					end try
				end try
				###########  Audio ############
			else if theExt is in audioKeywords then
				set isAudio to true
			end if
			
			(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Folders  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		else if className is "folder" then
			###########  TV ############
			try
				find text "\\.S\\d{2}\\." in theName with regexp
				set isTV to true
			on error
				try
					###########  Audio ############
					find text "(mp3|aac|flac|wav)" in theName with regexp
					set isAudio to true
				on error
					###########  Movie ############
					set isMovie to true
				end try
			end try
		end if
		
		display dialog ("Type:" & theClass & " || Ext:" & theExt & " || Video:" & isVideo & "
        " & theName & "
        Movie:" & isMovie & " || TV:" & isTV & " || Sports:" & isSports & "
        Audio:" & isAudio)
		
	end repeat
end classifyItems
