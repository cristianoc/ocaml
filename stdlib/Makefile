#**************************************************************************
#*                                                                        *
#*                                 OCaml                                  *
#*                                                                        *
#*            Xavier Leroy, projet Cristal, INRIA Rocquencourt            *
#*                                                                        *
#*   Copyright 1999 Institut National de Recherche en Informatique et     *
#*     en Automatique.                                                    *
#*                                                                        *
#*   All rights reserved.  This file is distributed under the terms of    *
#*   the GNU Lesser General Public License version 2.1, with the          *
#*   special exception on linking described in the file LICENSE.          *
#*                                                                        *
#**************************************************************************

include ../config/Makefile
include ../Makefile.common

CAMLRUN ?= ../boot/ocamlrun
CAMLYACC ?= ../boot/ocamlyacc
TARGET_BINDIR ?= $(BINDIR)

COMPILER=../ocamlc
CAMLC=$(CAMLRUN) $(COMPILER)
COMPFLAGS=-strict-sequence -absname -w +a-4-9-41-42-44-45-48 \
          -g -warn-error A -bin-annot -nostdlib \
          -safe-string -strict-formats
ifeq "$(FLAMBDA)" "true"
OPTCOMPFLAGS=-O3
else
OPTCOMPFLAGS=
endif
OPTCOMPILER=../ocamlopt
CAMLOPT=$(CAMLRUN) $(OPTCOMPILER)
CAMLDEP=$(CAMLRUN) ../tools/ocamldep

# Object file prefix
P=stdlib__

OBJS=camlinternalFormatBasics.cmo stdlib.cmo $(OTHERS)
OTHERS= $(P)pervasives.cmo $(P)seq.cmo $(P)option.cmo $(P)result.cmo \
  $(P)char.cmo $(P)uchar.cmo $(P)sys.cmo $(P)list.cmo \
  $(P)bytes.cmo $(P)string.cmo \
  $(P)marshal.cmo $(P)obj.cmo $(P)float.cmo $(P)array.cmo \
  $(P)int32.cmo $(P)int64.cmo $(P)nativeint.cmo \
  $(P)lexing.cmo $(P)parsing.cmo \
  $(P)set.cmo $(P)map.cmo $(P)stack.cmo $(P)queue.cmo \
  camlinternalLazy.cmo $(P)lazy.cmo $(P)stream.cmo \
  $(P)buffer.cmo camlinternalFormat.cmo $(P)printf.cmo \
  $(P)arg.cmo $(P)printexc.cmo $(P)gc.cmo \
  $(P)digest.cmo $(P)random.cmo $(P)hashtbl.cmo $(P)weak.cmo \
  $(P)format.cmo $(P)scanf.cmo $(P)callback.cmo \
  camlinternalOO.cmo $(P)oo.cmo camlinternalMod.cmo \
  $(P)genlex.cmo $(P)ephemeron.cmo \
  $(P)filename.cmo $(P)complex.cmo \
  $(P)arrayLabels.cmo $(P)listLabels.cmo $(P)bytesLabels.cmo \
  $(P)stringLabels.cmo $(P)moreLabels.cmo $(P)stdLabels.cmo \
  $(P)spacetime.cmo $(P)bigarray.cmo

PREFIXED_OBJS=$(filter stdlib__%.cmo,$(OBJS))
UNPREFIXED_OBJS=$(PREFIXED_OBJS:stdlib__%.cmo=%)

.PHONY: all
all: stdlib.cma std_exit.cmo camlheader target_camlheader camlheader_ur

ifeq "$(RUNTIMED)" "true"
all: camlheaderd target_camlheaderd
endif

ifeq "$(RUNTIMEI)" "true"
all: camlheaderi target_camlheaderi
endif

ifeq "$(PROFILING)" "true"
PROFILINGTARGET = prof
else
PROFILINGTARGET = noprof
endif

.PHONY: allopt opt.opt # allopt and opt.opt are synonyms
allopt: stdlib.cmxa std_exit.cmx allopt-$(PROFILINGTARGET)
opt.opt: allopt

.PHONY: allopt-noprof
allopt-noprof:

.PHONY: allopt-prof
allopt-prof: stdlib.p.cmxa std_exit.p.cmx
	rm -f std_exit.p.cmi

LEGACY_OBJS=$(patsubst stdlib__%,"$(INSTALL_LIBDIR)/%", \
                                  $(filter stdlib__%,$(OBJS)))
.PHONY: install
install::
# Transitional: when upgrading from 4.06 -> 4.07, module M is in stdlib__m.cm*,
# while previously it was in m.cm*, which confuses the compiler.
	rm -f $(LEGACY_OBJS)
