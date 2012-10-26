ZZRGUSD1 ;Unit Tests - Clinic API; 10/26/2012
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD1")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
CLNCK ;
 N RETURN
 S %=$$CLNCK^SDMAPI1(.RETURN,"")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNINV")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNINV","Expected error: CLNINV")
 ;
 K RETURN
 S %=$$CLNCK^SDMAPI1(.RETURN,SC+1)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNDFN")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNNDFN","Expected error: CLNNDFN")
 ;
 K RETURN S $P(^SC(SC,0),U,7)=""
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCIN")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCIN","Expected error: CLNSCIN")
 ;
 K RETURN S STOP=105,$P(^SC(SC,0),U,7)=STOP
 S $P(^DIC(40.7,STOP,0),U,6)="S"
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCPS")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCPS","Expected error: CLNSCPS")
 ;
 K RETURN S $P(^DIC(40.7,STOP,0),U,6)=""
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCNR")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCNR","Expected error: CLNSCNR")
 ;
 K RETURN
 S $P(^DIC(40.7,STOP,0),U,6)="P",$P(^DIC(40.7,STOP,0),U,7)=DT+1
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCRD")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCRD","Expected error: CLNSCRD")
 ;
 K RETURN
 S $P(^DIC(40.7,STOP,0),U,6)="P",$P(^DIC(40.7,STOP,0),U,7)=DT
 S %=$$CLNCK^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(RETURN(0)))
 Q
 ;
GETCLN ;
 N RETURN
 S %=$$GETCLN^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(RETURN("NAME"),"Test Clinic^Test Clinic")
 D CHKEQ^XTMUNIT(RETURN("STOP CODE NUMBER"),"105^EMERGENCY UNIT")
 D CHKEQ^XTMUNIT(RETURN("TYPE"),"C^CLINIC")
 D CHKEQ^XTMUNIT(RETURN("CREDIT STOP CODE"),"3^MENTAL HYGIENE(INDIV.)")
 D CHKEQ^XTMUNIT(RETURN("DEFAULT APPOINTMENT TYPE"),"9^REGULAR")
 D CHKEQ^XTMUNIT(RETURN("DISPLAY INCREMENTS PER HOUR"),"4^15-MIN ")
 D CHKEQ^XTMUNIT(RETURN("HOUR CLINIC DISPLAY BEGINS"),"")
 D CHKEQ^XTMUNIT(RETURN("INACTIVATE DATE"),"")
 D CHKEQ^XTMUNIT(RETURN("LENGTH OF APP'T"),"30^30")
 D CHKEQ^XTMUNIT(RETURN("MAX # DAYS FOR AUTO-REBOOK"),"")
 D CHKEQ^XTMUNIT(RETURN("MAX # DAYS FOR FUTURE BOOKING"),"2^2")
 D CHKEQ^XTMUNIT(RETURN("NON-COUNT CLINIC? (Y OR N)"),"Y^YES")
 D CHKEQ^XTMUNIT(RETURN("OVERBOOKS/DAY MAXIMUM"),"1^1")
 D CHKEQ^XTMUNIT(RETURN("PROHIBIT ACCESS TO CLINIC?"),"")
 D CHKEQ^XTMUNIT(RETURN("REACTIVATE DATE"),"")
 D CHKEQ^XTMUNIT(RETURN("SCHEDULE ON HOLIDAYS?"),"Y^YES")
 D CHKEQ^XTMUNIT(RETURN("VARIABLE APP'NTMENT LENGTH"),"")
 ;
 K RETURN
 S %=$$GETCLN^SDMAPI1(.RETURN,SC+1)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNNFND","Expected error: CLNNFND")
 Q
 ;
LSTCLNS ;
 N RETURN
 S %=$$LSTCLNS^SDMAPI1(.RETURN,CNAME)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: ")
 D CHKEQ^XTMUNIT(+RETURN(0),1)
 D CHKEQ^XTMUNIT(RETURN(1,"ID"),SC)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),CNAME)
 Q
 ;
CLNRGHT ;
 N RETURN
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"Access to clinic is not restricted")
 K RETURN S ^SC(SC,"SDPROT")="Y"
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNURGT")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNURGT","Expected error: CLNURGT")
 K RETURN S ^SC(SC,"SDPRIV",DUZ,0)=DUZ,^SC(SC,"SDPRIV",0)="^44.04PA^1^1"
 S %=$$CLNRGHT^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1,"User has access to this clinic")
 Q
 ;
CLNVSC ;
 N RETURN S $P(^DIC(40.7,STOP,0),U,3)=DT
 S %=$$CLNVSC^SDMAPI1(.RETURN,STOP)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNSCIN")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNSCIN","Expected error: CLNSCIN")
 K RETURN S $P(^DIC(40.7,STOP,0),U,3)=DT+1
 S %=$$CLNVSC^SDMAPI1(.RETURN,STOP)
 D CHKEQ^XTMUNIT(RETURN,1,"Stop code is valid")
 Q
LSTAPPT ;
 N RETURN
 S %=$$LSTAPPT^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(+RETURN(0),11)
 Q
