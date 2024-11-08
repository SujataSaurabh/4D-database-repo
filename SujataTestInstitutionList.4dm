// List of names to search for
ARRAY TEXT($nameList;3)  // Adjust size as needed
$nameList{1}:="A"
$nameList{2}:="B"
$nameList{3}:="C"

Bool($match_found)

$match_found:=False
  // Loop through each name in the list
For ($i;1;Size of array($nameList))
	  // Query for names containing the current name (case-insensitive)
	QUERY([Institutions];Position(Uppercase([Institutions]InstitutionName);Uppercase($nameList{$i}))>0)
	
	  // Check if there are any records found
	If (Records in selection([Institutions])>0)
		  // Loop through the found records and print the names
		For ($j;0;Records in selection([Institutions]);1)
			  // Print the current name
			  // ALERT([Institutions]InstitutionName)
			$match_found:=True
			  // Move to the next record
			NEXT RECORD([Institutions])
		End for 
	End if 
End for 

ALERT($match_found)