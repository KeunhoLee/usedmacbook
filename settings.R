Sys.setenv(SCRIPT_HOME = 'src/')
Sys.setenv(DATA_HOME = 'data/')
SCRIPT_HOME <- Sys.getenv('SCRIPT_HOME')
DATA_HOME   <- Sys.getenv('DATA_HOME')

?Sys.setenv

#options(verbose = FALSE)
Sys.getenv() 

readRenviron('.env')
?readRenviron

print(paste0( 'SCRIPT_HOME : ', SCRIPT_HOME) )
print(paste0( 'DATA_HOME : ', DATA_HOME) )
# 
# Add-Content c:\Users\$env:USERNAME\Documents\.Renviron "SCRIPT_HOME='src/'"
# Add-Content c:\Users\$env:USERNAME\Documents\.Renviron "DATA_HOME='data/'"