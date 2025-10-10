library(MD3)
library(MDstats)
aa=mds('ECB/QSA/Q.N.I9.W1+W0.S1M.S1.N.A.LE..._Z.XDC._T.S.V.N._T')
           
aanotap=aa[.._Z.]
aanotap[..2023q4]
aa[..T., usenames=TRUE, onlyna=TRUE] = aanotap[".."]
aa[...2023q4]


bb=mds('Estat/bop_iip6_q/A.MIO_EUR..S1M.S1.A_LE.EXT_EA20+EA20+WRL_REST.EA20')
dimnames(bb)
bb[FA__D__F51M.]
bbq=copy(bb); frequency(bbq)='Q'
dimnames(bbq)
bbq[FA__D__F51M+FA__O__F519.]

names(dimnames(bbq))[[1]] = 'INSTR_ASSET'
dimcodes(bbq)
bbq[FA__D__F51M+FA__O__F519.]


dimcodes(bbq)[["INSTR_ASSET"]][dimcodes(bbq)[["INSTR_ASSET"]][,1] == "FA__D__F51M", 1] <- "F51M_"
dimcodes(bbq)[["INSTR_ASSET"]][dimcodes(bbq)[["INSTR_ASSET"]][,1] == "FA__O__F519", 1] <- "F519"
dimcodes(bbq)[["INSTR_ASSET"]][dimcodes(bbq)[["INSTR_ASSET"]][,1] == "FA__O__F6", 1] <- "F6"
dimcodes(bbq)[["INSTR_ASSET"]][dimcodes(bbq)[["INSTR_ASSET"]][,1] == "FA__O__F81", 1] <- "F81"
dimcodes(bbq)[["INSTR_ASSET"]][dimcodes(bbq)[["INSTR_ASSET"]][,1] == "FA__O__F89", 1] <- "F89"
bbq[F51M_+F519.]

dimnames(bbq)
temp=bbq[F51M_.]+bbq[F519.]
bbq[F51M.]=temp
bbq[F51M.]

bbq_final <- bbq[c("F51M", "F6", "F81", "F89"),, drop=FALSE]
bbq_final[.]

aa[W1..T., usenames=TRUE, onlyna=TRUE] = bbq_final["."]
aa[..T.2023q4]

aa[W1.F51.T., usenames=TRUE, onlyna=TRUE] = aa[W1.F511.T.] + aa[W1.F51M.T.]
aa[W1.F2.T., usenames=TRUE, onlyna=TRUE] = aa[W1.F2M.T.]


aa[W1.F.T., usenames=TRUE, onlyna=TRUE] = aa[W1.F2.T.]+aa[W1.F3.T.]+aa[W1.F4.T.]+aa[W1.F51.T.]+aa[W1.F52.T.]+aa[W1.F6.T.]+aa[W1.F81.T.]+aa[W1.F89.T.]
aa[..T.2023q4]
aaa=aa[..T.]
dimcodes(aaa)


# what to keep
instruments_to_keep <- c("F", "F2", "F3", "F4", "F51", "F511", "F51M", "F52", "F6", "F81", "F89")
times_to_keep <- paste0(2013:2023, "q4")

# keep only the selected elements
exp_fisma <- aaa[c("W0", "W1"), instruments_to_keep, times_to_keep, drop=FALSE]

# Check the result
exp_fisma[..2023q4]

exp_fisma[W2..]=exp_fisma[W0..]-exp_fisma[W1..]

exp_fisma[.F.]
saveRDS(exp_fisma,file='data/exp_fisma.rds')


