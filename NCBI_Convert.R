###Use the epost/efetch functions written by Laura to pull maizegdb accessions from XML file
options(stringsAsFactors = FALSE)

require(reutils)
require(readr)
require(XML)

#get GI accessions
giAccessions<-df$Accession
#remove gi accessions with alphas AKA nonconvertible
giAccessions<-giAccessions[-grep(giAccessions, pattern = "[a-zA-Z]")]

#first, convert GI to UID
#because more than 500, need to use epost first
p <- epost(giAccessions, db = "protein")
#efetch genpept file format for each UID, save to text file (requirement for epost>500)
efetch(p, db="protein",retmode = "text", rettype="gp", outfile = "efetch.txt")

#read in UID text
UIDVec<-read.delim(file="efetch.txt", header = FALSE)
#convert to vector
UIDVec<-UIDVec[,1]
#get gene IDs from full flat file
UIDVec2<-UIDVec[grep(UIDVec, pattern="GeneID")]
#gsub out "GeneID:" to get accession number
UIDVec2<-gsub(UIDVec2, pattern=".*:", replacement = "")
#check that there is a UID for each GI
length(UIDVec2)==length(giAccessions)