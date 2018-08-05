on run
	classifyItems for (choose file with multiple selections allowed)
end run

to classifyItems for myFiles
	set audioKeywords to {"mp3", "aac", "flac", "wav"}
	set videoExtensions to {"mkv", "m4v", "mov", "mp4"}
	set seasonKeywords to {".S01.", ".S02.", ".S03.", ".S04.", ".S05.", ".S06.", ".S07.", ".S08.", ".S09.", ".S10.", ".S11.", ".S12.", ".S13.", ".S14.", ".S15.", ".S16.", ".S17.", ".S18.", ".S19.", ".S20."}
	set episodeKeywords to {".S01E", ".S02E", ".S03E", ".S04E", ".S05E", ".S06E", ".S07E", ".S08E", ".S09E", ".S10E", ".S11E", ".S12E", ".S13E", ".S14E", ".S15E", ".S16E", ".S17E", ".S18E", ".S19E", ".S20E"}
	set SportsKeywords to {"nhl", "nfl", "ncaa"}
	repeat with anItem in myFiles
		set anItem to anItem as text
		set isVideo to false
		set isTV to false
		set isMovie to false
		set isAudio to false
		set isSports to false
		tell application "System Events" to set {theClass, theName, theExt, theContainer} to {class, name, name extension, container} of disk item anItem --set variables
		
		(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Files  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		if (theClass as text) is not in {"folder", "«class cfol»"} then
			###########  Video ############
			if (theExt as text) is in videoExtensions then --search through all video extensions
				set isVideo to true
				###########  TV ############
				repeat with episodeKeyword in episodeKeywords --search through all tv episode keywords
					if (theName as text) contains episodeKeyword then
						set isTV to true
					end if
				end repeat
				###########  Sports ############
				repeat with sportsKeyword in SportsKeywords --search through all sports keywords
					if (theName as text) contains sportsKeyword then
						set isSports to true
					end if
				end repeat
				###########  Movies ############
				if not isTV and not isSports then set isMovie to true --Set sports if others are false
			end if
			###########  Audio ############
			if (theExt as text) is in audioKeywords then
				set isAudio to true
			end if
		end if --is not folder
		
		(*  &&&&&&&&&&&&&&&&&&&&&&&&&&&&  Folders  &&&&&&&&&&&&&&&&&&&&&&&&&&&& *)
		if (theClass as text) is in {"folder", "«class cfol»"} then
			###########  TV ############
			repeat with seasonKeyword in seasonKeywords --Search all season keywords
				if (theName as text) contains seasonKeyword then
					set isTV to true
				end if
			end repeat
			###########  Audio ############
			repeat with audioExtensions in audioKeywords --Search all season keywords
				if (theName as text) contains audioKeyword then
					set isAudio to true
				end if
			end repeat
			###########  Movie ############
			if not isAudio and not isTV and not isSports then
				set isMovie to true
			end if
		end if
		
		display dialog ("Type:" & theClass & " || Ext:" & theExt & " || Video:" & isVideo & "
		" & theName & "
		Movie:" & isMovie & " || TV:" & isTV & " || Sports:" & isSports & "
		Audio:" & isAudio)
		
	end repeat
end classifyItems
