from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build
import sys

prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                            config       = {'top': 'receive'},
                            fileset      = FilesetBuild(match=['$SRCDIR/module/receive/hls/*']), 
                            include      = FilesetBuild(['$SRCDIR/module/crc32/hls', '$SRCDIR/module/mac1g_top/hls']),
                            tb_fileset   = FilesetBuild(match=['$SRCDIR/module/receive/tb/*']),
                            solutions    = [VivadoHlsSolution(clock='-period 40 -name default', 
                                                               config={'rtl': '-reset all -reset_level high'})]
                  )
synth = VivadoHlsVhdlSynthBuild(prj)
build = Build(synth=synth, env=dict(BUILDNAME="receive", BUILDDIR='../../build/receive', SRCDIR='../', PICKLEDIR='../../build/pickle'))

if __name__ == "__main__":
    build.cli_build()
