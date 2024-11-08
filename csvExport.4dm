 // Export_to_file      exports the current selection of [Table]

  // let the user identify the export file
$doc:=Create document("";".csv")
If (OK=1)  // user creates the document
	
	$exportText:=""
	
	QUERY([Experimenters];true)
	
	While (Not(End selection([Experimenters])))
		$exportText:=$exportText+[Experimenters]ESAFID+","
		$exportText:=$exportText+[Experimenters]PI+","
		$exportText:=$exportText+String([Experimenters]DateExpStarted)+"\r"  // note the CR as the eol
		NEXT RECORD([Experimenters])
	End while 
	
	  //  now write the data to file
	SEND PACKET($doc;$exportText)
	CLOSE DOCUMENT($doc)
	SHOW ON DISK(Document)  //  make it easy to find
	
End if 