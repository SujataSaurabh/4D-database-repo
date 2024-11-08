
If (False)
	  //import Entity list
	  // Routine to Import a job code
	
	If (CheckLevel (<>LEVEL1))
		C_TEXT($EntityName;$EntityCountry)
		$found:=0
		$imported:=0
		$bad:=0
		sD:=Open document("")  //allows user to enter file name and location
		If (OK=1)
			CREATE EMPTY SET([Institutions];"ImportSet")
			Repeat 
				  // Now read one Record
				RECEIVE PACKET(sD;$EntityName;<>TAB)
				$EntityName:=StripQuotes ($EntityName)
				$EntityName:=StripOutChars ($EntityName)
				$EntityName:=StripLeadingBlanks ($EntityName)
				QUERY([Institutions];[Institutions]InstitutionName=$EntityName)
				If (Records in selection([Institutions])>0)
					$found:=$found+1
				End if 
				If (OK=1)
					RECEIVE PACKET(sD;$EntityCountry;<>LF)
					$imported:=$imported+1
					
					If (True)
						  // ALERT($EntityName+$EntityCountry)
						CREATE RECORD([Institutions])
						[Institutions]InstitutionID:=Sequence number([Institutions])
						[Institutions]InstitutionName:=$EntityName
						[Institutions]EntityCountry:=$EntityCountry
						[Institutions]OrganizationType:="Foreign Industry"
						[Institutions]OrganizationTypeID:=1740
						[Institutions]RecCreateDate:=Current date
						[Institutions]RecWhoCreated:=<>UserName
						SAVE RECORD([Institutions])
						CREATE RECORD([InstitutionTypes])
						[InstitutionTypes]InstitutionID:=[Institutions]InstitutionID
						[InstitutionTypes]Designation:="EntityList"
						SAVE RECORD([InstitutionTypes])
					End if 
					
				End if 
				
			Until (OK=0)
			CLOSE DOCUMENT(sD)
			USE SET("ImportSet")
			ALERT(String($imported)+" were imported, and  "+String($found)+" had same name")
			CLEAR SET("ImportSet")
		End if 
		
	End if 
	
End if 