from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build

prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                            config       = {'top': 'transmit'},
                            fileset      = FilesetBuild(match=['$SRCDIR/module/mac1g_transmit/hls/*']), 
                            include      = FilesetBuild(['$SRCDIR/module/crc32/hls', '$SRCDIR/module/mac1g_top/hls']),
                            cflags       = '-DRELEASE',
                            tb_fileset   = FilesetBuild(match=['$SRCDIR/module/mac1g_transmit/tb/*']),
                            solutions    = [VivadoHlsSolution(config={'rtl': '-reset all -reset_level high'})]
                  )
synth = VivadoHlsVhdlSynthBuild(prj, env=dict(BUILDDIR='$BUILDDIR/mac1g_transmit'))
build = Build(synth=synth, env=dict(BUILDNAME="mac1g_transmit", BUILDDIR='../../build', SRCDIR='../'))

if __name__ == "__main__":
    build.cli_build()
