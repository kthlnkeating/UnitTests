ZZSDPAR ;Unit Tests - Edit parameters API; 7/18/13
 ;;1.0;UNIT TEST;;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZSDPAR")
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
UPDMPAR ;
 N RE,%
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 ;D CHKEQ^XTMUNIT($P($G(RETURN(0)),U),"INVPARAM","Expected error: INVPARAM")
 ;invalid default check out screen
 S PAR("DEFCOSCR")="A"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""DEFCOSCR"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("DEFCOSCR")="1^YES"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(1,$P(^DG(43,1,0),U,32),"Invalid default check out screen")
 ;invalid start days
 S PAR("STRTDAYS")="3A"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""STRTDAYS"")^1","Expected error: INVPARAM")
 ;invalid start days
 S PAR("STRTDAYS")="31"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""STRTDAYS"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("STRTDAYS")="4"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(4,$P(^DG(43,1,"SCLR"),U,12),"Invalid start days")
 ;appt. update mail group
 D CHKMAIL("UPDMAIL",15,"1^POSTMASTER")
 ;npcdb mail group
 D CHKMAIL("NPCMAIL",16,"2^EN PROJECTS")
 ;npcdb mail group
 D CHKMAIL("LATMAIL",17,"3^FAM")
 ;npcdb mail group
 D CHKMAIL("APIMAIL",26,"4^IB NEW INSURANCE")
 ;invalid allow up-arrow out of class
 S PAR("UPARROW")="A"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""UPARROW"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("UPARROW")="1^YES"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(1,$P(^DG(43,1,"SCLR"),U,24),"Invalid allow up-arrow out of class")
 ;invalid api notifications to process
 S PAR("APILEVEL")="A"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""APILEVEL"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("APILEVEL")="E"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT("E",$P(^DG(43,1,"SCLR"),U,27),"Invalid API level")
 Q
 ;
CHKMAIL(FLD,PART,MGRP) ;
 ;invalid appt. update mail group
 S PAR(FLD)="A9999"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("""_FLD_""")^1","Expected error: INVPARAM")
 ;appt. update mail group not found
 S PAR(FLD)="99999"
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MGRPNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"MGRPNFND^Mail group not found^1","Expected error: MGRPNFND")
 ;ok
 S PAR(FLD)=MGRP
 S %=$$UPDMPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+MGRP,$P(^DG(43,1,"SCLR"),U,PART),"Invalid mail group"_FLD)
 Q
 ;
GETMPAR ;
 N RE,%
 S %=$$GETMPAR^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE("DEFCOSCR"),PAR("DEFCOSCR"),"Invalid default check-out screen")
 D CHKEQ^XTMUNIT(RE("STRTDAYS"),PAR("STRTDAYS"),"Invalid start days")
 D CHKEQ^XTMUNIT(RE("UPDMAIL"),PAR("UPDMAIL"),"Invalid appt. update mail group")
 D CHKEQ^XTMUNIT(RE("NPCMAIL"),PAR("NPCMAIL"),"Invalid npcdb mail group")
 D CHKEQ^XTMUNIT(RE("LATMAIL"),PAR("LATMAIL"),"Invalid late activity mail group")
 D CHKEQ^XTMUNIT(RE("APIMAIL"),PAR("APIMAIL"),"Invalid api errors mail group")
 D CHKEQ^XTMUNIT(RE("UPARROW"),PAR("UPARROW"),"Invalid allow up-arrow out of class.")
 Q
 ;
UPDDPAR ;
 N RE,%
 S DIV=$P(^DG(40.8,0),U,3)
 ;Invalid param DIV
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - DIV","Expected error: INVPARAM")
 ;Division not found
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DIVNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"DIVNFND^Medical Center Division not found.","Expected error: DIVNFND")
 K PAR
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 ;invalid DIV
 S PAR("ADDLOC")="A"
 S MP("GLMDIV")=1,%=$$UPDMPAR^DGPARAPI(,.MP)
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - DIV>1^1","Expected error: INVPARAM")
 ;invalid address location on letters
 S MP("GLMDIV")=0,%=$$UPDMPAR^DGPARAPI(,.MP)
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""ADDLOC"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("ADDLOC")="1^BOTTOM"
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(1,$P($G(^DG(40.8,DIV,"LTR")),U),"Invalid address location on letters")
 ;op lab test start time
 D CHKSTIME("OPLABST",2,"0901")
 ;op ekg start time
 D CHKSTIME("OPEKGST",3,"1001")
 ;op x-ray start time
 D CHKSTIME("OPXRAYST",4,"1101")
 Q
 ;
