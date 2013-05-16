ZZRGUSD1 ;Unit Tests - Clinic API; 4/16/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD1")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUSDC
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
CLNCK ;
 N RETURN,%
 S %=$$CLNCK^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"INVPARAM","Expected error: INVPARAM")
 ;
 S %=$$CLNCK^SDMAPI1(.RETURN,99999999)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNNFND","Expected error: CLNNFND")
 ;
 S $P(^SC(+SC,0),U,7)=""
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCIN")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNSCIN","Expected error: CLNSCIN")
 ;
 S STOP=105,$P(^SC(+SC,0),U,7)=STOP
 S $P(^DIC(40.7,STOP,0),U,6)="S"
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCPS")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNSCPS","Expected error: CLNSCPS")
 ;
 S $P(^DIC(40.7,STOP,0),U,6)=""
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCNR")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNSCNR","Expected error: CLNSCNR")
 ;
 S $P(^DIC(40.7,STOP,0),U,6)="P",$P(^DIC(40.7,STOP,0),U,7)=DT+1
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCRD")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNSCRD","Expected error: CLNSCRD")
 ;
 S $P(^DIC(40.7,STOP,0),U,6)="P",$P(^DIC(40.7,STOP,0),U,7)=DT
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(RETURN(0)))
 Q
 ;
GETCLN ;
 N RETURN,%
 S %=$$GETCLN^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN("NAME"),"Test Clinic","NAME field")
 D CHKEQ^XTMUNIT(RETURN("STOP CODE NUMBER"),"105^EMERGENCY UNIT","STOP CODE NUMBER field")
 D CHKEQ^XTMUNIT(RETURN("TYPE"),"C^CLINIC","TYPE field")
 D CHKEQ^XTMUNIT(RETURN("CREDIT STOP CODE"),"3^MENTAL HYGIENE(INDIV.)","CREDIT STOP CODE field")
 D CHKEQ^XTMUNIT(RETURN("DEFAULT APPOINTMENT TYPE"),"9^REGULAR","DEFAULT APPOINTMENT TYPE field")
 D CHKEQ^XTMUNIT(RETURN("DISPLAY INCREMENTS PER HOUR"),"4^15-MIN ","DISPLAY INCREMENTS PER HOUR field")
 D CHKEQ^XTMUNIT(RETURN("HOUR CLINIC DISPLAY BEGINS"),"","HOUR CLINIC DISPLAY BEGINS field")
 D CHKEQ^XTMUNIT(RETURN("INACTIVATE DATE"),"","INACTIVATE DATE field")
 D CHKEQ^XTMUNIT(RETURN("LENGTH OF APP'T"),"30","LENGTH OF APP'T field")
 D CHKEQ^XTMUNIT(RETURN("MAX # DAYS FOR AUTO-REBOOK"),"","MAX # DAYS FOR AUTO-REBOOK field")
 D CHKEQ^XTMUNIT(RETURN("MAX # DAYS FOR FUTURE BOOKING"),"2","MAX # DAYS FOR FUTURE BOOKING field")
 D CHKEQ^XTMUNIT(RETURN("NON-COUNT CLINIC? (Y OR N)"),"Y^YES","NON-COUNT CLINIC field")
 D CHKEQ^XTMUNIT(RETURN("OVERBOOKS/DAY MAXIMUM"),"1","OVERBOOKS/DAY MAXIMUM field")
 D CHKEQ^XTMUNIT(RETURN("PROHIBIT ACCESS TO CLINIC?"),"","PROHIBIT ACCESS TO CLINIC field")
 D CHKEQ^XTMUNIT(RETURN("REACTIVATE DATE"),"","REACTIVATE DATE field")
 D CHKEQ^XTMUNIT(RETURN("SCHEDULE ON HOLIDAYS?"),"Y^YES","SCHEDULE ON HOLIDAYS field")
 D CHKEQ^XTMUNIT(RETURN("VARIABLE APP'NTMENT LENGTH"),"V^YES, VARIABLE LENGTH","VARIABLE APP'NTMENT LENGTH field")
 ;
 S %=$$GETCLN^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN_U_$P($G(RETURN(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ;
 S %=$$GETCLN^SDMAPI1(.RETURN,9999999)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"CLNNFND","Expected error: CLNNFND")
 Q
 ;
LSTCLNS ;
 N RETURN,%
 S %=$$LSTCLNS^SDMAPI1(.RETURN,CNAME)
 D CHKEQ^XTMUNIT(1,RETURN,"Unexpected error: ")
 D CHKEQ^XTMUNIT(1,%,"Unexpected error: ")
 D CHKEQ^XTMUNIT(2,+RETURN(0),"Number of clinics whose name starts with: "_CNAME)
 D CHKEQ^XTMUNIT(+SC,RETURN(1,"ID"),"Clinic IEN")
 D CHKEQ^XTMUNIT(CNAME,RETURN(1,"NAME"),"Clinic name")
 Q
 ;
CLNRGHT ;
 N RETURN,%
 S RTN="S %=$$CLNRGHT^SDMAPI1(.RETURN,.CLN)" D EXSTCLN^ZZRGUSD5(RTN)
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Access to clinic is not restricted")
 S ^SC(+SC,"SDPROT")="Y"
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNURGT")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNURGT","Expected error: CLNURGT")
 S ^SC(+SC,"SDPRIV",DUZ,0)=DUZ,^SC(+SC,"SDPRIV",0)="^44.04PA^1^1"
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"User has access to this clinic")
 Q
 ;
