
property audioKeywords : {"mp3", "aac", "flac", "wav", "m4a", "ac3"}
property videoExtensions : {"mkv", "m4v", "mov", "mp4"}
property rawVideoExtensions : {"vob", "iso", "bdmv"}
property movieFolder : "Mac HDD:Seeds:destinationFolder:Movies"
property rawVideoFolder : "Mac HDD:Seeds:destinationFolder:Movies need work"
property audioFolder : "Mac HDD:Seeds:destinationFolder:Audio"
property tvFolder : "Mac HDD:Seeds:destinationFolder:TV"
property sportsFolder : "Mac HDD:Seeds:destinationFolder:Sports"

on run {input, parameters}
	classifyitems for input
end run 

to classifyItems for myFiles
	repeat with anItem in myFiles
		set anItem to anItem as text
		set isVideo to false
		set isTV to false
		set isMovie to false
		set isRawVideo to false
		set isAudio to false
		set isSports to false
		set isUnknown to false
		tell application "System Events" to set {theClass, theName, theExt, theContainer} to {class, name, name extension, container} of disk item anItem --set variables
		set className to theClass as text
		(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Files  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		if className is "file" then
			set isFolder to false
			#display dialog theExt
			###########  Raw Video (Needs work) ############
			if theExt is in rawVideoExtensions then
				
				set isMovie to true
				set isRawVideo to true
				
				###########  Audio ############
			else if theExt is in audioKeywords then
				set isAudio to true
				
				###########  Video ############
			else if theExt is in videoExtensions then --search through all video extensions
				set isVideo to true
				###########  TV ############
				try
					find text "(?i)\\.S\\d{2}E" in theName with regexp
					set isTV to true
				on error
					###########  Sports ############
					try
						find text "(?i)(nhl|nfl|ncaa)" in theName with regexp
						set isSports to true
					on error
						###########  Movies ############
						set isMovie to true
					end try
				end try
			else
				set isUnknown to true
			end if
			
			(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Folders  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		else if className is "folder" then
			set isFolder to true
			tell application "Finder" to set folderContents to (entire contents of folder anItem) as alias list --Set folder contents to variable
			
			--loop through all folderContents
			repeat with folderContent in folderContents
				set folderContent to folderContent as text
				tell application "System Events" to set {folderItemName, folderItemExt} to {name, name extension} of disk item folderContent --set variables
				
				###########  Raw Video (Needs Work) ############
				if folderItemExt is in rawVideoExtensions then
					set isMovie to true
					set isRawVideo to true
					exit repeat
					###########  Audio ############
				else if folderItemExt is in audioKeywords then
					set isAudio to true
					exit repeat
					###########  Video ############
				else if folderItemExt is in videoExtensions then --search through all video extensions
					set isVideo to true
					try
						###########  TV ############
						find text "(?i)\\.S\\d{2}E" in folderItemName with regexp
						set isTV to true
						exit repeat
					on error
						###########  Sports ############
						try
							find text "(?i)(nhl|nfl|ncaa)" in folderItemName with regexp
							set isSports to true
							exit repeat
						on error
							###########  Movies ############
							set isMovie to true
							exit repeat
						end try
					end try
				else
					set isUnknown to true
				end if
				if (not isUnknown) then exit repeat
			end repeat
		end if
		
		if (isFolder) then
			(*display dialog ("Folder:" & theName & "
Movie:" & isMovie & " || TV:" & isTV & " || Sports:" & isSports & " || Audio:" & isAudio & "
Needs Work:" & isRawVideo)*)
			if (isMovie and not isRawVideo) then
				tell application "Finder" to move folder anItem to folder movieFolder
			else if (isMovie and isRawVideo) then
				tell application "Finder" to move folder anItem to folder rawVideoFolder
			else if (isTV) then
				tell application "Finder" to move folder anItem to folder tvFolder
			else if (isSports) then
				tell application "Finder" to move folder anItem to folder sportsFolder
			else if (isAudio) then
				tell application "Finder" to move folder anItem to folder audioFolder
			end if
			
			
		else if (not isFolder) then
			(*display dialog ("File:" & theName & "
Video:" & isVideo & " || Audio:" & isAudio & "
Movie:" & isMovie & " || Needs Work:" & isRawVideo & "
TV:" & isTV & " || Sports:" & isSports)*)
			if (isMovie and not isRawVideo) then
				tell application "Finder" to move file anItem to folder movieFolder
			else if (isMovie and isRawVideo) then
				tell application "Finder" to move file anItem to folder rawVideoFolder
			else if (isTV) then
				tell application "Finder" to move file anItem to folder tvFolder
			else if (isSports) then
				tell application "Finder" to move file anItem to folder sportsFolder
			else if (isAudio) then
				tell application "Finder" to move file anItem to folder audioFolder
			end if
		end if
	end repeat
end classifyItems
