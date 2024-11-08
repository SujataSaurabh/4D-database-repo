$doc:=Create document("";".csv")
If (OK=1)  // user creates the document
	ALERT("file created")
End if 

  // Declare a collection to hold unique names
ARRAY TEXT($uniqueNames;0)

  // Query all records in the People table
QUERY([People];True)

  // Loop through all records and collect unique names
If (Records in selection([People])>0)
	For ($i;0;Records in selection([People]);1)
		$currentName:=[People]Institution
		
		  // Check if the name is already in the unique names array
		$found:=Count in array($uniqueNames;$currentName)
		If ($found=0)
			APPEND TO ARRAY($uniqueNames;$currentName)  // Add unique name
		End if 
		
		  // Move to the next record
		NEXT RECORD([People])
	End for 
End if 

$exportText:=""
If (Size of array($uniqueNames)>0)
	For ($j;1;Size of array($uniqueNames))
		$exportText:=$exportText+$uniqueNames{$j}+"\n"
	End for 
End if 

SEND PACKET($doc;$exportText)
CLOSE DOCUMENT($doc)
SHOW ON DISK(Document)  //  make it easy to find