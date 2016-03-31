node('GEC3P') {
		stage 'Checkout'
		
		checkout scm
		
                stage 'Build'
    
		bat 'adsk_install.bat x86 vc14'
		bat 'adsk_install.bat x64 vc14'
                
}
