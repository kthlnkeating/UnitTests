ZZSDEXT ;Unit Tests - External API; 7/18/13
 ;;1.0;UNIT TEST;;
 Q:$T(^SDMEXT)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZSDEXT")
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
LSTMGRP ; Get Mail Groups
 N RE,%
 S %=$$LSTMGRP^SDMEXT(.RE)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(0),"284^*^0^","Invalid 0 node")
 S %=$$LSTMGRP^SDMEXT(.RE,,.PART,3)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(PART,"AFJX PATID FILTER BLOCK","Invalid start return")
 D CHKEQ^XTMUNIT(RE(0),"3^3^1^","Invalid 0 node")
 D CHKEQ^XTMUNIT(RE(1,"ID"),"80","Invalid ID")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),"ABSV BETA","Invalid NAME")
 Q
 ;
LSTEFRM ; Get Encounter Forms
 N RE,%
 S $P(^IBE(357,1,0),U,7)=0
 S %=$$LSTEFRM^SDMEXT(.RE)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(0),"1^*^0^","Invalid 0 node")
 D CHKEQ^XTMUNIT(RE(1,"ID"),"1","Invalid ID")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),"TOOL KIT","Invalid NAME")
 Q
 ;
LSTPKGI ; Get Package Interfaces
 N RE,%
 S %=$$LSTPKGI^SDMEXT(.RE)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(0),"5^*^0^","Invalid 0 node")
 D CHKEQ^XTMUNIT(RE(1,"ID")_U_RE(1,"NAME"),"40^ACTION PROFILE - 45 DAYS","Invalid PKG 1")
 D CHKEQ^XTMUNIT(RE(2,"ID")_U_RE(2,"NAME"),"118^DG 1010F PRINT","Invalid PKG 2")
 D CHKEQ^XTMUNIT(RE(3,"ID")_U_RE(3,"NAME"),"41^INFORMATION PROFILE - 45 DAYS","Invalid PKG 3")
 D CHKEQ^XTMUNIT(RE(4,"ID")_U_RE(4,"NAME"),"117^LABB","Invalid PKG 4")
 D CHKEQ^XTMUNIT(RE(5,"ID")_U_RE(5,"NAME"),"42^ROUTING SLIP","Invalid PKG 5")
 Q
 ;
LSTREP ; Get Reports
 Q
XTENT ;
 ;;LSTMGRP;Get Mail Groups
 ;;LSTEFRM;Get Encounter forms
 ;;LSTPKGI;Get Package Interfaces
