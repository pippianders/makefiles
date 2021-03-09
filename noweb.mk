ifndef NOWEB_MK
NOWEB_MK = true

NOWEAVE.tex?=       noweave ${NOWEAVEFLAGS.tex} $< > $@
NOWEAVEFLAGS.tex?=  -x -n -delay -t2
NOWEAVE.pdf?=       \
  noweave ${NOWEAVEFLAGS.pdf} $< > ${@:.pdf=.tex} && \
  latexmk -pdf ${@:.pdf=.tex}
NOWEAVEFLAGS.pdf?=  -x -t2
NOTANGLEFLAGS?= -t2
NOTANGLE?=      notangle ${NOTANGLEFLAGS} -R$(notdir $@) $(filter %.nw,$^) | \
                  ${CPIF} $@
CPIF?=          cpif
NOWEB_SUFFIXES+=    .c .cc .cpp .cxx
NOTANGLEFLAGS.c?=   ${NOTANGLEFLAGS} -L
NOTANGLE.c?=        notangle ${NOTANGLEFLAGS.c} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.cc?=  ${NOTANGLEFLAGS.c}
NOTANGLE.cc?=       notangle ${NOTANGLEFLAGS.cc} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.cpp?= ${NOTANGLEFLAGS.c}
NOTANGLE.cpp?=      notangle ${NOTANGLEFLAGS.cpp} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.cxx?= ${NOTANGLEFLAGS.c}
NOTANGLE.cxx?=      notangle ${NOTANGLEFLAGS.cxx} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOWEB_SUFFIXES+=    .h .hh .hpp .hxx
NOTANGLEFLAGS.h?=   ${NOTANGLEFLAGS} -L
NOTANGLE.h?=        notangle ${NOTANGLEFLAGS.h} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.hh?=  ${NOTANGLEFLAGS.h}
NOTANGLE.hh?=       notangle ${NOTANGLEFLAGS.hh} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.hpp?= ${NOTANGLEFLAGS.h}
NOTANGLE.hpp?=      notangle ${NOTANGLEFLAGS.hpp} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOTANGLEFLAGS.hxx?= ${NOTANGLEFLAGS.h}
NOTANGLE.hxx?=      notangle ${NOTANGLEFLAGS.hxx} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOWEB_SUFFIXES+=    .hs
NOTANGLEFLAGS.hs?=  ${NOTANGLEFLAGS} -L
NOTANGLE.hs?=       notangle ${NOTANGLEFLAGS.hs} -R$(notdir $@) \
  $(filter %.nw,$^) | ${CPIF} $@
NOWEB_SUFFIXES+=    .mk
NOTANGLEFLAGS.mk?=  ${NOTANGLEFLAGS} -t2
NOTANGLE.mk?=       notangle ${NOTANGLEFLAGS.mk} -R$(notdir $@) \
  $(filter %.nw,$^) > $@
NOWEB_SUFFIXES+=    .py .sty .cls .sh .go

define default_tangling
NOTANGLEFLAGS$(1)?= $${NOTANGLEFLAGS}
NOTANGLE$(1)?=      notangle $${NOTANGLEFLAGS$(1)} -R$$(notdir $$@) \
  $$(filter %.nw,$$^) > $$@
endef

$(foreach suffix,${NOWEB_SUFFIXES},$(eval $(call default_tangling,${suffix})))

INCLUDE_MAKEFILES?=.
MAKEFILES_DIR?=${INCLUDE_MAKEFILES}
include ${MAKEFILES_DIR}/tex.mk

%.pdf: %.nw
	${NOWEAVE.pdf}

define def_weave_to_pdf
%.pdf: %$(1).nw
	$${NOWEAVE.pdf}
endef

$(foreach suf,${NOWEB_SUFFIXES},$(eval $(call def_weave_to_pdf,${suf})))
%.tex: %.nw
	${NOWEAVE.tex}

define def_weave_to_tex
%.tex: %$(1).nw
	$${NOWEAVE.tex}
endef

$(foreach suf,${NOWEB_SUFFIXES},$(eval $(call def_weave_to_tex,${suf})))
%.h: %.c.nw
	${NOTANGLE.h}

%.hh: %.cc.nw
	${NOTANGLE.hh}

%.hpp: %.cpp.nw
	${NOTANGLE.hpp}

%.hxx: %.cxx.nw
	${NOTANGLE.hxx}
$(addprefix %,${NOWEB_SUFFIXES}): %.nw
	${NOTANGLE$(suffix $@)}

%: %.nw
	${NOTANGLE$(suffix $@)}

endif
