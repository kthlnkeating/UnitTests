ZZDGPMAPI5 ;Unit Tests - Check-in API; 4/2/13
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI5")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZDGPMSE()
 Q
 ;
SHUTDOWN ;
 Q
LDGOUT ;
 K PA,PAR
 ; Invalid param check-in IFN
 S %=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT(R(0)["PARAM('ADMIFN')",1,"Invalid check-in parameter")
 ; Check-in movement not found
 S PA("ADMIFN")=99999,%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ; Check-in
 S (CIDT,PA("DATE"))=$$FMADD^XLFDT($$NOW^XLFDT(),-1),PA("LDGCOMM")="Check-in diagnosis",PA("LDGRSN")=1,PA("WARD")=WARD1_"^"
 S PA("PATIENT")=DFN,PA("TYPE")="43^"
 S %=$$LDGIN^DGPMAPI4(.R,.PA),AFN=+R_U K PA,R
 ; Invalid date param
 S PA("ADMIFN")=AFN,RTN="S %=$$LDGOUT^DGPMAPI5(.RE,.PA)"
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PA)
 ; Invalid disposition param
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-0.5),%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT(R(0)["PARAM('LDGDISP')",1,"Invalid check-in parameter")
 ; Invalid disposition
 S PA("LDGDISP")="C^C",%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 ; Time used
 S PA("DATE")=CIDT,PA("LDGDISP")="A^A",%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^TIMEUSD","Expected error: TIMEUSD")
 ; Not before check-in
 S PA("DATE")=$$FMADD^XLFDT(CIDT,,-1),%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^TRANBADM","Expected error: TRANBADM")
 ; Ok
 S PA("DATE")=$$FMADD^XLFDT(CIDT,,1),PA("TYPE")=45,PA("LDGDISP")="a^A",%=$$LDGOUT^DGPMAPI5(.R,.PA)
 S CI0=+PA("DATE")_"^5^"_+PA("PATIENT")_"^45^^"
 S CI0=CI0_"^^^^^^^^"_+AFN_"^^^^7^^^^0"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Incorrect movement")
 S COFN=R
 Q
UPDLDGOU ;Update check-out
 K PA,PAR
 ; No update
 S RTN="S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)"
 S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 D CHKEQ^XTMUNIT(R,1,"Unexpected error: "_$G(R(0)))
 ; Movement not found
 S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN+100)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PA,1)
 ; Not before chech-in
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1,-1)_U
 S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^TRANBADM","Expected error: TRANBADM")
 ; Check-in
 S (CIDT,PA("DATE"))=$$FMADD^XLFDT($$NOW^XLFDT(),,-2)_U,PA("LDGCOMM")="Check-in diagnosis",PA("LDGRSN")=1,PA("WARD")=WARD1_"^"
 S PA("PATIENT")=DFN,PA("TYPE")="43^"
 S %=$$LDGIN^DGPMAPI4(.R,.PA),AFN1=R
 ; Not before last movement
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-1)_U
 S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^ADMMBBNM","Expected error: ADMMBBNM")
 ; Invalid disposition
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-3)_U K PA("TYPE")
 S PA("LDGDISP")="C^C",%=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 ; Ok to update
 S PA("LDGDISP")="A^ADMITTED",%=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 S CI0=+PA("DATE")_"^5^"_+PA("PATIENT")_"^45^^"
 S CI0=CI0_"^^^^^^^^"_+AFN_"^^^^7^^^^0"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+COFN,0),"Incorrect movement")
 Q
DELLDGOU ;Delete check-out ;
 ; Movement not found
 S %=$$DELLDGOU^DGPMAPI5(.R,COFN+100)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ; Only if it is the last mvt
 S %=$$DELLDGOU^DGPMAPI5(.R,COFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^DCHDODLM","Expected error: DCHDODLM")
 ; Del next mvt
 S %=$$DELLDGIN^DGPMAPI4(.R,AFN1)
 ; Only if it is the last mvt
 S %=$$DELLDGOU^DGPMAPI5(.R,COFN)
 D CHKEQ^XTMUNIT(R,1,"Unexpected error: "_$G(R(0)))
 Q
XTENT ;
 ;;LDGOUT;Check-out patient
 ;;UPDLDGOU;Update check-out
 ;;DELLDGOU;Delete check-out
