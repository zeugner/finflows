# setwd('V:/FinFlows/githubrepo/finflows')

rm(list=ls())
gc()
library(MDstats);library(MD3);
defaultcountrycode(NULL)
sink('data/cpisbuffer/cpisloader.log',append = FALSE)

if (!file.exists('data/cpisbuffer/whatctries.rds')) {
  whatctries = mds('IMF/CPIS/..I_A_D_T_T_BP6_USD..T.US',labels=TRUE)
  saveRDS(whatctries,'data/cpisbuffer/whatctries.rds')
} else {
  whatctries=readRDS('data/cpisbuffer/whatctries.rds')
}
ccc=dimcodes(whatctries)[[1]]
vseccp=c("T","CB","DC","FC","GG","IPF","NHN","ODX","OFT","OFX")
vsecref=c('T','CB','GG','HH','IPF','MMF','NFC','NHN','NP','ODX','OFI','OFM','OFO','OFT','OFX')

successmatcp=matrix(NA_character_,NROW(ccc),NROW(vseccp),dimnames = list(AREA=ccc[,1],COUNTERPART_SECTOR=vseccp))
successmatinv=matrix(NA_character_,NROW(ccc),NROW(vsecref),dimnames = list(AREA=ccc[,1],REF_SECTOR=vsecref))


linvsec=lcpsec=list()
cat('\nloading data for ',NROW(ccc),' reporting countries\n')
for (cc in ccc[,1]) {
    cat('\n___',as.character(Sys.time()),': country number ' %&% match(cc,ccc[,1]) %&% ': ' %&% cc %&% '... ____')
    
    tempto=vector('list',length(vseccp)); names(tempto)=vseccp
    tempfr=vector('list',length(vsecref)); names(tempfr)=vsecref
    
    
    
    
    cat('\ndoing counterpart sector for ' %&% cc %&% '...')
    for (sss in vseccp) {
      
        if (!file.exists('data/cpisbuffer/ccpsec_' %&% cc %&% '_' %&%  sss %&% '.rds')) {
        
          cat(' ' %&% sss %&% 'i ')
          tempto[[sss]]=try(mds('IMF/CPIS/.'%&% cc %&% '.I_A_D_L_T_BP6_USD+I_A_D_S_T_BP6_USD+I_A_E_T_T_BP6_USD+I_A_D_T_T_BP6_USD.T.' %&% sss %&% '.',drop=FALSE),silent=TRUE)
          if (is(tempto[[sss]],'md3')) { 
            successmatcp[cc,sss] = 'I' 
            saveRDS(tempto[[sss]], 'data/cpisbuffer/ccpsec_' %&% cc %&% '_' %&% sss %&% '.rds')
          
          } else if (any(grepl('err',class(tempto[[sss]])))) {
            if (any(grepl('SDMX result contains 0 time series',tempto[[sss]],ignore.case = TRUE))) { successmatcp[cc,sss] = '0' } else { successmatcp[cc,sss] = 'X'; Sys.sleep(3) }
          }
      
                
        } else {
          cat(' ' %&% sss %&% 'f ')
          tempto[[sss]] = readRDS('data/cpisbuffer/ccpsec_' %&% cc %&% '_' %&%  sss %&%  '.rds')
          successmatcp[cc,sss] = 'L'
        }
    }
        
    
    ato=tempto[[1]]; for (x in tempto[-1]) {    if (!grepl('err',class(x)[1L])) { ato=merge(ato,x)}    }
      
      
  
    cat('\ndoing reference sector for ' %&% cc %&% '...')
    for (sss in vsecref) {
    
      if (!file.exists('data/cpisbuffer/invsec_' %&% cc %&% '_' %&%  sss %&% '.rds')) {
        
        cat(' ' %&% sss %&% 'i ')
        tempfr[[sss]]=try(mds('IMF/CPIS/.'%&% cc %&% '.I_A_D_L_T_BP6_USD+I_A_D_S_T_BP6_USD+I_A_E_T_T_BP6_USD+I_A_D_T_T_BP6_USD.' %&% sss %&% '.T.',drop=FALSE),silent=TRUE)
        if (is(tempfr[[sss]],'md3')) { 
          successmatinv[cc,sss] = 'I' 
          saveRDS(tempfr[[sss]], 'data/cpisbuffer/invsec_' %&% cc %&% '_' %&% sss %&% '.rds')
          
        } else if (any(grepl('err',class(tempfr[[sss]])))) {
          if (any(grepl('SDMX result contains 0 time series',tempfr[[sss]],ignore.case = TRUE))) { successmatinv[cc,sss] = '0' } else { successmatinv[cc,sss] = 'X'; Sys.sleep(3) }
        }
        
        
      } else {
        cat(' ' %&% sss %&% 'f ')
        tempfr[[sss]] = readRDS('data/cpisbuffer/invsec_' %&% cc %&% '_' %&%  sss %&%  '.rds')
        successmatinv[cc,sss] = 'L'
      }
    }
    
    cat('...loading done\n')
    afr=tempfr[[1]]; for (x in tempfr[-1]) {    if (!grepl('err',class(x)[1L])) { afr=merge(afr,x)}    }
  


    lcpsec[[cc]] = ato
    linvsec[[cc]] = afr
    cat(as.character(Sys.timo('N')),"CPIS loading results\n  I=loaded from IMF; L=loaded from local file;  0=No series available from IMF;   X=server loading error\n",
      'COUNTERPART_SECTORs                  REF_SECTORS\n',file = 'data/cpisbuffer/resultstable.txt',append=FALSE)
    suppressWarnings(write.table(cbind(successmatcp,"   ",successmatinv),quote = FALSE,append = TRUE,file = 'data/cpisbuffer/resultstable.txt',col.names = NA))
  }
      

