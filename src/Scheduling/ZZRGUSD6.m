ZZRGUSD6 ;RGI/VSL Unit Tests - Team API; 5/31/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD6")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 D LOGON^ZZRGUSDC
 S DT=$$DT^XLFDT()
 D SETUP^ZZRGUSDC()
 S TPO=1,TM=1
 Q
 ;
SHUTDOWN ;
 Q
 ;
GETEAM ; Get team
 N R,%
 ; Invalid parameter
 S %=$$GETEAM^SCTMAPI1(.R,)
 D CHKEQ^XTMUNIT(R_U_$P(R(0),U),"0^INVPARAM","Expected: INVPARAM SCTM")
 ; Team not found
 S %=$$GETEAM^SCTMAPI1(.R,4)
 D CHKEQ^XTMUNIT(R_U_$P(R(0),U),"0^TEAMNFND","Expected: TEAMNFND")
 ; Get Team
 S %=$$GETEAM^SCTMAPI1(.R,TM)
 D CHKEQ^XTMUNIT(R,1,"Unexpected: "_$G(R(0)))
 S TM0=^SCTM(404.51,TM,0),TMH0=$G(^SCTM(404.58,TM,0))
 D CHKEQ^XTMUNIT(R("CAN ACT AS A PC TEAM?"),$$STRIP($P(TM0,U,5)_U_$S($P(TM0,U,5):"YES",1:"NO")),"Can act PC")
 D CHKEQ^XTMUNIT(R("CURRENT # OF PATIENTS"),"0","No of patients")
 D CHKEQ^XTMUNIT($P(R("CURRENT STATUS"),U),$$STRIP($S('+TMH0!('$P(TMH0,U,3)):"Inactive",1:"Active")),"Current status")
 D CHKEQ^XTMUNIT(R("NAME"),$$STRIP($P(TM0,U)),"Team name")
 D CHKEQ^XTMUNIT(R("TEAM PURPOSE"),$$STRIP($P(TM0,U,3)_U_$P(^SD(403.47,$P(TM0,U,3),0),U)),"Team purpose")
 D CHKEQ^XTMUNIT(R("SERVICE/DEPARTMENT"),$$STRIP($P(TM0,U,6)_U_$P(^DIC(49,$P(TM0,U,6),0),U)),"Service")
 D CHKEQ^XTMUNIT(R("INSTITUTION"),$$STRIP($P(TM0,U,7)_U_$P(^DIC(4,$P(TM0,U,7),0),U)),"Institution")
 D CHKEQ^XTMUNIT(R("MAX NUMBER OF PATIENTS"),$$STRIP($P(TM0,U,8)_U_$P(TM0,U,8)),"Max no of patients")
 D CHKEQ^XTMUNIT(R("MAX % OF PRIMARY CARE PATIENTS"),$$STRIP($P(TM0,U,9)_U_$P(TM0,U,9)),"Max no of PC patients")
 D CHKEQ^XTMUNIT(+R("CLOSE TO FURTHER ASSIGNMENT?"),+$P(TM0,U,10),"Close to further assignment")
 D CHKEQ^XTMUNIT(+R("AUTO-ASSIGN FROM ASSC CLINICS?"),+$P(TM0,U,11),"Auto-assign")
 D CHKEQ^XTMUNIT(+R("DISCHARGE FROM ASSOC. CLINICS?"),+$P(TM0,U,12),"Discharge from assoc")
 D CHKEQ^XTMUNIT(+R("RESTRICT CONSULTS?"),+$P(TM0,U,13),"Restrict consults")
 S EDT=$$UP^XLFSTR($$FMTE^XLFDT($P(TMH0,U,2)))
 D CHKEQ^XTMUNIT($P(R("CURRENT ACTIVATION DATE"),U),$S($P(TMH0,U,3):EDT,1:""),"Activation date")
 D CHKEQ^XTMUNIT($P(R("CURRENT EFFECTIVE DATE"),U),$S($P(TMH0,U,3):EDT,1:""),"Effective date")
 D CHKEQ^XTMUNIT(R("CURRENT INACTIVATION DATE"),"","Inactivation date")
 Q
 ;
STRIP(STR) ;If STR equals '^' return ''
 I $G(STR)="^" Q ""
 Q $G(STR)
 ;