CLNVSC ;
 N RETURN,%
 S $P(^DIC(40.7,STOP,0),U,3)=DT
 S %=$$CLNVSC^SDMAPI1(.RETURN,STOP)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCIN")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCIN","Expected error: CLNSCIN")
 S $P(^DIC(40.7,STOP,0),U,3)=DT+1
 S %=$$CLNVSC^SDMAPI1(.RETURN,STOP)
 D CHKEQ^XTMUNIT(RETURN,1,"Stop code is valid")
 Q
LSTAPPT ;
 N RETURN,%
 S %=$$LSTAPPT^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(+RETURN(0),11)
 Q
GETSCAP ;
 N RETURN,%
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 S RTN="S %=$$GETSCAP^SDMAPI1(.RETURN,.CLN,.PAT,.SD)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 S %=$$GETSCAP^SDMAPI1(.RETURN,SC,DFN)
 D CHKEQ^XTMUNIT(RETURN_U_$P(RETURN(0),U),"0^INVPARAM","Expected: INVPARAM")
 ;
 S %=$$GETSCAP^SDMAPI1(.RETURN,SC,DFN,SD)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN("IFN"),$O(^SC(+SC,"S",+SD,1,0)))
 D CHKEQ^XTMUNIT(RETURN("USER"),$P(^SC(+SC,"S",+SD,1,RETURN("IFN"),0),U,6),"Invalid user IFN")
 D CHKEQ^XTMUNIT(RETURN("DATE"),$P(^SC(+SC,"S",+SD,1,RETURN("IFN"),0),U,7),"Invalid apt date")
 D CHKEQ^XTMUNIT(RETURN("LENGTH"),$P(^SC(+SC,"S",+SD,1,RETURN("IFN"),0),U,2),"Invalid length")
 D CHKEQ^XTMUNIT(RETURN("CHECKOUT"),$P($G(^SC(+SC,"S",+SD,1,RETURN("IFN"),"C")),U,3),"Invalid checkout")
 Q
GETAPPT ;
 N RETURN,%
 S %=$$GETAPPT^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN_U_$P(RETURN(0),U),"0^INVPARAM","Expected: INVPARAM")
 S %=$$GETAPPT^SDMAPI1(.RETURN,$P(^SD(409.1,0),U,3)+1)
 D CHKEQ^XTMUNIT(RETURN_U_$P(RETURN(0),U),"0^TYPNFND","Expected: TYPNFND")
 S %=$$GETAPPT^SDMAPI1(.RETURN,1)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT($P(RETURN("NAME"),U),$P(^SD(409.1,1,0),U))
 Q