CHKSTIME(FLD,PART,TIME);
 ;invalid start time
 S PAR(FLD)="A"
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("""_FLD_""")^1","Expected error: INVPARAM")
 ;invalid start time
 S PAR(FLD)="31"
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("""_FLD_""")^1","Expected error: INVPARAM")
 ;
 S PAR(FLD)="901",%=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 S PAR(FLD)="09.01",%=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 S PAR(FLD)="09:01",%=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 ;ok
 S PAR(FLD)=TIME
 S %=$$UPDDPAR^SDPARAPI(.RE,.PAR,DIV)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+TIME,$P(^DG(40.8,DIV,"LTR"),U,PART),"Invalid start time")
 Q
 ;
GETDPAR ;
 N RE,%
 ;Invalid param DIV
 S %=$$GETDPAR^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - DIV","Expected error: INVPARAM")
 ;Division not found
 S %=$$GETDPAR^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DIVNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"DIVNFND^Medical Center Division not found.","Expected error: DIVNFND")
 ;Invalid param DIV
 S MP("GLMDIV")=1,%=$$UPDMPAR^DGPARAPI(,.MP)
 S %=$$GETDPAR^SDPARAPI(.RE,DIV)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - DIV>1^1","Expected error: INVPARAM")
 ;ok
 S MP("GLMDIV")=0,%=$$UPDMPAR^DGPARAPI(,.MP)
 S %=$$GETDPAR^SDPARAPI(.RE,DIV)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE("ADDLOC"),PAR("ADDLOC"),"Invalid address location on letters")
 D CHKEQ^XTMUNIT(RE("OPLABST"),+PAR("OPLABST"),"Invalid op lab test start time")
 D CHKEQ^XTMUNIT(RE("OPEKGST"),PAR("OPEKGST"),"Invalid op ekg start time")
 D CHKEQ^XTMUNIT(RE("OPXRAYST"),PAR("OPXRAYST"),"Invalid op x-ray start time")
 Q
 ;
UPDPMCS ;
 ;Invalid param SC
 S %=$$UPDPMCS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 S %=$$UPDPMCS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;basic default encounter form
 D CHKFRM("DEFEFRM",2,"1^TOOL KIT")
 ;supplmntl form #1 all patients
 D CHKFRM("SUPFRM1",6,"2^WORKCOPY")
 ;supplmntl form #2 all patients
 D CHKFRM("SUPFRM2",8,"3^DEFAULTS")
 ;supplmntl form #3 all patients
 D CHKFRM("SUPFRM3",9,"4^AMBULATORY SURGERY SAMPLE V2.1")
 ;supplmntl form - estblshed pt.
 D CHKFRM("SUPFRMEP",3,"5^EMERGENCY SERVICES SAMPLE V2.1")
 ;supplmntl form - first visit
 D CHKFRM("SUPFRMFV",4,"6^PRIMARY CARE SAMPLE V2.1")
 ;form w/o patient data
 D CHKFRM("FRMWO",5,"7^NATIONAL CARD CATH/INTERV RAD")
 ;reserved for future use
 D CHKFRM("REZFU",7,"8^NATIONAL CARDIOLOGY")
 ;invalid default check out screen
 S PAR("UPCMM")="A"
 S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM(""UPCMM"")^1","Expected error: INVPARAM")
 ;ok
 S PAR("UPCMM")="1^YES"
 S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(1,$P(^SD(409.95,1,0),U,10),"Invalid don't use pcmm providers")
 D CHKREP(1,"S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)",409.95) ;reports
 D CHKREP(2,"S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)",409.95) ;excluded reports
 Q
