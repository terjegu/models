#!/usr/bin/python
#Small script for making new prototypes
"""makeproto.py -- Make protoype file for use with HTK.

Switches:
    -h, --help         Displays this help message.
    -t <targetkind>, --targetkind=<targetkind>
                       HTK TARGETKIND parameter, e.g. 'MFCC_0_D_A'
    -s <numstates>, --states=<numstates>
                       Number of states to use in HMM. The number should
                       include the mandatory start and stop states used
                       by HTK.
    -v <vectorsize>, --vectorsize=<vectorsize>
                       The size of the feature vector given by --targetkind
                       parameter.
    -o <filename>, --outfile=<filename>
                       The filename (including path) to the prototype file
                       to be created.
                       
All switches except -h are mandatory.

Examples:
Creating a prototype file for targetkind MFCC_0_D with 10 cepstral
coeffisients (this gives a vector size of (1+10)*2=22) and a total of 8
states in HMM to be saved at 'lib/proto8':
    makeproto.py -t MFCC_0_D -v 22 -s 8 -o lib/proto8 """

import sys
import getopt



def main():

    # opts: options given with a parameter
    # xargs: arguments given without a parameter
    try:
        opts, xargs = getopt.getopt(sys.argv[1:], 'ho:t:s:v:', \
                                    ['help', 'outfile=', 'targetkind=', 'states=', 'vectorsize='])
    except getopt.error:
        print "Invalid switch!"
        print __doc__
        sys.exit(1)

    # Print usage if no options are passed
    if opts == []:
        print __doc__
        sys.exit(1)

    # Set default parameters
    targetkind = outfile = numstates = vecsize = None

    # Process options and arguments
    for opt, arg in opts:
        
        if opt in ['-h', '--help']:
            print __doc__
            sys.exit(0)

        elif opt in ['-t', '--targetkind']:
            targetkind = arg

        elif opt in ['-o', '--outfile']:
            outfile = arg

        elif opt in ['-s','--states']:
            numstates = int(arg)

        elif opt in ['-v', '--vectorsize']:
            vecsize = int(arg)
            
    # Check if input parameters are set
    if not (targetkind and outfile and numstates and vecsize):
        print 'Arguments are missing!'
        print __doc__
        sys.exit(1)


    # Build prototype string

    string = '<BeginHMM>\n\n' + \
             ' <NumStates> ' + str(numstates) + ' <VecSize> ' + str(vecsize) + \
             ' <' + targetkind + '> <nullD> <diagC>\n' + \
             ' <StreamInfo> 1 ' + str(vecsize) + '\n'

    for state in range(2, numstates):
        string += ' <State> ' + str(state) + ' <NumMixes> 1 <Stream> 1\n' + \
                  '  <Mixture> 1 1.0\n' + \
                  '   <Mean> ' + str(vecsize) + '\n' + \
                  '    ' + ' '.join(["0.0" for num in xrange(vecsize)]) + '\n' + \
                  '   <Variance> ' + str(vecsize) + '\n' + \
                  '    ' + ' '.join(["1.0" for num in xrange(vecsize)]) +'\n'

    string += ' <TransP> ' + str(numstates) + '\n' + \
              '  0.00 1.00 ' + ' '.join(["0.00" for x in xrange(numstates-2)]) + '\n'

    for row in xrange(1, int(numstates) - 1):
        string += '  ' + ' '.join(["0.00" for x in xrange(row)]) + ' 0.50 0.50 ' + \
                  ' '.join(["0.00" for x in xrange(int(numstates) - row - 2)]) + '\n'
                           
    string += '  ' + ' '.join(["0.00" for x in xrange(numstates)]) + '\n' + \
              '<EndHMM>\n'

    # Write string to prototype file
    
    try:
        out = file(outfile, 'w')
        out.writelines(string)
        out.close()
    except:
        print "Could not write to prototype file in " + outfile + ". Check if directory exists."
        sys.exit(1)


if __name__ == "__main__":
    main()

        
