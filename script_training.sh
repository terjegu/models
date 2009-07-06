#!/bin/bash

HCopy -A -D -T 1 -C hcpconf -S codetr.scp

HInit -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/proto/up.mmf -l up -L data/lab -I train.mlf up
HInit -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/proto/down.mmf -l down -L data/lab -I train.mlf down
HInit -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/proto/left.mmf -l left -L data/lab -I train.mlf left
HInit -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/proto/right.mmf -l right -L data/lab -I train.mlf right
HInit -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/proto/sil.mmf -l sil -L data/lab -I train.mlf sil

# Re-estimation
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/up.mmf -l up -L data/lab -I train.mlf up
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/up.mmf -l up -L data/lab -I train.mlf up
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/up.mmf -l up -L data/lab -I train.mlf up
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/up.mmf -l up -L data/lab -I train.mlf up

HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/down.mmf -l down -L data/lab -I train.mlf down
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/down.mmf -l down -L data/lab -I train.mlf down
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/down.mmf -l down -L data/lab -I train.mlf down
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/down.mmf -l down -L data/lab -I train.mlf down

HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/left.mmf -l left -L data/lab -I train.mlf left
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/left.mmf -l left -L data/lab -I train.mlf left
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/left.mmf -l left -L data/lab -I train.mlf left
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/left.mmf -l left -L data/lab -I train.mlf left

HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/right.mmf -l right -L data/lab -I train.mlf right
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/right.mmf -l right -L data/lab -I train.mlf right
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/right.mmf -l right -L data/lab -I train.mlf right
HRest -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/right.mmf -l right -L data/lab -I train.mlf right

HRest -v 0.001 -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/sil.mmf -l sil -L data/lab -I train.mlf sil
HRest -v 0.001 -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/sil.mmf -l sil -L data/lab -I train.mlf sil
HRest -v 0.001 -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/sil.mmf -l sil -L data/lab -I train.mlf sil
HRest -v 0.001 -A -D -T 1 -i 40 -S trainlist.scp -M model/hmms -H model/hmms/sil.mmf -l sil -L data/lab -I train.mlf sil

# Take the isolated model files and merge into a mmf containing all word models
HHEd -H model/hmms/up.mmf -H model/hmms/down.mmf -H model/hmms/left.mmf -H model/hmms/right.mmf -H model/hmms/sil.mmf -w model/hmmtemp.mmf sil.hed hmmlist

# Finally, embedded reestimation
cp model/hmmtemp.mmf model/hmmdefs.mmf

HERest -T 1 -L data/lab -I train.mlf -S trainlist.scp -H model/hmmdefs.mmf -M model hmmlist
HERest -T 1 -L data/lab -I train.mlf -S trainlist.scp -H model/hmmdefs.mmf -M model hmmlist
HERest -T 1 -L data/lab -I train.mlf -S trainlist.scp -H model/hmmdefs.mmf -M model hmmlist
HERest -T 1 -L data/lab -I train.mlf -S trainlist.scp -H model/hmmdefs.mmf -M model hmmlist

# Parse word network
HParse -A -D -T 1 grammar wnet
