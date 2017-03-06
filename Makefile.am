# The actual runnable program is set to the SCRIPTS primitive.
# # Prefix bin_ tells where to copy this
bin_PROGRAMS = mrun
mrun_CFLAGS = $(gtk_CFLAGS)
mrun_LDADD = $(gtk_LIBS)
mrun_VALAFLAGS = --pkg gtk+-3.0
mrun_SOURCES = mrun.vala

desktopdir = $(datadir)/applications
desktop_DATA = \
	mrun.desktop
