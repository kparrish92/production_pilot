




## Open all .wav files from "es_wav_files" folder 

#Alternative: (need to comment out the other directory$ line if you don't want to specify the exact directory

directory$ = "se_wav_files"

directory$ = "'directory$'" + "/" 


Create Strings as file list... list 'directory$'*.wav
number_files = Get number of strings


##########  LOAD IN ALL THE FILES ########## 
for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	

endfor # File load loop 