CHKREP(NODE,RTN,FILE) ;
 N PAR,%,RE
 S PAR(NODE,1,"COND")=1
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("_NODE_",1,""REPORT"")^1","Expected error: INVPARAM")
 S PAR(NODE,1,"REPORT")=999
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: REPNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"REPNFND^Report #999 not found.^1","Expected error: REPNFND")
 K PAR S PAR(NODE,1,"REPORT")=1
 I NODE=1 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 . D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("_NODE_",1,""COND"")^1","Expected error: INVPARAM")
 . S PAR(NODE,1,"REPORT")=1 S:NODE=1 PAR(NODE,1,"COND")=999
 . X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: CONNFND")
 . D CHKEQ^XTMUNIT($G(RE(0)),"CONNFND^Print Condition #999 not found.^1","Expected error: CONNFND")
 . S PAR(NODE,1,"REPORT")=1 S:NODE=1 PAR(NODE,1,"COND")=1
 . X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 . D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("_NODE_",1,""SIDES"")^1","Expected error: INVPARAM")
 . K PAR S PAR(NODE,1,"REPORT")=1 S:NODE=1 PAR(NODE,1,"COND")=1,PAR(NODE,1,"SIDES")=5
 . X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: CONNFND")
 . D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("_NODE_",1,""SIDES"")^1","Expected error: INVPARAM")
 K PAR S PAR(NODE,1,"REPORT")=1 S:NODE=1 PAR(NODE,1,"COND")=1,PAR(NODE,1,"SIDES")=1
 X RTN
 D CHKEQ^XTMUNIT("1"_$S(NODE=1:"^1^1",1:""),$G(^SD(FILE,1,NODE,1,0)),"Invalid report node")
 K PAR S PAR(NODE,1,"REPORT")=1 S:NODE=1 PAR(NODE,1,"COND")=2,PAR(NODE,1,"SIDES")=2
 X RTN
 D CHKEQ^XTMUNIT("1"_$S(NODE=1:"^2^2",1:""),$G(^SD(FILE,1,NODE,1,0)),"Invalid report node")
 K PAR S PAR(NODE,1,"REPORT")=2 S:NODE=1 PAR(NODE,1,"COND")=3,PAR(NODE,1,"SIDES")=0
 X RTN
 D CHKEQ^XTMUNIT("2"_$S(NODE=1:"^3^0",1:""),$G(^SD(FILE,1,NODE,2,0)),"Invalid report node")
 K PAR S PAR(NODE,1,"REPORT")=2 S:NODE=1 PAR(NODE,1,"COND")=3,PAR(NODE,1,"SIDES")=0
 S PAR(NODE,2,"REPORT")=40 S:NODE=1 PAR(NODE,2,"COND")=1,PAR(NODE,2,"SIDES")=0
 X RTN
 D CHKEQ^XTMUNIT("2"_$S(NODE=1:"^3^0",1:""),$G(^SD(FILE,1,NODE,2,0)),"Invalid report node")
 Q
 ;
CHKFRM(FLD,PART,FRM) ;
 ;invalid appt. update mail group
 S PAR(FLD)="A9999"
 S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - PARAM("""_FLD_""")^1","Expected error: INVPARAM")
 ;appt. update mail group not found
 S PAR(FLD)="99999"
 S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: FRMNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"FRMNFND^Encounter form not found^1","Expected error: FRMNFND")
 ;ok
 S PAR(FLD)=FRM
 S %=$$UPDPMCS^SDPARAPI(.RE,SC,.PAR)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+FRM,$P(^SD(409.95,1,0),U,PART),"Invalid form "_FLD)
 Q
 ;
