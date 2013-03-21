ZZRGUT ;RGI/CBR - Unit Tests - Problem List API ;3/21/13
 ;;1.0;UNIT TEST;;Apr 25, 2012;Build 1;
 Q:$T(^GMPLAPI2)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUT")
 TROLLBACK
 Q
 ;
STARTUP ;
 N GMPIFN,PAT
 S DTIME=500 ;D INIT^GMPLMGR
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S GMPROV=1
 S DT=$P($$HTFM^XLFDT($H),".")
 S DTF=$$EXTDT^GMPLX(DT)
 D SELCLIN^ZZRGUTCM
 S U="^"
 D NEWPAT^ZZRGUTCM
 Q
 ;
SHUTDOWN ;
 Q
 ;
GETPLIST ;
 N RETURN
 S %=$$GETPLIST^GMPLAPI4(.RETURN,GMPDFN,"A")
 D CHKEQ^XTMUNIT(RETURN,0,"GETPLIST^GMPLMGR1: Active problems found")
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_RETURN(0))
 K RETURN
 S %=$$GETPLIST^GMPLAPI4(.RETURN,GMPDFN,"I")
 D CHKEQ^XTMUNIT(RETURN,1,"GETPLIST^GMPLMGR1: Inactive problems not found")
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_RETURN(0))
 Q
 ;
API2NEW ;
 N GMPFLD,GMPERR,NUM
 S GMPFLD(.01)="872^253.2"
 S GMPFLD(.05)="^Hypopituitarism (Diabetes Insipidus)"
 S GMPFLD(.08)="3120306^3/6/12"
 S GMPFLD(.12)="A^ACTIVE"
 S GMPFLD(.13)="3120101^1/1/12"
 S GMPFLD(1.01)="304837^Hypopituitarism (Diabetes Insipidus)"
 S GMPFLD(1.02)="P"
 S GMPFLD(1.03)=1
 S GMPFLD(1.04)="1^TESTMASTER,USER"
 S GMPFLD(1.05)="1^TESTMASTER,USER"
 S GMPFLD(1.06)=""
 S GMPFLD(1.07)=""
 S GMPFLD(1.08)=GMPCLIN
 S GMPFLD(1.09)="3120306^3/6/12"
 S GMPFLD(1.1)="0^NO"
 S GMPFLD(1.11)="0^NO"
 S GMPFLD(1.12)="0^NO"
 S GMPFLD(1.13)="0^NO"
 S GMPFLD(1.14)="A^ACUTE"
 S GMPFLD(10,0)=0
 S GMPFLD(10,"NEW",1)="TEST COMMENT"
 S %=$$NEW^GMPLAPI2(.GMPIFN,GMPDFN,GMPROV,.GMPFLD,1)
 I GMPIFN'>0 D FAIL^XTMUNIT("Save failed: "_$G(GMPIFN(0))) Q
 S NUM=$$NEXTNMBR^GMPLDAL(GMPDFN,GMPVAMC)-1
 D SELPN^ZZRGUTCM
 D CHKEQ^XTMUNIT($G(^AUPNPROB(GMPIFN,0)),"872^"_GMPDFN_"^"_DT_"^^"_+GMPOVNAR_"^"_GMPVAMC_"^"_NUM_"^"_DT_"^^^^A^3120101","Invalid data line 0. IFN: "_$G(GMPIFN))
 D CHKEQ^XTMUNIT($G(^AUPNPROB(GMPIFN,1)),"304837^P^"_DUZ_"^1^1^^^"_+GMPCLIN_"^3120306^0^0^0^0^A^^^^","Invalid data line 1. IFN: "_$G(GMPIFN,1))
 D CHKEQ^XTMUNIT($G(^AUPNPROB(GMPIFN,11,0)),"^9000011.11PA^1^1","Note facility not saved. IFN: "_$G(GMPIFN,1))
 D CHKTF^XTMUNIT($D(^AUPNPROB(GMPIFN,11,"B",GMPVAMC,1)),"Note facility index not created. IFN: "_$G(GMPIFN,1))
 D CHKEQ^XTMUNIT($G(^AUPNPROB(GMPIFN,11,1,11,0)),"^9000011.1111IA^1^1","Note file empty. IFN: "_$G(GMPIFN,1))
 D CHKEQ^XTMUNIT($G(^AUPNPROB(GMPIFN,11,1,11,1,0)),"1^^TEST COMMENT^A^"_DT_"^1","Invalid note: "_$G(^AUPNPROB(GMPIFN,11,1,11,1,0)))
 D CHKTF^XTMUNIT($D(^AUPNPROB(GMPIFN,11,1,11,"B",1,1)),"Note index not created. IFN: "_$G(GMPIFN,1))
 D CHKTF^XTMUNIT($D(^AUPNPROB("C",304837,GMPIFN)),"C index not updated. IFN: "_$G(GMPIFN,1))
 D CHKTF^XTMUNIT($D(^AUPNPROB("ACTIVE",GMPDFN,"A",GMPIFN)),"A index not updated. IFN: "_$G(GMPIFN,1))
 D CHKTF^XTMUNIT($D(^AUPNPROB("AC",GMPDFN,GMPIFN)),"AC index not updated. IFN: "_$G(GMPIFN,1))
 D CHKTF^XTMUNIT($D(^AUPNPROB("B",872,GMPIFN)),"B index not updated. IFN: "_$G(GMPIFN,1))
 Q
 ;
