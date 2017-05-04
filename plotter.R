### @author      Alexander Elton-Pym aelt7654@uni.sydney.edu.au
### @version     1.0     

#read and review state data
mydata = read.csv(file="input.csv", header = TRUE, sep = ",")
summary(mydata)

#for each state
for(i in 2:9){
  titleName = colnames(mydata)[i] #get state name
  print(titleName)
  pdf(file=paste(titleName, "pdf", sep="."), width=11.69, height=8.27) #initiate file
  barplot(mydata[, i], names.arg=mydata[,1], main = titleName, ylim =c(0,12), cex.names = 0.5) #plot bargraph
  dev.off() #close file
}