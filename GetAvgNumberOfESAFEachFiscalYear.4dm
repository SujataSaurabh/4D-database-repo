//@Sujata Goswami

QUERY([Experimenters];[Experimenters]ESAFID="33595")

  // Export_to_file      exports the current selection of [Table]

  // let the user identify the export file
$doc:=Create document("";".csv")
If (OK=1)  // user creates the document
	$exportText:=""
	C_LONGINT($totalRecords)
	
	Begin SQL
		SELECT COUNT(*) from Experimenters INTO :$totalRecords 
	End SQL
	
	ARRAY TEXT($esaf_ids;$totalRecords)
	ARRAY TEXT($exp_ids;$totalRecords)
	ARRAY LONGINT($alsid_count;$totalRecords)
	
	C_DATE($dateStart)
	C_DATE($dateEnd)
	C_DATE($dateRead)
	
	
	For (vYear;2018;2024)
		$dateStart:=Date("10/01/"+String(vYear))
		  //ALERT(STRING($dateStart))
		vYear:=vYear+1
		$dateEnd:=Date("09/30/"+String(vYear))
		Begin SQL
			SELECT COUNT(DISTINCT ALSID), ESAFID from Experimenters  WHERE ESAFID IS NOT NULL AND DateExpStarted>=:$dateStart AND DateExpStarted<=:$dateEnd GROUP BY ESAFID INTO :$alsid_count, :$esaf_ids 
		End SQL
		For ($vIndx;1;Size of array($alsid_count))
			If (String($esaf_ids{$vIndx})="")
			Else 
				  //ALERT(String(vYear)+ "  " + String($esaf_ids{$vIndx})  "  " + String($alsid_count{$vIndx}))
				$exportText:=$exportText+String(vYear)+","
				$exportText:=$exportText+String($esaf_ids{$vIndx})+","
				$exportText:=$exportText+String($alsid_count{$vIndx})+"\r"
			End if 
		End for 
		vYear:=vYear-1
	End for 
	
	SEND PACKET($doc;$exportText)
	CLOSE DOCUMENT($doc)
	SHOW ON DISK(Document)  //  make it easy to find
End if 