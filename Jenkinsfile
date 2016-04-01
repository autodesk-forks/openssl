node('GEC3P') {
		stage 'Checkout'
		
		checkout scm
		
                stage 'Build 32 bit'
    
		bat 'adsk_install.bat x86 vc14'

                stage 'Build 64 bit'
		bat 'adsk_install.bat x64 vc14'
                
}
