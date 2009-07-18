#
#   Makefile for odeparams/doc
#
#   $Id: Makefile 2 2008-11-18 03:26:48Z bjandre $
#

#
# latex related stuff
#
LATEX = latex
BIBTEX = bibtex
DVIPS = dvips
PS2PDF = ps2pdf

DVIPSFLAGS = -t letter

export TEXINPUTS=.:/sw/share/texmf-dist/tex/latex/base:/sw/share/texmf-dist/tex/latex/graphics:/sw/share/texmf-dist/tex/latex/amsmath:/sw/share/texmf-dist/tex/latex/tools:/sw/share/texmf-dist/tex/latex/tools:

export BSTINPUTS=.:./styles

export BIBINPUTS=.

DOCUMENTS = \
	odeParamEst.dvi \

SRCS_OPE = \
	./odeParamEst

#SRCS_BIB = \
#	./ope.bib

# documents

odeParamEst : odeParamEst.dvi

# rules to run latex to get the dvi files
odeParamEst.dvi : $(SRCS_OPE:%=%.tex)
	$(LATEX) $(SRCS_OPE) 
#	$(BIBTEX) $(SRCS_OPE)
	$(LATEX) $(SRCS_OPE)
	$(LATEX) $(SRCS_OPE)

# send a copy to the printer. 
print_ope : 
	$(DVIPS) $(DVIPSFLAGS) $(SRCS_OPE)

# make a post-script file
ps : odeParamEst
	$(DVIPS) $(DVIPSFLAGS) $(SRCS_OPE) -o

# make a pdf file
pdf : ps
	$(PS2PDF) $(SRCS_OPE).ps $(SRCS_OPE).pdf

#
# Make everything.
#

all : $(DOCUMENTS)

#
# clean - Clean up the directory.
#

clean :
	-rm -f *~ *.CKP *.ln *.BAK *.bak .*.bak \
		core errs \
		,* .emacs_* \
		tags TAGS \
		make.log MakeOut \
		*.log *.aux *.blg *.bbl

# 
# clobber - Really clean up the directory.
#

clobber : clean
	-rm -f .Makedepend *.o *.il *.log *.aux *.dvi

#
# FORCE - Null rule to force things to happen.  
#

FORCE :

#
# printing the macros to the screen
#

macros :
	echo LATEX = $(LATEX)
