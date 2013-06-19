ZZDGPMAPI4 ;Unit Tests - Check-in API; 6/19/13
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI4")
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
 ;
ADM(ADM,DATE) ;
 S ADM("PATIENT")=+DFN,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=DATE
 S ADM("FDEXC")=1,ADM("SHDIAG")="Admit diagnosis",ADM("WARD")=WARD1,ADM("FTSPEC")="1^"
 S ADM("ATNDPHY")=DUZ_U ;,ADM("ROOMBED")=BED1_U
 S %=$$ADMIT^DGPMAPI1(.RT,.ADM),%=$$GETMVT^DGPMAPI8(.ADM,RT)
 Q RT
DISCH(AIFN,DATE) ;
 S DCH("ADMIFN")=AIFN,DCH("TYPE")=24,DCH("DATE")=DATE
 S %=$$DISCH^DGPMAPI3(.RR,.DCH)
 Q
LDGIN ; Check-in patient
 N RE,DGQUIET
 S RTN="S %=$$LDGIN^DGPMAPI4(.RE,.PA)"
 S AIFN=$$ADM(.ADM,$$FMADD^XLFDT($$NOW^XLFDT(),,-1)_U)
 ; Invalid param patient
 S %=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT(R(0)["PARAM(""PATIENT"")",1,"Invalid patient param")
 ; Patient not found
 S PA("PATIENT")=DFN+100,%=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^PATNFND","Expected error: PATNFND")
 ;Check date
 S PA("PATIENT")=DFN
 D CHKDT^ZZDGPMUTL(RTN,.PA)
 ; Already has mvt on time
 S PA("DATE")=ADM("DATE"),%=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^TIMEUSD","Expected error: TIMEUSD")
 ; Already inpatient
 S PA("DATE")=$$NOW^XLFDT(),%=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^LDGPINP","Expected error: LDGPINP")
 ; Not before admission
 D DISCH(AIFN,$$FMADD^XLFDT($$NOW^XLFDT(),,-0.3)_U)
 S PA("DATE")=$$FMADD^XLFDT(+ADM("DATE"),-1),%=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^ADMMBBNM","Expected error: ADMMBBNM")
 ; Type
 S PA("DATE")=$$NOW^XLFDT(),PA("TYPE")="43^",PA("INVTYPE")="1"
 D CHKTYPE^ZZDGPMSE(RTN,.PA)
 ; Invalid short diag
 D CHKDIAG^ZZDGPMSE(RTN,.PA,"","LDGCOMM") S PA("LDGCOMM")="Check-in diagnosis"
 ; Invalid ward
 D CHKWARD^ZZDGPMSE(RTN,.PA,WARD1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PA,BED1,,2,WARD1,,,4)
 ; Invalid reason
 S %=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT(R(0)["PARAM(""LDGRSN"")",1,"Invalid reason param")
 ; Invalid reason
 S PA("LDGRSN")=99999,%=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^RSNNFND","Expected error: RSNNFND")
 ; Ok 43
 S PA("LDGRSN")=1,%=$$LDGIN^DGPMAPI4(.R,.PA)
 S CI0=+PA("DATE")_"^4^"_+PA("PATIENT")_U_+PA("TYPE")_"^^"_+PA("WARD")_U
 S CI0=CI0_PA("ROOMBED")_"^^^^^^"_+R_"^^^^"_$P(^DG(405.1,+PA("TYPE"),0),U,3)_"^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Expected error: RSNNFND")
 S %=$$DELLDGIN^DGPMAPI4(.R,R)
 ; Invalid facility
 S PA("TYPE")=44
 D CHKFCTY^ZZDGPMAPI2(RTN,.PA)
 ; Ok 44
 S %=$$LDGIN^DGPMAPI4(.R,.PA)
 S CI0=+PA("DATE")_"^4^"_+PA("PATIENT")_U_+PA("TYPE")_"^"_+PA("FCTY")
 S CI0=CI0_"^^^^^^^^^"_+R_"^^^^"_$P(^DG(405.1,+PA("TYPE"),0),U,3)_"^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Incorrect movement")
 S %=$$DELLDGIN^DGPMAPI4(.R,R)
 S %=$$DELADM^DGPMAPI1(.R,RT)
 Q