GETPMCS ;
 N RE,%
 ;Invalid param SC
 S %=$$GETPMCS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 S %=$$GETPMCS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;Ok
 S %=$$GETPMCS^SDPARAPI(.RE,SC)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE("DEFEFRM"),PAR("DEFEFRM"),"Invalid basic default encounter form")
 D CHKEQ^XTMUNIT(RE("SUPFRM1"),PAR("SUPFRM1"),"Invalid supplmntl form #1 all patients")
 D CHKEQ^XTMUNIT(RE("SUPFRM2"),PAR("SUPFRM2"),"Invalid supplmntl form #2 all patients")
 D CHKEQ^XTMUNIT(RE("SUPFRM3"),PAR("SUPFRM3"),"Invalid supplmntl form #3 all patients")
 D CHKEQ^XTMUNIT(RE("SUPFRMEP"),PAR("SUPFRMEP"),"Invalid supplmntl form - estblshed pt.")
 D CHKEQ^XTMUNIT(RE("SUPFRMFV"),PAR("SUPFRMFV"),"Invalid supplmntl form - first visit")
 D CHKEQ^XTMUNIT(RE("FRMWO"),PAR("FRMWO"),"Invalid form w/o patient data")
 D CHKEQ^XTMUNIT(RE("REZFU"),PAR("REZFU"),"Invalid reserved for future use")
 D CHKEQ^XTMUNIT(RE(1,1,"COND"),"3^ONLY IF MULTIPLE APPOINTMENTS","Invalid cond 1")
 D CHKEQ^XTMUNIT(RE(1,1,"REPORT"),"2^DPT PATIENT'S SEX","Invalid report 1")
 D CHKEQ^XTMUNIT(RE(1,1,"SIDES"),"0^SIMPLEX","Invalid sides 1")
 D CHKEQ^XTMUNIT(RE(1,2,"COND"),"1^FOR EVERY APPOINTMENT","Invalid cond 2")
 D CHKEQ^XTMUNIT(RE(1,2,"REPORT"),"40^ACTION PROFILE - 45 DAYS","Invalid report 2")
 D CHKEQ^XTMUNIT(RE(1,2,"SIDES"),"0^SIMPLEX","Invalid sides 2")
 D CHKEQ^XTMUNIT(RE(2,1,"REPORT"),"2^DPT PATIENT'S SEX","Invalid ex. report 1")
 D CHKEQ^XTMUNIT(RE(2,2,"REPORT"),"40^ACTION PROFILE - 45 DAYS","Invalid ex. report 2")
 Q
 ;
DELPMCS ;
 N RE,%
 ;Invalid param SC
 S %=$$DELPMCS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 S %=$$DELPMCS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;Ok
 S %=$$DELPMCS^SDPARAPI(.RE,SC)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
 ;
UPDPMDS ;
 N RE,PAR,%
 S DIV=$P(^DG(40.8,0),U,3)
 ;Invalid param DIV
 S %=$$UPDPMDS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - DIV","Expected error: INVPARAM")
 ;Division not found
 S %=$$UPDPMDS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DIVNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"DIVNFND^Medical Center Division not found.","Expected error: DIVNFND")
 D CHKREP(1,"S %=$$UPDPMDS^SDPARAPI(.RE,DIV,.PAR)",409.96) ;reports
 Q
 ;
GETPMDS ;
 N RE,%
 ;Invalid param SC
 S %=$$GETPMDS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - DIV","Expected error: INVPARM")
 ;Division not found
 S %=$$GETPMDS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DIVNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"DIVNFND^Medical Center Division not found.","Expected error: DIVNFND")
 ;Ok
 S %=$$GETPMDS^SDPARAPI(.RE,DIV)
 D CHKEQ^XTMUNIT(RE("MCDIV"),"2^VISTA MEDICAL CENTER","Invalid division")
 Q
 ;
DELPMDS ;
 N RE,%
 ;Invalid param DIV
 S %=$$DELPMDS^SDPARAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - DIV","Expected error: INVPARM")
 ;Division not found
 S %=$$DELPMDS^SDPARAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DIVNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"DIVNFND^Medical Center Division not found.","Expected error: DIVNFND")
 ;Ok
 S %=$$DELPMDS^SDPARAPI(.RE,DIV)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
 ;
XTENT ;
 ;;UPDMPAR;Update Main Params
 ;;GETMPAR;Get Main Params
 ;;UPDDPAR;Update Division Params
 ;;GETDPAR;Get Division Params
 ;;UPDPMCS;Update Print Manager Clinic Setup
 ;;GETPMCS;Get Print Manager Clinic Setup
 ;;DELPMCS;Delete Print Manager Clinic Setup
 ;;UPDPMDS;Update Print Manager Division Setup
 ;;GETPMDS;Get Print Manager Division Setup
 ;;DELPMDS;Delete Print Manager Division Setup
