#!/usr/bin/python
#Script for feature extraction on speech-dat data
#Modified by TERJE GUNDERSEN 01/07/2009
import os
import sys

# input folder
recDir = 'data'

# output files
mfc_list = 'trainlist.scp'
wav_mfc_list = 'codetr.scp'

def main():
    print 'make trainlist.scp'
    makeMfcList(recDir,mfc_list)
    print 'make codetr.scp'
    makeWavMfcList(recDir,wav_mfc_list)
    print 'make train.mlf'
    os.popen('perl scripts/create_mlf_from_TG.pl -i data/textgrid -o train.mlf')
    # THIS COMMAND WILL NOT SHOW ANY OUTPUT PRINTS
    #print 'running training script'
    #os.popen('bash train.sh')

def makeMfcList(recDir,outFile):
    out = []
    fileList = os.listdir(recDir+'/rec') 
    for fname in fileList:
        if not fname.startswith('.'):
            out.append(recDir+'/mfcc/'+fname.replace('.wav','.mfc')+'\n')
    
    outFile = file(outFile, 'w')
    outFile.writelines(out)
    outFile.close()
    return

def makeWavMfcList(recDir,outFile):
    out = []
    fileList = os.listdir(recDir+'/rec') 
    for fname in fileList:
        if not fname.startswith('.'):
            fname=fname.replace('\n','')
            sourceFile = recDir+'/rec/'+fname
            targetFile = recDir+'/mfcc/'+fname.replace('.wav','.mfc')
            out.append(sourceFile+' '+targetFile+'\n')

    outFile = file(outFile, 'w')
    outFile.writelines(out)
    outFile.close()
    return

if __name__ == "__main__":
    main()
