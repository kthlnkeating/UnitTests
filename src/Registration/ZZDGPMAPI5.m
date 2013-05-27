ZZDGPMAPI5 ;Unit Tests - Check-in API; 5/22/13
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
CHECKIN(DATE)
 ; Check-in
 S (CIDT,PA("DATE"))=DATE,PA("LDGCOMM")="Check-in comments",PA("LDGRSN")=1,PA("WARD")=WARD1_"^"
 S PA("PATIENT")=DFN,PA("TYPE")="43^",PA("ROOMBED")=BED2_U
 S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED2,.PARA)
 S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED1,.PARA)
 S %=$$LDGIN^DGPMAPI4(.R,.PA)
 Q R
CHECKOUT(AFN,DATE)
 ; Check-in
 S (CIDT,PA("DATE"))=DATE,PA("TYPE")=45,PA("LDGDISP")="a^A",PA("ADMIFN")=AFN
 S %=$$LDGOUT^DGPMAPI5(.R,.PA)
 Q R
LDGOUT ;
 N PA,PAR,DGQUIET
 ; Invalid param check-in IFN
 S %=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT(R(0)["PARAM('ADMIFN')",1,"Invalid check-in parameter")
 ; Check-in movement not found
 S PA("ADMIFN")=99999,%=$$LDGOUT^DGPMAPI5(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ; Check-in
 S AFN=+$$CHECKIN($$FMADD^XLFDT($$NOW^XLFDT(),-1))_U K PA
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
 ; Type
 S PA("DATE")=$$FMADD^XLFDT(CIDT,,1),PA("LDGDISP")="a^A",PA("TYPE")="45^",PA("INVTYPE")="1"
 D CHKTYPE^ZZDGPMSE(RTN,.PA,1)
 ; Ok
 S PA("TYPE")=45,PA("LDGDISP")="a^A",%=$$LDGOUT^DGPMAPI5(.R,.PA)
 S CI0=+PA("DATE")_"^5^"_+PA("PATIENT")_"^45^^"
 S CI0=CI0_"^^^^^^^^"_+AFN_"^^^^7^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Incorrect movement")
 S COFN=R
 Q
UPDLDGOU ;Update check-out
 N PA,PAR,RE,DGQUIET
 ; No update
 S RTN="S %=$$UPDLDGOU^DGPMAPI5(.RE,.PA,COFN)"
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
 ;Type
 S PA("LDGDISP")="A^ADMITTED",PA("TYPE")="1^",PA("INVTYPE")="2"
 S $P(^DG(405.1,1,0),U,3)=7,$P(^DG(405.1,1,0),U,2)=5,^DG(405.1,1,"F",43)=""
 D CHKTYPE^ZZDGPMSE(RTN,.PA,1)
 ; Ok to update
 S %=$$UPDLDGOU^DGPMAPI5(.R,.PA,COFN)
 S CI0=+PA("DATE")_"^5^"_+PA("PATIENT")_"^"_+PA("TYPE")_"^^"
 S CI0=CI0_"^^^^^^^^"_+AFN_"^^^^7^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+COFN,0),"Incorrect movement")
 Q
DELLDGOU ;Delete check-out ;
 N R,DGQUIET
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
