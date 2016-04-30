from pymake.builds.fileset import FilesetBuild, FileBuild
from pymake.builds.vivado_hls import VivadoHlsProjectBuild, VivadoHlsSolution,\
    VivadoHlsVhdlSynthBuild
from pymake.build import Build

prj = VivadoHlsProjectBuild(prj          = FileBuild('$BUILDDIR'),
                            config       = {'top': 'receive'},
                            fileset      = FilesetBuild(match=['$SRCDIR/module/mac1g_receive/hls/*']), 
                            include      = FilesetBuild(['$SRCDIR/module/crc32/hls', '$SRCDIR/module/mac1g_top/hls']),
                            tb_fileset   = FilesetBuild(match=['$SRCDIR/module/mac1g_receive/tb/*']),
                            solutions    = [VivadoHlsSolution(config={'rtl': '-reset all -reset_level high'})]
                  )
synth = VivadoHlsVhdlSynthBuild(prj, env=dict(BUILDDIR='$BUILDDIR/mac1g_receive'))
build = Build(synth=synth, env=dict(BUILDNAME="mac1g_receive", BUILDDIR='../../build', SRCDIR='../'))

if __name__ == "__main__":
    build.cli_build()