GETSCAP ;
 N RETURN
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 K RETURN S %=$$GETSCAP^SDMAPI1(.RETURN,SC,DFN,SD)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN("IFN"),$O(^SC(SC,"S",SD,1,0)))
 D CHKEQ^XTMUNIT(RETURN("USER"),$P(^SC(SC,"S",SD,1,RETURN("IFN"),0),U,6),"Invalid user IFN")
 D CHKEQ^XTMUNIT(RETURN("DATE"),$P(^SC(SC,"S",SD,1,RETURN("IFN"),0),U,7),"Invalid apt date")
 D CHKEQ^XTMUNIT(RETURN("LENGTH"),$P(^SC(SC,"S",SD,1,RETURN("IFN"),0),U,2),"Invalid length")
 D CHKEQ^XTMUNIT(RETURN("CHECKOUT"),$P($G(^SC(SC,"S",SD,1,RETURN("IFN"),"C")),U,3),"Invalid checkout")
 Q
GETAPPT ;
 N RETURN
 S %=$$GETAPPT^SDMAPI1(.RETURN,1)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT($P(RETURN("NAME"),U),$P(^SD(409.1,1,0),U))
 Q
GETELIG ;
 N RETURN
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
 N RETURN
 S %=$$GETPEND^SDMAPI1(.RETURN,DFN,DT) ; Get pending appointments
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(SD,"APPOINTMENT TYPE"),$P(^SD(409.1,TYPE,0),U))
 D CHKEQ^XTMUNIT(RETURN(SD,"CLINIC"),$P(^SC(SC,0),U))
 D CHKEQ^XTMUNIT(RETURN(SD,"LENGTH OF APP'T"),LEN)
 Q
GETAPTS ;
 N RETURN
 S %=$$GETAPTS^SDMAPI1(.RETURN,DFN,SD)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"APPOINTMENT TYPE"),TYPE_U_$P(^SD(409.1,TYPE,0),U))
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"CLINIC"),SC_U_$P(^SC(SC,0),U))
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"DATA ENTRY CLERK"),DUZ_U_$P(^VA(200,DUZ,0),U))
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"PURPOSE OF VISIT"),"3"_U_"SCHEDULED VISIT")
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"SCHEDULING REQUEST TYPE"),"N"_U_"'NEXT AVAILABLE' APPT.")
 D CHKEQ^XTMUNIT(RETURN("APT",SD,"NEXT AVA. APPT. INDICATOR"),"3"_U_"'NEXT AVA.' APPT. INDICATED BY USER & CALCULATION")
 Q
FRSTAVBL ;
 N DATE
 S %=$$FRSTAVBL^SDMAPI1(.RETURN,SC)
 S DATE=$O(^SC(+SC,"T",0))
 D CHKEQ^XTMUNIT(RETURN,DATE,"INCORRECT Date")
 Q
LSTCAPTS ;
 N RETURN,SDT
 S SDT=DT+1_".08"
 S %=$$MAKE^SDMAPI2(.R,DFN,SC,SDT,TYPE,,LEN,NXT,RSN)
 S %=$$LSTCAPTS^SDMAPI1(.RETURN,SC,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"BID"),3445)
 D CHKEQ^XTMUNIT(RETURN(1,"DFN"),DFN)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),$P(^DPT(DFN,0),U))
 D CHKEQ^XTMUNIT(RETURN(1,"SC"),SC)
 D CHKEQ^XTMUNIT(RETURN(1,"GAF"),0)
 D CHKEQ^XTMUNIT(RETURN(1,"SD"),DT_".08")
 D CHKEQ^XTMUNIT(RETURN(1,"STAT"),"12;NON-COUNT;NON-COUNT;;;0")
 N RETURN S $P(^SC(SC,0),U,7)=526
 S ^DPT(DFN,.36)=11,$P(^DPT(DFN,"S",SDT,0),U,11)=1
 S %=$$LSTCAPTS^SDMAPI1(.RETURN,SC,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"GAF"),-1)
 Q
LSTPAPTS ;
 N RETURN
 S %=$$LSTPAPTS^SDMAPI1(.RETURN,DFN,.SDBEG,.SDEND,"ALL")
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT(RETURN(1,"BID"),3445)
 D CHKEQ^XTMUNIT(RETURN(1,"DFN"),DFN)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),$P(^DPT(DFN,0),U))
 D CHKEQ^XTMUNIT(RETURN(1,"SC"),SC)
 D CHKEQ^XTMUNIT(RETURN(1,"SD"),DT_".08")
 D CHKEQ^XTMUNIT(RETURN(1,"STAT"),"12;NON-COUNT;NON-COUNT;;;0")
 Q
SLOTS ;
 N RETURN
 S %=$$SLOTS^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
SCEXST ;
 N RETURN
 S %=$$SCEXST^SDMAPI1(.RETURN,107)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
LSTCRSNS ;
 N RETURN
 S %=$$LSTCRSNS^SDMAPI1(.RETURN)
 D CHKEQ^XTMUNIT(RETURN,1)
 D CHKEQ^XTMUNIT($P(RETURN(0),U),$P(^SD(409.2,0),U,4))
 Q
GETCSC ;
 N RETURN
 S $P(^SC(SC,0),U,7)=""
 S %=$$GETCSC^SDMAPI1(.RETURN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 ZW RETURN
 Q
XTENT ;
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
 ;;GETAPTS;Get patient appointments
 ;;FRSTAVBL;Get first available date 
 ;;LSTCAPTS;List clinic appointments
 ;;LSTPAPTS;List patient appointments
 ;;SLOTS;Get available slots
 ;;SCEXST;Get Stop Cod Exception status
 ;;LSTCRSNS;Get cancelation reasons.
 ;;GETCSC;Get clinic stop code