GETELIG ;
 N RETURN,%
 S %=$$GETELIG^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN_U_$P(RETURN(0),U),"0^INVPARAM","Expected: INVPARAM")
 S %=$$GETELIG^SDMAPI1(.RETURN,1)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT($P(RETURN("NAME"),U),$P(^DIC(8,1,0),U),"Invalid name")
 D CHKEQ^XTMUNIT($P(RETURN("ABBREVIATION"),U),$P(^DIC(8,1,0),U,3))
 D CHKEQ^XTMUNIT($P(RETURN("MAS ELIGIBILITY CODE"),U),$P(^DIC(8,1,0),U,9))
 D CHKEQ^XTMUNIT($P(RETURN("PRINT NAME"),U),$P(^DIC(8,1,0),U,6))
 D CHKEQ^XTMUNIT($P(RETURN("TYPE"),U),$P(^DIC(8,1,0),U,5))
 D CHKEQ^XTMUNIT($P(RETURN("VA CODE NUMBER"),U),$P(^DIC(8,1,0),U,4))
 D CHKEQ^XTMUNIT($P(RETURN("INACTIVE"),U),$P(^DIC(8,1,0),U,7))
 Q
GETPEND ;
 N RETURN,%
 S RTN="S %=$$GETPEND^SDMAPI1(.RETURN,.PAT)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$GETPEND^SDMAPI1(.RETURN,DFN) ; Get pending appointments
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(+SD,"APPOINTMENT TYPE"),$P(^SD(409.1,+TYPE,0),U),"APPOINTMENT TYPE")
 D CHKEQ^XTMUNIT(RETURN(+SD,"CLINIC"),$P(^SC(+SC,0),U),"CLINIC")
 D CHKEQ^XTMUNIT(RETURN(+SD,"LENGTH OF APP'T"),+LEN,"LENGTH OF APP'T")
 Q
FRSTAVBL ;
 N DATE,RETURN,%,SCF2,SD
 S SCF2=$$ADDCLN^ZZRGUSDC("First AV Clinic")
 S RTN="S %=$$FRSTAVBL^SDMAPI1(.RETURN,.CLN)" D EXSTCLN^ZZRGUSD5(RTN)
 ; no availibility
 S %=$$FRSTAVBL^SDMAPI1(.RETURN,SCF2)
 D CHKEQ^XTMUNIT(RETURN,"","INCORRECT Date")
 S DD=9999999
 S ^SC(+SCF2,"T3",DD,0)=DD,^SC(+SCF2,"T3",DD,1)="[1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1]"
 S %=$$FRSTAVBL^SDMAPI1(.RETURN,SCF2)
 N FDT1,FDT
 S FDT1=$$DT^XLFDT()+6,DOW=$$DOW^SDMAPI5(FDT1)
 S FDT=$$FMADD^XLFDT(FDT1,$S(DOW>3:7-DOW+3,1:3-DOW))
 D CHKEQ^XTMUNIT(RETURN,FDT,"INCORRECT Date")
 Q
LSTCAPTS ;
 N SDT,R,RETURN,%
 S SDT=DT+1_".08",SDT=SDT_U_$$FMTE^XLFDT(SDT)
 S %=$$MAKE^SDMAPI2(.R,DFN,SC,SDT,TYPE,,LEN,NXT,RSN)
 S RTN="S %=$$LSTCAPTS^SDMAPI1(.RETURN,.CLN,.SDBEG,.SDEND,)" D EXSTCLN^ZZRGUSD5(RTN)
 S %=$$LSTCAPTS^SDMAPI1(.RETURN,SC,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"BID"),3445)
 D CHKEQ^XTMUNIT(RETURN(1,"DFN"),+DFN)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),$P(^DPT(+DFN,0),U))
 D CHKEQ^XTMUNIT(RETURN(1,"SC"),+SC)
 D CHKEQ^XTMUNIT(RETURN(1,"GAF"),0)
 D CHKEQ^XTMUNIT(RETURN(1,"SD"),DT_".08")
 D CHKEQ^XTMUNIT(RETURN(1,"STAT"),"12;NON-COUNT;NON-COUNT;;;0")
 S %=$$LSTCAPTS^SDMAPI1(.RETURN,SC,SD,SDT,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 S $P(^SC(+SC,0),U,7)=526
 S ^DPT(+DFN,.36)=11,$P(^DPT(+DFN,"S",+SDT,0),U,11)=1
 S %=$$LSTCAPTS^SDMAPI1(.RETURN,SC,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"GAF"),-1)
 Q
