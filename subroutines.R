#some functions


runningMean <- function(x, countedA, countedN ) (countedA + cumsum(x))/(seq(along=x)+countedN)

doSimulation <- function(countedA, countedN,  nextN, nextProb, sNum){
  out <- data.frame(matrix(nrow = (nextN+1)*sNum, ncol = 4))
  
  index = 1
  for(sindex in 1:sNum){

    simulateYes <- rbinom(nextN, 1, prob = nextProb)
    outProb <- c(countedA/countedN, runningMean(simulateYes, countedA, countedN ))
    out[index:(index+nextN),] <- cbind(countedN:(countedN+nextN), outProb, ifelse(outProb[nextN+1]>.5, 1, 0), sindex)
    index <- index + nextN+1
  }
  
  out
}

if(FALSE){
tst <- doSimulation( 25, 50, 1000, .5, 100)
tst <- data.frame(tst)
names(tst) <- c("numVotes", "ProbA", "Win", "simIndex")

p <- ggplot(tst, aes(x = numVotes, y = ProbA, colour = factor(Win), group = factor(simIndex)))
p + geom_line()

}

