C_TEXT($1;$IPAddress)
C_BOOLEAN($0)

$IPAddress:=$1
$ValidIP:=False


If (False)  //if checking physical IP addresses
	$IPCount:=7
	ARRAY TEXT(ArrIPAddresses;$IPCount)
	
	  //ALSUSWEB
	ArrIPAddresses{1}:=<>PRODUCTIONSERVERIP
	ArrIPAddresses{2}:=<>QASERVERIP
	ArrIPAddresses{3}:=<>DEVELOPSERVERIP
	
	  //ALSHUB
	ArrIPAddresses{4}:=<>ALSHUBServerPRODIP
	ArrIPAddresses{5}:=<>ALSHUBServerQAIP
	
	  //ALSScheduler
	ArrIPAddresses{6}:=<>ALSSchedServerIP
	ArrIPAddresses{7}:=<>ALSESAFServerIP
	  //ArrIPAddresses{7}:=<>ALSSchedServerQAIP
	
	  //ALSESAF
	  //ArrIPAddresses{8}:=<>ALSESAFServerIP
	  //ArrIPAddresses{9}:=<>ALSESAFServerQAIP
	
	  //Check if valid IP
	$index:=Find in array(ArrIPAddresses;$IPAddress)
	If ($index>0)
		$ValidIP:=True
	End if 
	
	
	  //For now just check the first part of the LBL Domains
	If ((Substring(<>WebClientIP;1;7)="131.243") | (Substring(<>WebClientIP;1;6)="128.55"))
		$ValidIP:=True
	End if 
	
End if 

  //When adding cloudflare allow all services
$ValidIP:=True


$0:=$ValidIP