LSTPAPTS ;
 N SDT,RETURN,%
 S SDT=DT+1_".08",SDT=SDT_U_$$FMTE^XLFDT(SDT)
 S RTN="S %=$$LSTPAPTS^SDMAPI1(.RETURN,.PAT,.SDBEG,.SDEND,)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$LSTPAPTS^SDMAPI1(.RETURN,DFN,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"BID"),3445)
 D CHKEQ^XTMUNIT(RETURN(1,"DFN"),+DFN)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),$P(^DPT(+DFN,0),U))
 D CHKEQ^XTMUNIT(RETURN(1,"SC"),+SC)
 D CHKEQ^XTMUNIT(RETURN(1,"SD"),DT_".08")
 D CHKEQ^XTMUNIT(RETURN(1,"STAT"),"12;NON-COUNT;NON-COUNT;;;0")
 S %=$$LSTPAPTS^SDMAPI1(.RETURN,DFN,SD,SDT,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
SLOTS ;
 N RETURN,%
 S RTN="S %=$$SLOTS^SDMAPI1(.RETURN,.CLN)" D EXSTCLN^ZZRGUSD5(RTN)
 S %=$$SLOTS^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
SCEXST ;
 N RETURN,%
 S %=$$SCEXST^SDMAPI1(.RETURN,107)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
LSTCRSNS ;
 N RETURN,%
 S %=$$LSTCRSNS^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT($P(RETURN(0),U),$P(^SD(409.2,0),U,4))
 Q
GETCSC ;
 N RETURN,%
 S RTN="S %=$$GETCSC^SDMAPI1(.RETURN,.CLN)" D EXSTCLN^ZZRGUSD5(RTN)
 S %=$$GETCSC^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1),$P(^DIC(40.7,$P(^SC(+SC,0),U,7),0),U,2))
 S $P(^SC(+SC,0),U,7)=""
 S %=$$GETCSC^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
VARLEN ;
 N RETURN,%
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked out
 S $P(^SC(+SC,0),U,7)=STOP
 S SD0=$E($$NOW^XLFDT(),1,10),$P(^SC(+SC,"SL"),U,2)=""
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,+LEN+15,NXT,RSN,.CIO,,,,,,1)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"INVPARAM","Unexpected error: "_$G(RETURN(0)))
 S $P(^SC(+SC,"SL"),U,2)="V"
 Q
XTENT ;
 ;;FRSTAVBL;Get first available date 
 ;;CLNCK;Check clinic for valid stop code restriction.
 ;;GETCLN;Get Clinic data
 ;;LSTCLNS;Get clinics
 ;;CLNRGHT;Verify clinic access
 ;;CLNVSC;Valid stop code
 ;;LSTAPPT;List appointment types
 ;;GETSCAP;Get clinic apt
 ;;GETAPPT;Get apt type
 ;;GETELIG;Get Eligibility Code
 ;;GETPEND;Get pending appointments
 ;;LSTCAPTS;List clinic appointments
 ;;LSTPAPTS;List patient appointments
 ;;SLOTS;Get available slots
 ;;SCEXST;Get Stop Cod Exception status
 ;;LSTCRSNS;Get cancelation reasons.
 ;;GETCSC;Get clinic stop code
 ;;VARLEN;Make appt var length
