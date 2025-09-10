Instructions to run this pipeline

1. You need a params.txt file - modify accordingly  
	Notice you also need to modify the config.SFs file

2. Input data:  
	A folder with chains/nets - followng the same structure as DESCHRAMBLER, so"  
  
	reference/target/chain  
		and  
	reference/target/net  

3. To run type:  
	perl constructHSBs.pl params.txt  

This will create a new folder with all the files you need already in EH format - you need the one ending in EH.merged  

You can find example data and params file.  
