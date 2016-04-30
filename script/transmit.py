from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build

prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                            config       = {'top': 'transmit'},
                            fileset      = FilesetBuild(match=['$SRCDIR/module/transmit/hls/*']), 
                            include      = FilesetBuild(['$SRCDIR/module/crc32/hls', '$SRCDIR/module/mac1g_top/hls']),
                            tb_fileset   = FilesetBuild(match=['$SRCDIR/module/transmit/tb/*']),
                            solutions    = [VivadoHlsSolution(config={'rtl': '-reset all -reset_level high'})]
                  )
synth = VivadoHlsVhdlSynthBuild(prj)
build = Build(synth=synth, env=dict(BUILDNAME="transmit", BUILDDIR='../../build/transmit', SRCDIR='../', PICKLEDIR='../../build/pickle'))

if __name__ == "__main__":
    build.cli_build()
