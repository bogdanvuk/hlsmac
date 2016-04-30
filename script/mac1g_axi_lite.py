from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build

prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                            config       = {'top': 'axi_lite'},
                            fileset      = FilesetBuild(match=['$SRCDIR/module/axi_lite/hls/*']), 
                            include      = FilesetBuild(['$SRCDIR/module/mac1g_top/hls', '$SRCDIR/module/mac1g_transmit/hls', '$SRCDIR/module/mac1g_receive/hls']),
                            cflags       = '-DRELEASE',
                            solutions    = [VivadoHlsSolution(config={'rtl': '-reset all -reset_level high'})]
                  )
synth = VivadoHlsVhdlSynthBuild(prj, env=dict(BUILDDIR='$BUILDDIR/mac1g_axi_lite'))
build = Build(synth=synth, env=dict(BUILDNAME="mac1g_axi_lite", BUILDDIR='../../build', SRCDIR='../'))

if __name__ == "__main__":
    build.cli_build()
