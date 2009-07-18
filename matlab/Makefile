#
#   Makefile for running tests on ode params scripts
#
#   $Id: Makefile 2 2008-11-18 03:26:48Z bjandre $
#

# command for running matlab as a batch process
#    matlab -nosplash -nodesktop < runoff_driver.m > /dev/null


#
# Macros for controling compilers and options
#
# ...none

TESTS = \
	iob_driver \
	runoff_driver \
	subBio_driver \
	pyrite_driver 

SRC_IOB = examples/iob-kinetics/k108
SRC_RUNOFF = examples/runoff/runoff
SRC_PYRITE = examples/pyrite-fe3-kinetics/pyrite-fe3
SRC_SUBBIO = examples/substrate-biomass/sub-bio

#
# build rule for all tests
#
tests : $(TESTS)
test : tests

#
# individual tests
#
iob : iob_driver
iob_driver : 
	@echo
	-matlab -nosplash -nodesktop < $@.m > /dev/null
	-diff --brief $(SRC_IOB).params.txt $(SRC_IOB).params.txt.test
	-diff --brief $(SRC_IOB).time.txt $(SRC_IOB).time.txt.test
	-diff --brief $(SRC_IOB).plotData.txt $(SRC_IOB).plotData.txt.test
	@echo

runoff : runoff_driver
runoff_driver : 
	@echo
	-matlab -nosplash -nodesktop < $@.m > /dev/null
	-diff --brief $(SRC_RUNOFF).params.txt $(SRC_RUNOFF).params.txt.test
	-diff --brief $(SRC_RUNOFF).time.txt $(SRC_RUNOFF).time.txt.test
	-diff --brief $(SRC_RUNOFF).plotData.txt $(SRC_RUNOFF).plotData.txt.test
	@echo

subBio : subBio_driver
subBio_driver :
	@echo
	-matlab -nosplash -nodesktop < $@.m > /dev/null
	-diff --brief $(SRC_SUBBIO).params.txt $(SRC_SUBBIO).params.txt.test
	-diff --brief $(SRC_SUBBIO).time.txt $(SRC_SUBBIO).time.txt.test
	-diff --brief $(SRC_SUBBIO).plotData.txt $(SRC_SUBBIO).plotData.txt.test
	@echo

pyrite : pyrite_driver
pyrite_driver : 
	@echo
	-matlab -nosplash -nodesktop < $@.m > /dev/null
	-diff --brief $(SRC_PYRITE).params.txt $(SRC_PYRITE).params.txt.test
	-diff --brief $(SRC_PYRITE).time.txt $(SRC_PYRITE).time.txt.test
	-diff --brief $(SRC_PYRITE).plotData.txt $(SRC_PYRITE).plotData.txt.test
	@echo





#
# clean - Clean up the directory.
#
clean :
	-rm -f *~ *.CKP *.ln *.BAK *.bak .*.bak \
		core errs \
		,* .emacs_* \
		tags TAGS \
		make.log MakeOut \
		*.out

# 
# clobber - Really clean up the directory.
#
clobber : clean
	-rm -f .Makedepend *.o *.il \
		$(SRC_IOB)*.txt \
		$(SRC_RUNOFF)*.txt \
		$(SRC_PYRITE)*.txt \
		$(SRC_SUBBIO)*.txt

#
# FORCE - Null rule to force things to happen.  
#
FORCE :