GETEAMPO ; Get team position
 N R,%
 ; Invalid parameter
 S %=$$GETEAMPO^SCTMAPI1(.R,)
 D CHKEQ^XTMUNIT(R_U_$P(R(0),U),"0^INVPARAM","Expected: INVPARAM SCTM")
 ; Team position not found
 S %=$$GETEAMPO^SCTMAPI1(.R,4)
 D CHKEQ^XTMUNIT(R_U_$P(R(0),U),"0^TMPONFND","Expected: TEAMNFND")
 ; Get Team position
 D ADDTMPOH(TPO,$$DT^XLFDT(),1,1)
 S %=$$GETEAMPO^SCTMAPI1(.R,TPO)
 D CHKEQ^XTMUNIT(R,1,"Unexpected: "_$G(R(0)))
 S TM0=^SCTM(404.57,TM,0),TMH0=$G(^SCTM(404.59,TM,0))
 D CHKEQ^XTMUNIT(R("CAN ACT AS PRECEPTOR?"),$S($P(TM0,U,12):$P(TM0,U,12)_U_$S($P(TM0,U,12):"YES",1:"NO"),1:""),"Can act PC")
 D CHKEQ^XTMUNIT(R("CURRENT # OF PATIENTS"),"0","No of patients")
 D CHKEQ^XTMUNIT($P(R("CURRENT STATUS"),U),$S('+TMH0!('$P(TMH0,U,3)):"Inactive",1:"Active"),"Current status")
 D CHKEQ^XTMUNIT(R("POSITION"),$P(TM0,U),"Name")
 D CHKEQ^XTMUNIT(R("TEAM"),$P(TM0,U,2)_U_$P(^SCTM(404.51,$P(TM0,U,2),0),U),"Team")
 D CHKEQ^XTMUNIT(R("STANDARD ROLE NAME"),$P(TM0,U,3)_U_$P(^SD(403.46,$P(TM0,U,3),0),U),"Role name")
 D CHKEQ^XTMUNIT(R("POSSIBLE PRIMARY PRACTITIONER?"),$S($P(TM0,U,4)]"":$P(TM0,U,4)_U_$S($P(TM0,U,4):"YES",1:"NO"),1:""),"Primary practitioner")
 D CHKEQ^XTMUNIT(+R("MAX NUMBER OF PATIENTS"),+$P(TM0,U,8),"Max no of patients")
 D CHKEQ^XTMUNIT(+R("FUTURE # OF PATIENTS"),0,"Future # of patients")
 D CHKEQ^XTMUNIT(+R("FUTURE # OF PC PATIENTS"),0,"Future # of PC patients")
 D CHKEQ^XTMUNIT(+R("CURRENT # OF PATIENTS"),0,"Current # of patients")
 D CHKEQ^XTMUNIT(+R("CURRENT # OF PC PATIENTS"),0,"Current # of PC patients")
 S EDT=$$UP^XLFSTR($$FMTE^XLFDT($P(TMH0,U,2)))
 D CHKEQ^XTMUNIT($P(R("CURRENT ACTIVATION DATE"),U),$S($P(TMH0,U,3):EDT,1:""),"Activation date")
 D CHKEQ^XTMUNIT($P(R("CURRENT EFFECTIVE DATE"),U),$S($P(TMH0,U,3):EDT,1:""),"Effective date")
 D CHKEQ^XTMUNIT(R("CURRENT INACTIVATION DATE"),"","Inactivation date")
 S F(.05)=99,F(.06)=DUZ,F(.07)=$$DT^XLFDT(),F(.08)=DUZ,F(.09)=$$DT^XLFDT()
 S $P(^SCTM(404.51,1,0),U,5)=1
 S %=$$ACPTTP^SCAPMC21(+DFN,TPO,"F",$$DT^XLFDT(),"^TMP(""SCERR"")",1)
 S %=$$GETEAMPO^SCTMAPI1(.R,TPO)
 D CHKEQ^XTMUNIT(+R("FUTURE # OF PATIENTS"),1,"Future # of patients")
 D CHKEQ^XTMUNIT(+R("FUTURE # OF PC PATIENTS"),1,"Future # of PC patients")
 D CHKEQ^XTMUNIT(+R("CURRENT # OF PATIENTS"),1,"Current # of patients")
 D CHKEQ^XTMUNIT(+R("CURRENT # OF PC PATIENTS"),1,"Current # of PC patients")
 S %=$$GETEAM^SCTMAPI1(.R,TM)
 D CHKEQ^XTMUNIT(R,1,"Unexpected: "_$G(R(0)))
 D CHKEQ^XTMUNIT(+R("CURRENT # OF PATIENTS"),1,"No of patients")
 Q
LSTAPOSN ; Get active positions
 N R,%
 S %=$$LSTAPOS^SCTMAPI1(.R)
 D CHKEQ^XTMUNIT(R(0),0)
 Q
LSTAPOS ; Get active positions
 N R,%
 S $P(^SCTM(404.57,TPO,0),U,9)=+SC,TPO0=^SCTM(404.57,TPO,0)
 S %=$$LSTAPOS^SCTMAPI1(.R)
 D CHKEQ^XTMUNIT(R(0),1)
 D CHKEQ^XTMUNIT(R(1,"CLINIC"),$P(TPO0,U,9),"Clinic ID")
 D CHKEQ^XTMUNIT(R(1,"ID"),TPO,"Team ID")
 D CHKEQ^XTMUNIT(R(1,"NAME"),$P(TPO0,U),"Position")
 D CHKEQ^XTMUNIT(R(1,"TEAM"),$P(^SCTM(404.51,$P(TPO0,U,2),0),U),"Team")
 Q
ADDTMPOH(TMPO,EDT,STAT,RSN) ;
 N FDA,IEN
 S IEN="+1,",IENS(1)=TMPO
 S FDA(404.59,IEN,.01)=+TMPO
 S FDA(404.59,IEN,.02)=+EDT
 S FDA(404.59,IEN,.03)=+STAT
 S FDA(404.59,IEN,.04)=+RSN
 D UPDATE^DIE("","FDA","IENS","ERR")
 Q