cat('\nsaving all...')
saveRDS(list(CP=lcpsec,INV=linvsec),'data/cpisbuffer/allcresultslist.rds')



#final reporting

reportfinal=function(inlist,mydim='REF_SECTOR') {
  temp=lapply(inlist,dim); 
  tempfailed=sapply(temp,\(x) any(x==0)) | sapply(temp, \(x) !length(x)) |  sapply(inlist, \(x) !is(x,'md3'))
  cat('\n',mydim,' loading failed for ',sum(tempfailed), ' countries: ',paste0(names(temp)[tempfailed],collapse=','))
  tempdim=sapply(inlist[!tempfailed],dim); 
  for (i in sort(unique(tempdim[mydim,]))){
    cat('\nThere are ',sum(tempdim[mydim,]==i),'  countries with ', i, '  ',mydim,': ', paste(colnames(tempdim)[tempdim[mydim,]==i], collapse=','))
  } 
  return(invisible(names(temp)[tempfailed]))
}



cat(as.character(Sys.timo('N')),"CPIS loading results\n  I=loaded from IMF; L=loaded from local file;  0=No series available from IMF;   X=server loading error\n",
    'COUNTERPART_SECTORs                  REF_SECTORS\n')
write.table(cbind(successmatcp,"   ",successmatinv),quote = FALSE,col.names = NA)
saverds(cbind(successmatcp,"   ",successmatinv),'data/cpisbuffer/resultstable.rds')

reportfinal(lcpsec, 'COUNTERPART_SECTOR')
reportfinal(linvsec)

#+CB+ODX+DC+FC+OFT+OFX+GG+IPF+
  
#  bbb=mds('IMF/CPIS/..I_A_D_L_T_BP6_USD.T.NHN.',ccode=NULL)




sink()


#for (ff in dir('data/cpisbuffer',pattern='^ccpsec')) {file.remove('data/cpisbuffer/' %&% ff)}
#fcc=reportfinal(linvsec)
#for (ff in fcc) {file.remove('data/cpisbuffer/invsec_' %&% ff %&% '.rds')}
