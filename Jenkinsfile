@NonCPS
List<List<Object>> get_map_entries(map) {
    map.collect {v -> [v]}
}


openssl_sem_version="1.0.2-E"+"."+env.BUILD_NUMBER
println "version string is, value : ${openssl_sem_version}"

CrateUtilSlaveDownloadPath = "C:\\bin\\crate"
WindowsCrateArtifactURL = "http://au-se-build-master.autodesk.com:8080/job/art-crate-windows/lastSuccessfulBuild/artifact/dist/crate-Windows.zip"
WindowsGitBashUtilPath = "C:\\Program Files\\Git\\git-bash.exe"
CrateUtilArtifactName = "crate-Windows.zip"

node('GEC3P') {

	StageDir = pwd() + '\\stage'
	
	stage 'Checkout'
	
	checkout scm
	_CreateCleanDir(StageDir)
	
    stage 'Build & Package 32 bit'
	   bat 'adsk_install.bat x86 vc14'
	
   stage 'Build & Package 64 bit'
          bat 'adsk_install.bat x64 vc14'
		
   stage 'Digital Stamping Assemblies'
          _SignAssemblies(StageDir)
         
    stage 'Create Packages'
	   _CreateCleanDir(CrateUtilSlaveDownloadPath)
	   _DownloadFileFromURL(WindowsCrateArtifactURL,CrateUtilSlaveDownloadPath,WindowsGitBashUtilPath)
	   _UncompressUtil(CrateUtilSlaveDownloadPath,CrateUtilArtifactName)
	   _CreatePackages()
	   
   stage 'Deploy to Artifactory'
	   _DeployToArtifactory()
	
}

def _SignAssemblies(String StagingDir) {

		dir(StagingDir){
		   def signutil = tool 'SignTool'
		   def signcert = tool 'DigiCert'
		   def sha2options = tool 'SHA256_Switches'
		   withEnv(["SIGN_TOOL=$signutil","SigCert=$signcert","SHA2=$sha2options"]) {
			    
			    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'ea933843-3508-4eb9-ac1f-d4dcadc47416', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
			   				    bat 'for /R %%f in (*.dll,*.exe) do ("%SIGN_TOOL%" %SigCert% /p %PASSWORD% %SHA2% %%f)'
				    			
			    }
				
		   }
		
		}
}

def _CreateCleanDir(String SlaveUtilDirectory) {
    env.SlaveUtilDirectory = SlaveUtilDirectory
	
	if ( fileExists(SlaveUtilDirectory) ) {
		retry(3){
		    bat 'rd %SlaveUtilDirectory% /s /q'
		}
		retry(3){
		    bat 'mkdir %SlaveUtilDirectory%'
		}
	} else {
		retry(3){
		   bat 'mkdir %SlaveUtilDirectory%'
		}
	}
}			

def _DownloadFileFromURL(String URLPathToDownload, String DirectoryToDownload, String GitBashPath) {
	env.URLPathToDownload = URLPathToDownload
	env.DirectoryToDownload = DirectoryToDownload
	env.GitBashPath = GitBashPath
	dir(DirectoryToDownload) {
		bat '"%GitBashPath%" -c "curl -O %URLPathToDownload%"'
	}
}

def _UncompressUtil(String UtilDirectory, String UtilFileName) {
    
	dir(UtilDirectory) {
		if(fileExists(UtilFileName)) { 
			env.UtilFileName = UtilFileName
			def JAVA_HOME = tool 'jdk1.8.0_45'
			env.JAVA_HOME = JAVA_HOME
			bat '"%JAVA_HOME%\\bin\\jar" xf %UtilFileName%'
		} else { 
			println "Error: $UtilFileName found missing in $UtilDirectory"
		}
	}
}

def _CreatePackages() {  
    
        def StageDirs = ["win_vc14_release_bin_x64","win_vc14_release_lib_x64","win_vc14_release_sym_x64",
                 "win_vc14_release_bin_x86","win_vc14_release_lib_x86","win_vc14_release_sym_x86",
		         "win_vc14_debug_bin_x64","win_vc14_debug_lib_x64","win_vc14_debug_sym_x64",
                 "win_vc14_debug_bin_x86","win_vc14_debug_lib_x86","win_vc14_debug_sym_x86",
		         "headers"]	as String[]	 
		
        def directory = get_map_entries(StageDirs)
        
		for (int i=0; i<directory.size(); i++){
           String key = directory[i][0]
           //String value =  directory[i][1] Omit it we don't need
          _DetectDirType(key)
        } 
}	