# Remove "old" pervasives.* and bigarray.* to avoid getting confused with the
# Stdlib versions.
	rm -f "$(INSTALL_LIBDIR)/pervasives.*" "$(INSTALL_LIBDIR)/bigarray.*"
# End transitional
	$(INSTALL_DATA) \
	  stdlib.cma std_exit.cmo *.cmi camlheader_ur \
	  "$(INSTALL_LIBDIR)"
ifeq "$(INSTALL_SOURCE_ARTIFACTS)" "true"
	$(INSTALL_DATA) \
	  *.cmt *.cmti *.mli *.ml \
	  "$(INSTALL_LIBDIR)"
endif
	$(INSTALL_DATA) target_camlheader "$(INSTALL_LIBDIR)/camlheader"

ifeq "$(RUNTIMED)" "true"
install::
	$(INSTALL_DATA) target_camlheaderd "$(INSTALL_LIBDIR)"
endif

ifeq "$(RUNTIMEI)" "true"
install::
	$(INSTALL_DATA) target_camlheaderi "$(INSTALL_LIBDIR)"
endif

.PHONY: installopt
installopt: installopt-default installopt-$(PROFILINGTARGET)

.PHONY: installopt-default
installopt-default:
	$(INSTALL_DATA) \
	  stdlib.cmxa stdlib.$(A) std_exit.$(O) *.cmx \
	  "$(INSTALL_LIBDIR)"
	cd "$(INSTALL_LIBDIR)"; $(RANLIB) stdlib.$(A)

.PHONY: installopt-noprof
installopt-noprof:

.PHONY: installopt-prof
installopt-prof:
	$(INSTALL_DATA) \
	  stdlib.p.cmxa stdlib.p.$(A) std_exit.p.cmx std_exit.p.$(O) \
	  "$(INSTALL_LIBDIR)"
	cd "$(INSTALL_LIBDIR)"; $(RANLIB) stdlib.p.$(A)

ifeq "$(UNIX_OR_WIN32)" "unix"
HEADERPROGRAM = header.c
else # Windows
HEADERPROGRAM = headernt.c
endif

CAMLHEADERS =\
  camlheader target_camlheader camlheader_ur \
  camlheaderd target_camlheaderd \
  camlheaderi target_camlheaderi

ifeq "$(HASHBANGSCRIPTS)" "true"
$(CAMLHEADERS): ../config/Makefile
	for suff in '' d i; do \
	  echo '#!$(BINDIR)/ocamlrun'$$suff > camlheader$$suff && \
	  echo '#!$(TARGET_BINDIR)/ocamlrun'$$suff >target_camlheader$$suff; \
	done && \
	echo '#!' | tr -d '\012' > camlheader_ur;
else # Hashbang scripts not supported

$(CAMLHEADERS): $(HEADERPROGRAM) ../config/Makefile

ifeq "$(UNIX_OR_WIN32)" "unix"
$(CAMLHEADERS):
	for suff in '' d i; do \
	  $(CC) $(OC_CFLAGS) $(OC_CPPFLAGS) -I../runtime $(OC_LDFLAGS) \
	            -DRUNTIME_NAME='"$(BINDIR)/ocamlrun'$$suff'"' \
	            header.c $(OUTPUTEXE)tmpheader$(EXE) && \
	  strip tmpheader$(EXE) && \
	  mv tmpheader$(EXE) camlheader$$suff && \
	  $(CC) $(OC_CFLAGS) $(OC_CPPFLAGS) -I../runtime $(OC_LDFLAGS) \
	            -DRUNTIME_NAME='"$(TARGET_BINDIR)/ocamlrun'$$suff'"' \
	            header.c $(OUTPUTEXE)tmpheader$(EXE) && \
	  strip tmpheader$(EXE) && \
	  mv tmpheader$(EXE) target_camlheader$$suff; \
	done && \
	cp camlheader camlheader_ur

else # Windows

# TODO: see whether there is a way to further merge the rules below
# with those above

camlheader: headernt.c
	$(CC) -c $(OC_CFLAGS) $(OC_CPPFLAGS) -I../runtime \
	          -DRUNTIME_NAME='"ocamlrun"' $(OUTPUTOBJ)headernt.$(O) $<
	$(MKEXE) -o tmpheader.exe headernt.$(O) $(EXTRALIBS)
	rm -f camlheader.exe
	mv tmpheader.exe camlheader

target_camlheader: camlheader
	cp camlheader target_camlheader

camlheader_ur: camlheader
	cp camlheader camlheader_ur