UPDLDGIN ; Update check-in lodger
 N PA,R,DGQUIET S RTN="S %=$$UPDLDGIN^DGPMAPI4(.RE,.PA,AFN)"
 S AIFN=$$ADM(.ADM,$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U)
 D DISCH(AIFN,$$FMADD^XLFDT($$NOW^XLFDT(),-1,1)_U)
 S PA("DATE")=$$NOW^XLFDT(),PA("LDGCOMM")="Check-in diagnosis",PA("LDGRSN")=1,PA("WARD")=WARD1_"^"
 S PA("PATIENT")=DFN,PA("TYPE")="43^"
 S %=$$LDGIN^DGPMAPI4(.R,.PA),AFN=+R_U K PA,R
 ; No update
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 D CHKEQ^XTMUNIT(R,1,"Unexpected error: "_$G(R(0)))
 ; Movement not found
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN+100)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PA,1)
 ; Not before last discharge
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1,-1)_U
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^ADMMBBNM","Expected error: ADMMBBNM")
 ; Invalid type
 S PA("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-1)_U
 S PA("TYPE")="44^",PA("INVTYPE")="1" ;Direct admission
 D CHKTYPE^ZZDGPMSE(RTN,.PA,1) K PA("TYPE")
 ; Invalid short diag
 D CHKDIAG^ZZDGPMSE(RTN,.PA,"","LDGCOMM") S PA("LDGCOMM")="Update Check-in diagnosis"
 ; Invalid ward
 D CHKWARD^ZZDGPMSE(RTN,.PA,+WARD2,1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PA,BED2,1,3,WARD1,,,4)
 ; Invalid reason
 S PA("LDGRSN")=99999,%=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^RSNNFND","Expected error: RSNNFND")
 ; Ok 43
 S PA("LDGRSN")=1
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 D CHKEQ^XTMUNIT(R,1,"Unexpected error: "_$G(R(0)))
 S CI0=+PA("DATE")_"^4^"_+DFN_"^43^^"_+PA("WARD")_U_PA("ROOMBED")
 S CI0=CI0_"^^^^^^"_+AFN_"^^^^"_$P(^DG(405.1,43,0),U,3)_"^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+AFN,0),"Incorrect movement")
 ; Invalid facility
 S PA("TYPE")="44^"
 D CHKFCTY^ZZDGPMAPI2(RTN,.PA,1,0)
 ; Ok 44 from 43
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 S CI0=+PA("DATE")_"^4^"_+DFN_"^44^"_+PA("FCTY")_"^"_+PA("WARD")_U_PA("ROOMBED")
 S CI0=CI0_"^^^^^^"_+AFN_"^^^^"_$P(^DG(405.1,44,0),U,3)_"^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+AFN,0),"Incorrect movement")
 ; Ok 43 from 44
 S PA("DATE")=$$NOW^XLFDT(),PA("LDGCOMM")="Check-in diagnosis",PA("LDGRSN")=1
 S PA("PATIENT")=DFN,PA("TYPE")="44^"
 ; Patient already lodger
 S %=$$LDGIN^DGPMAPI4(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^LDGPALD","Expected error: RSNNFND")
 S %=$$DELLDGIN^DGPMAPI4(.R,AFN),%=$$LDGIN^DGPMAPI4(.R,.PA),AFN=R
 S PA("TYPE")="43^",PA("INVTYPE")="1" K PA("WARD"),PA("ROOMBED")
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^WRDNFND","Expected error: WRDNFND")
 S PA("WARD")=WARD1,PA("ROOMBED")=BED1
 S %=$$UPDLDGIN^DGPMAPI4(.R,.PA,AFN)
 S CI0=+PA("DATE")_"^4^"_+DFN_"^43^^"_+PA("WARD")_U_PA("ROOMBED")
 S CI0=CI0_"^^^^^^"_+AFN_"^^^^"_$P(^DG(405.1,43,0),U,3)_"^^^^0^^"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+AFN,0),"Incorrect movement")
 Q
DELLDGIN ; Delete lodger check-in
 N R,DGQUIET
 ; Movement not found
 S %=$$DELLDGIN^DGPMAPI4(.R,AFN+100)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ; Ok to delete
 S %=$$DELLDGIN^DGPMAPI4(.R,AFN)
 D CHKEQ^XTMUNIT($D(^DGPM(+AFN)),0,"Mvt not deleted")
 Q
XTENT ;
 ;;LDGIN;Check-in patient
 ;;UPDLDGIN;Update check-in
 ;;DELLDGIN;Delete check-in