def _DetectDirType(String PackageDir) {
    
	if (PackageDir ==~ /.*_bin_.*/) {
	    _CallForPackageCreation(PackageDir,"openssl_win")
	} else if (PackageDir ==~ /.*_lib_.*/) {
	    _CallForPackageCreation(PackageDir,"openssl-lib_win")
	} else if (PackageDir ==~ /.*_sym_.*/) {
	    _CallForPackageCreation(PackageDir,"openssl-sym_win")
	} else if (PackageDir ==~ /headers/) {
	    _CallForPackageCreation(PackageDir,"openssl-headers")
	} else {
	    println "Error: No matching qualifier among bin,lib,sym and headers"
	}

}

def _CallForPackageCreation(String PackageDirectory, String PackagePrefix) {

    if (PackageDirectory ==~ /.*vc14.*release.*x86/) { 
	
       PackagePrefix = PackagePrefix + '_release_intel32_vc140.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	   
	} else if(PackageDirectory ==~ /.*vc14.*debug.*x86/) { 
	
	   PackagePrefix = PackagePrefix + '_debug_intel32_vc140.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
		  
	} else if(PackageDirectory ==~ /.*vc14.*release.*x64/) { 
	
       PackagePrefix = PackagePrefix + '_release_intel64_vc140.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /.*vc14.*debug.*x64/) { 
	 
	   PackagePrefix = PackagePrefix + '_debug_intel64_vc140.' + openssl_sem_version + '.zip'	
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /.*vc11.*debug.*x86/) { 
	
	   PackagePrefix = PackagePrefix + '_debug_intel32_vc110.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /.*vc11.*release.*x86/) { 
	
	   PackagePrefix = PackagePrefix + '_release_intel32_vc110.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /.*vc11.*debug.*x64/) { 
	
	   PackagePrefix = PackagePrefix + '_debug_intel64_vc110.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /.*vc11.*release.*x64/) { 
	
	   PackagePrefix = PackagePrefix + '_debug_intel64_vc110.' + openssl_sem_version + '.zip'
	   _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else if(PackageDirectory ==~ /headers/) { 
	
        PackagePrefix = PackagePrefix + '.' + openssl_sem_version + '.zip'
	    _InvokeCrateForZips(PackageDirectory,PackagePrefix)
	  
	} else { 
              println "Error: No matching qualifier among bin,lib,sym,vc11,vc14,release,debug and headers"
	}
}

def _InvokeCrateForZips(String DirToPack, String ZipFileName) { 
	StageDir = pwd() + '\\stage'
	ZipsDir = StageDir + '\\packages'
	
	//println "The Stage dir is $StageDir \n" +
	// "The ZipsDir dir is $ZipsDir \n" +
	// "The DirtoPack is $StageDir\\$DirToPack \n" +
	// "The Zipfilename is $ZipsDir\\$ZipFileName \n" +
	// "The command to pack is $CrateUtilSlaveDownloadPath\\crate.exe pack $StageDir\\$DirToPack $ZipsDir\\$ZipFileName \n" 
	
	withEnv(["ZIP_HOLDING_DIR=$ZipsDir","UTIL_CRATE_BIN=$CrateUtilSlaveDownloadPath\\crate.exe","DIR_TO_ZIP=$DirToPack","ZIP_FILENAME=$ZipsDir\\$ZipFileName"]) {
		dir(StageDir) {
			bat '%UTIL_CRATE_BIN% pack %DIR_TO_ZIP% %ZIP_FILENAME%'
		}	
	}
}

def _DeployToArtifactory() {	
	ZipsDir = StageDir + '\\packages'
	withEnv(["ZIP_HOLDING_DIR=$ZipsDir","UTIL_CRATE_BIN=$CrateUtilSlaveDownloadPath\\crate.exe","VERSION_STR=$openssl_sem_version","GitBashPath=$WindowsGitBashUtilPath"]) {
		dir(ZipsDir) {
			withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '369dd206-a89f-4173-9d3e-10f517b24306', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
			
				bat 'for /R %%f in (*.zip) do (%UTIL_CRATE_BIN% push %USERNAME% %PASSWORD% %%f team-asrd-pilots/openssl/%VERSION_STR%)' 
				
		    }
	    
		}
	}
}