API2DEL ;
 N OK,NOTENMBR
 K GMPERR
 S %=$$DELETE^GMPLAPI2(.OK,GMPIFN,GMPROV,"DELETE TESTS")
 D CHKTF^XTMUNIT(OK,$G(OK(0)))
 D CHKEQ^XTMUNIT("H",$P($G(^AUPNPROB(GMPIFN,1)),U,2),"Record not marked as deleted")
 S NOTENMBR=+$P($G(^AUPNPROB(GMPIFN,11,1,11,0)),U,4)
 D CHKTF^XTMUNIT(NOTENMBR>0,"Delete note not saved.")
 D CHKEQ^XTMUNIT("DELETE TESTS",$P($G(^AUPNPROB(GMPIFN,11,1,11,NOTENMBR,0)),U,3),"Delete note not saved")
 K OK
 S %=$$DELETE^GMPLAPI2(.OK,GMPIFN,GMPROV,"DELETE TESTS") ; Should fail with 'Already deleted'
 D CHKTF^XTMUNIT('OK,"Deleted twice")
 Q
 ;
API2UPD ;
 N RETURN
 S %=$$UPDATE^GMPLAPI2(.RETURN,GMPIFN,GMPORIG,GMPFLD,GMPLUSER,GMPROV)
 Q
 ;
API2DET ;
 N RETURN
 S %=$$DETAIL^GMPLAPI2(.RETURN,GMPIFN,1,GMPROV)
 D CHKTF^XTMUNIT(%)
 D CHKEQ^XTMUNIT(RETURN(.01),"872^253.2")
 D CHKEQ^XTMUNIT(RETURN(.02),GMPDFN_"^GMPLTEST, PATIENT")
 D CHKEQ^XTMUNIT(RETURN(.03),DT_"^"_DTF)
 D CHKEQ^XTMUNIT(RETURN(.05),GMPOVNAR)
 D CHKEQ^XTMUNIT(RETURN(.06),"1^SOFTWARE SERVICE")
 D CHKEQ^XTMUNIT(RETURN(.08),DT_"^"_DTF)
 D CHKEQ^XTMUNIT(RETURN(.12),"A^ACTIVE")
 D CHKEQ^XTMUNIT(RETURN(.13),"3120101^1/1/12")
 D CHKEQ^XTMUNIT(RETURN(1.01),"304837^Hypopituitarism (Diabetes Insipidus)")
 D CHKEQ^XTMUNIT(RETURN(1.02),"P^PERMANENT")
 D CHKEQ^XTMUNIT(RETURN(1.03),DUZ_"^ALEXANDER,ROBERT")
 D CHKEQ^XTMUNIT(RETURN(1.04),"1^TESTMASTER,USER")
 D CHKEQ^XTMUNIT(RETURN(1.05),"1^TESTMASTER,USER")
 D CHKEQ^XTMUNIT(RETURN(1.06),"^")
 D CHKEQ^XTMUNIT(RETURN(1.07),"^")
 D CHKEQ^XTMUNIT(RETURN(1.08),GMPCLIN)
 D CHKEQ^XTMUNIT(RETURN(1.09),"3120306^3/6/12")
 D CHKEQ^XTMUNIT(RETURN(1.1),"0^NO")
 D CHKEQ^XTMUNIT(RETURN(1.11),"0^")
 D CHKEQ^XTMUNIT(RETURN(1.12),"0^")
 D CHKEQ^XTMUNIT(RETURN(1.13),"0^")
 D CHKEQ^XTMUNIT(RETURN(1.14),"A^ACUTE")
 D CHKEQ^XTMUNIT(RETURN(1.15),"^")
 D CHKEQ^XTMUNIT(RETURN(1.16),"^")
 D CHKEQ^XTMUNIT(RETURN(1.17),"^")
 D CHKEQ^XTMUNIT(RETURN(1.18),"^")
 D CHKEQ^XTMUNIT(RETURN(10),1)
 D CHKEQ^XTMUNIT(RETURN(10,1),"1^1^TEST COMMENT^A^"_DT_"^1")
 Q
 ;
API2DETX ;
 N RETURN
 S %=$$DETAILX^GMPLAPI2(.RETURN,GMPIFN,1,GMPROV,1)
 D CHKTF^XTMUNIT(%)
 D CHKEQ^XTMUNIT(RETURN("COMMENT"),1)
 D CHKEQ^XTMUNIT(RETURN("COMMENT",1),DTF_"^TESTMASTER,USER^TEST COMMENT")
 D CHKEQ^XTMUNIT(RETURN("CONDITION"),"PERMANENT")
 D CHKEQ^XTMUNIT(RETURN("DIAGNOSIS"),253.2)
 D CHKEQ^XTMUNIT(RETURN("ENTERED"),DTF_"^ALEXANDER,ROBERT")
 D CHKEQ^XTMUNIT(RETURN("EXPOSURE"),0)
 D CHKEQ^XTMUNIT(RETURN("HISTORY"),0)
 D CHKEQ^XTMUNIT(RETURN("MODIFIED"),DTF)
 D CHKEQ^XTMUNIT(RETURN("NARRATIVE"),$P(GMPOVNAR,"^",2))
 D CHKEQ^XTMUNIT(RETURN("ONSET"),"1/1/12")
 D CHKEQ^XTMUNIT(RETURN("PATIENT"),"GMPLTEST, PATIENT")
 D CHKEQ^XTMUNIT(RETURN("PRIORITY"),"ACUTE")
 D CHKEQ^XTMUNIT(RETURN("PROVIDER"),"TESTMASTER,USER")
 D CHKEQ^XTMUNIT(RETURN("RECORDED"),"3/6/12^TESTMASTER,USER")
 D CHKEQ^XTMUNIT(RETURN("RESOLVED"),"")
 D CHKEQ^XTMUNIT(RETURN("SC"),"NO")
 D CHKEQ^XTMUNIT(RETURN("SERVICE"),"")
 D CHKEQ^XTMUNIT(RETURN("STATUS"),"ACTIVE")
 Q
 ;
API2VFY ;
 N RETURN
 S %=$$VERIFY^GMPLAPI2(.RETURN,GMPIFN)
 D CHKTF^XTMUNIT('%)
 D CHKEQ^XTMUNIT(RETURN(0),"PRBVRFD^Problem Already Verified","Invalid error message")
 Q
 ;
API2DLTD ;
 N RETURN
 S %=$$DELETED^GMPLAPI2(.RETURN,GMPIFN)
 D CHKTF^XTMUNIT(RETURN)
 Q
 ;
API2VFD ;
 N RETURN
 S %=$$VERIFIED^GMPLAPI2(.RETURN,GMPIFN)
 D CHKTF^XTMUNIT(RETURN)
 Q
 ;
API2ACT1 ;
 N RETURN
 S %=$$ACTIVE^GMPLAPI2(.RETURN,GMPIFN)
 D CHKTF^XTMUNIT(RETURN,GMPIFN_" problem should be ACTIVE")
 Q
 ;
API2ACT2 ;
 N RETURN
 S %=$$ACTIVE^GMPLAPI2(.RETURN,GMPIFN)
 D CHKTF^XTMUNIT('RETURN,GMPIFN_" problem should be INACTIVE")
 Q
 ;
API2INCT ;
 N RETURN
 S %=$$INACTV^GMPLAPI2(.RETURN,GMPIFN,GMPROV,"INACTIVATION NOTE",DT)
 D CHKTF^XTMUNIT(RETURN,$G(RETURN(0)))
 Q
 ;
API2ONST ;
 N RETURN
 S %=$$ONSET^GMPLAPI2(.RETURN,GMPIFN)
 D CHKEQ^XTMUNIT(RETURN,"3120101")
 Q
 ;
API3NTE ;
 N RETURN
 S %=$$FULLNTE^GMPLAPI3(.RETURN,GMPIFN)
 D CHKEQ^XTMUNIT(RETURN(+$G(DUZ(2)),1),"1^^TEST COMMENT^A^"_DT_"^1")
 D CHKEQ^XTMUNIT(RETURN(+$G(DUZ(2)),2),"2^^INACTIVATION NOTE^A^"_DT_"^1")
 D CHKEQ^XTMUNIT(RETURN(+$G(DUZ(2)),3),"3^^DELETE TESTS^A^"_DT_"^1")
 Q
 ;
API4LSTM ;
 N RETURN
 S %=$$LASTMOD^GMPLAPI4(.RETURN,GMPIFN)
 D CHKEQ^XTMUNIT(RETURN,DT)
 Q
 ;
XTENT ;
 ;;API2NEW
 ;;API2ONST
 ;;API2VFY
 ;;API2VFD
 ;;API2DET
 ;;API2DETX
 ;;API2ACT1
 ;;API2INCT
 ;;API2ACT2
 ;;GETPLIST
 ;;API2DEL
 ;;API4LSTM
 ;;API3NTE
 ;;API2DLTD
 Q
 ;
