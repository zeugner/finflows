
W22self = function(inarr = aall) {
 ddd=as.data.table(inarr, na.rm=TRUE)
 ddd[COUNTERPART_AREA=='W2',COUNTERPART_AREA:=REF_AREA]
 aa= as.md3(ddd)
 #dont try this at home:
 attr(aa, 'dcstruct')[['COUNTERPART_AREA']] = setdiff(union(attr(aa, 'dcstruct')[['COUNTERPART_AREA']][,1],unique(ddd$COUNTERPART_AREA)),'W2')
 aa
}



self2W2 = function(inarr = aall) {
  ddd=as.data.table(aall, na.rm=TRUE)
  ddd[COUNTERPART_AREA==REF_AREA,COUNTERPART_AREA:='W2']
  aa= as.md3(ddd)
  #dont try this at home:
  attr(aa, 'dcstruct')[['COUNTERPART_AREA']] = rbind(attr(aa, 'dcstruct')[['COUNTERPART_AREA']],c('W2','W2'))
  aa
}


#Example: 
#aall= readRDS('V:/FinFlows/githubrepo/trialarea/data/aall_small.rds')
#aall=add.dim(aall,'COUNTERPART_AREA',c('W2','W1','W0'))
#aall = aperm(aall,c(2:length(dim(aall)),1))

#str(aall)
#str(W22self(aall)) # 
#str(self2W2(W22self(aall)))
