C_LONGINT($totalRecords)

Begin SQL
	SELECT COUNT(*) from Experimenters INTO :$totalRecords 
End SQL

ARRAY TEXT($esaf_ids;$totalRecords)
ARRAY DATE($esaf_date;$totalRecords)

C_LONGINT($countEsafs2018;0)
C_LONGINT($countEsafs2019;0)
C_LONGINT($countEsafs2020;0)
C_LONGINT($countEsafs2021;0)
C_LONGINT($countEsafs2022;0)
C_LONGINT($countEsafs2023;0)
C_LONGINT($countEsafs2024;0)
C_LONGINT($countEsafs;7)

C_DATE($startYear2018)
C_DATE($endYear2018)
$startYear2018:=Date("10/01/17")
$endYear2018:=Date("09/31/18")

C_DATE($startYear2019)
C_DATE($endYear2019)
$startYear2019:=Date("10/01/18")
$endYear2019:=Date("09/31/19")

C_DATE($startYear2020)
C_DATE($endYear2020)
$startYear2020:=Date("10/01/19")
$endYear2020:=Date("09/31/20")

C_DATE($startYear2021)
C_DATE($endYear2021)
$startYear2021:=Date("10/01/20")
$endYear2021:=Date("09/31/21")

C_DATE($startYear2022)
C_DATE($endYear2022)
$startYear2022:=Date("10/01/21")
$endYear2022:=Date("09/31/22")


C_DATE($startYear2023)
C_DATE($endYear2023)
$startYear2023:=Date("10/01/22")
$endYear2023:=Date("09/31/23")


C_DATE($startYear2024)
C_DATE($endYear2024)
$startYear2024:=Date("10/01/23")
$endYear2024:=Date("09/31/24")

  //$startYear:=Date("10/01/23")
  //$endYear:=Date("09/31/24")

  // Tracy: get the number of unique ESAFs every year then average them
  // --- 
Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2024 AND DateExpCompleted<=:$endYear2024 INTO :$countEsafs2024
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2023 AND DateExpCompleted<=:$endYear2023 INTO :$countEsafs2023
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2022 AND DateExpCompleted<=:$endYear2022 INTO :$countEsafs2022
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2021 AND DateExpCompleted<=:$endYear2021 INTO :$countEsafs2021
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2020 AND DateExpCompleted<=:$endYear2020 INTO :$countEsafs2020
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2019 AND DateExpCompleted<=:$endYear2019 INTO :$countEsafs2019
End SQL

Begin SQL
	SELECT COUNT(DISTINCT ESAFID) from Experimenters  WHERE DateExpStarted>=:$startYear2018 AND DateExpCompleted<=:$endYear2018 INTO :$countEsafs2018
End SQL

  //ALERT(String($countEsafs2018)+ "  " + String($countEsafs2019)+ "  " + String($countEsafs2020)+ "  " + String($countEsafs2021)+ "  " + String($countEsafs2022)+ "  " + String($countEsafs2023)+ "  " + String($countEsafs2024))

C_LONGINT($avg;0)
avg:=($countEsafs2018+$countEsafs2019+$countEsafs2020+$countEsafs2021+$countEsafs2022+$countEsafs2023+$countEsafs2024)/7
ALERT(String($countEsafs2018)+"  "+String($countEsafs2019)+"  "+String($countEsafs2020)+"  "+String($countEsafs2021)+"  "+String($countEsafs2022)+"  "+String($countEsafs2023)+"  "+String($countEsafs2024)+" avg =  "+String($avg))