camlheaderd: headernt.c
	$(CC) -c $(OC_CFLAGS) $(OC_CPPFLAGS) -I../runtime \
	          -DRUNTIME_NAME='"ocamlrund"' $(OUTPUTOBJ)headerntd.$(O) $<
	$(MKEXE) -o tmpheaderd.exe headerntd.$(O) $(EXTRALIBS)
	mv tmpheaderd.exe camlheaderd

target_camlheaderd: camlheaderd
	cp camlheaderd target_camlheaderd

camlheaderi: headernt.c
	$(CC) -c $(OC_CFLAGS) $(OC_CPPFLAGS) -I../runtime \
	          -DRUNTIME_NAME='"ocamlruni"' $(OUTPUTOBJ)headernti.$(O) $<
	$(MKEXE) -o tmpheaderi.exe headernti.$(O) $(EXTRALIBS)
	mv tmpheaderi.exe camlheaderi

target_camlheaderi: camlheaderi
	cp camlheaderi target_camlheaderi

# TODO: do not call flexlink to build tmpheader.exe (we don't need
# the export table)

endif # ifeq "$(UNIX_OR_WIN32)" "unix"

endif # ifeq "$(HASHBANGSCRIPTS)" "true"

stdlib.cma: $(OBJS)
	$(CAMLC) -a -o $@ $^

stdlib.cmxa: $(OBJS:.cmo=.cmx)
	$(CAMLOPT) -a -o $@ $^

stdlib.p.cmxa: $(OBJS:.cmo=.p.cmx)
	$(CAMLOPT) -a -o $@ $^

sys.ml: sys.mlp ../VERSION
	sed -e "s|%%VERSION%%|`sed -e 1q ../VERSION | tr -d '\r'`|" sys.mlp > $@

.PHONY: clean
clean::
	rm -f sys.ml

clean::
	rm -f $(CAMLHEADERS)

.SUFFIXES: .mli .ml .cmi .cmo .cmx .p.cmx

export AWK

%.cmi: %.mli
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmi: %.mli
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -o $@ -c $<

%.cmo: %.ml
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmo: %.ml
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -o $@ -c $<

%.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) \
	           -o $@ -c $<

%.p.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) \
	           -p -c -o $@ $<

stdlib__%.p.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) \
	           -p -c -o $@ $<

# Dependencies on the compiler
COMPILER_DEPS=$(filter-out -use-prims, $(COMPILER))
$(OBJS) std_exit.cmo: $(COMPILER_DEPS)
$(OBJS:.cmo=.cmi) std_exit.cmi: $(COMPILER_DEPS)
$(OBJS:.cmo=.cmx) std_exit.cmx: $(OPTCOMPILER)
$(OBJS:.cmo=.p.cmx) std_exit.p.cmx: $(OPTCOMPILER)

# Dependencies on Stdlib (not tracked by ocamldep)
$(OTHERS) std_exit.cmo: stdlib.cmi
$(OTHERS:.cmo=.cmi) std_exit.cmi: stdlib.cmi
$(OBJS:.cmo=.cmx) std_exit.cmx: stdlib.cmi
$(OBJS:.cmo=.p.cmx) std_exit.p.cmx: stdlib.cmi
$(OTHERS:.cmo=.cmx) std_exit.cmx: stdlib.cmx
$(OTHERS:.cmo=.p.cmx) std_exit.p.cmx: stdlib.cmx

clean::
	rm -f *.cm* *.$(O) *.$(A) *.odoc
	rm -f *~
	rm -f camlheader*

include .depend

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

# Note that .p.cmx targets do not depend (for compilation) upon other
# .p.cmx files.  When the compiler imports another compilation unit,
# it looks for the .cmx file (not .p.cmx).
.PHONY: depend
depend:
	$(CAMLDEP) -slash $(filter-out stdlib.%,$(wildcard *.mli *.ml)) \
	  > .depend.tmp
	$(CAMLDEP) -slash -pp "$(AWK) -f remove_module_aliases.awk" \
	  stdlib.ml stdlib.mli >> .depend.tmp
	$(CAMLDEP) -slash $(filter-out stdlib.%,$(wildcard *.ml)) \
	  | sed -e 's/\.cmx : /.p.cmx : /g' >>.depend.tmp
	$(CAMLDEP) -slash -pp "$(AWK) -f remove_module_aliases.awk" stdlib.ml \
	  | sed -e 's/\.cmx : /.p.cmx : /g' >> .depend.tmp
	sed -Ee \
	  's#(^| )(${subst ${SPACE},|,${UNPREFIXED_OBJS}})[.]#\1stdlib__\2.#g' \
	  .depend.tmp > .depend
	rm -f .depend.tmp