GETAPTS ;
 N RETURN,%,RE
 S RTN="S %=$$GETAPTS^SDMAPI1(.RETURN,.PAT,SD)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$GETAPTS^SDMAPI1(.RE,DFN,"AA")
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 S PDT=$$FMADD^XLFDT(+SD,-1)_3,FDT=$$FMADD^XLFDT(+SD,1)_3,SD=+SD_3
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,+SD,TYPE,,LEN,NXT,RSN,,,,,1,,1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,PDT,TYPE,,LEN,NXT,RSN,,,,,1,,1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,FDT,TYPE,,LEN,NXT,RSN,,,,,1,,1)
 S SD1=+SD,SD1(0)=61
 S %=$$GETAPTS^SDMAPI1(.RE,DFN,.SD1)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 ; future appts
 S SD1(0)=1,%=$$GETAPTS^SDMAPI1(.RE,DFN,.SD1)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($D(RE("APT",+PDT)),0,"Not past appt")
 D CHKEQ^XTMUNIT($D(RE("APT",+SD)),0,"Not present appt")
 D CHKEQ^XTMUNIT($D(RE("APT",+FDT)),10,"Missing future appt")
 ; past appts
 S SD1(0)=0,%=$$GETAPTS^SDMAPI1(.RE,DFN,.SD1)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($D(RE("APT",+PDT)),10,"Missing past appt")
 D CHKEQ^XTMUNIT($D(RE("APT",+SD)),10,"Missing present appt")
 D CHKEQ^XTMUNIT($D(RE("APT",+FDT)),0,"Not future appt")
 ; existing appt
 S %=$$GETAPTS^SDMAPI1(.RE,DFN,+SD)
 D CHKEQ^XTMUNIT(RE,1)
 D CHKEQ^XTMUNIT(RE("APT",+SD,"OTHER"),RSN,"Reason field")
 D CHKEQ^XTMUNIT(RE("APT",+SD,"LENGTH"),+LEN,"Length field")
 D CHKEQ^XTMUNIT(RE("APT",+SD,"RQXRAY"),1,"Prior xray field")
 D CHKEQ^XTMUNIT(RE("APT",+SD,"APPOINTMENT TYPE"),+TYPE_U_$P(^SD(409.1,+TYPE,0),U))
 D CHKEQ^XTMUNIT(RE("APT",+SD,"CLINIC"),+SC_U_$P(^SC(+SC,0),U))
 D CHKEQ^XTMUNIT(RE("APT",+SD,"DATA ENTRY CLERK"),DUZ_U_$P(^VA(200,DUZ,0),U))
 D CHKEQ^XTMUNIT(RE("APT",+SD,"PURPOSE OF VISIT"),"3"_U_"SCHEDULED VISIT")
 D CHKEQ^XTMUNIT(RE("APT",+SD,"SCHEDULING REQUEST TYPE"),"N"_U_"'NEXT AVAILABLE' APPT.")
 D CHKEQ^XTMUNIT(RE("APT",+SD,"NEXT AVA. APPT. INDICATOR"),"3"_U_"'NEXT AVA.' APPT. INDICATED BY USER & CALCULATION")
 Q
DTIME ; Check date time param
 N RE,%
 S %=$$DTIME^SDCHK(.RE,3130524.01,"SD",1)
 D CHKEQ^XTMUNIT(%,1,"3130524.01")
 S %=$$DTIME^SDCHK(.RE,3130524.0801,"SD",1)
 D CHKEQ^XTMUNIT(%,1,"3130524.0801")
 Q
GETHOL ; Check holiday
 N RE
 S %=$$GETHOL^SDMAPI4(.RE,)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 S %=$$GETHOL^SDMAPI4(.RE,"AA")
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 S %=$$GETHOL^SDMAPI4(.RE,"31305")
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 S SD=$$DT^XLFDT()
 ;not a holiday
 S %=$$GETHOL^SDMAPI4(.RE,SD)
 D CHKEQ^XTMUNIT(RE,0,"Incorrect return")
 ;holiday
 S IENS="?+2,"
 S IENS(2)=+SD
 S HOL(40.5,IENS,.01)=SD
 S HOL(40.5,IENS,2)="Today is holiday"
 D UPDATE^DIE("","HOL","IENS","R")
 S %=$$GETHOL^SDMAPI4(.RE,SD)
 D CHKEQ^XTMUNIT(RE,1,"UnExpected: INVPARAM SD")
 D CHKEQ^XTMUNIT(RE($$DT^XLFDT()),$$DT^XLFDT()_U_"Today is holiday","Incorrect holiday")
 Q
XTENT ;
 ;;GETEAM;Get team
 ;;LSTAPOSN;Get active positions
 ;;GETEAMPO;Get team position
 ;;LSTAPOS;Get active positions
 ;;GETAPTS;Get patient appointments
 ;;DTIME;Check date time
 ;;GETHOL;Check holiday
